-- Setup Supabase SewaSkill (tabel, RLS, RPC, storage)


-- 1. TABEL

create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  nama         text not null,
  lokasi       text not null default '',
  role         text not null default 'pencari' check (role in ('pencari','penyedia','admin')),
  status       text not null default 'aktif'   check (status in ('aktif','diblokir')),
  saldo        bigint not null default 0 check (saldo >= 0),
  avatar_path  text,
  created_at   timestamptz not null default now()
);

create table if not exists public.talents (
  id             uuid primary key default gen_random_uuid(),
  owner_id       uuid not null references public.profiles(id) on delete cascade,
  nama           text not null,
  bidang         text not null,
  harga_mulai    int  not null check (harga_mulai > 0),
  deskripsi      text not null,
  portfolio_url  text,
  created_at     timestamptz not null default now()
);
create index if not exists talents_owner_idx on public.talents(owner_id);

create table if not exists public.orders (
  id               uuid primary key default gen_random_uuid(),
  talent_id        uuid references public.talents(id) on delete set null,
  nama_jasa        text not null default '',           -- salinan nama jasa, tetap ada walau jasa dihapus
  buyer_id         uuid not null references public.profiles(id),
  seller_id        uuid not null references public.profiles(id),
  paket            text not null check (paket in ('Basic','Standard','Premium')),
  total            int  not null default 0,
  catatan          text not null default '',
  status           text not null default 'menunggu_pembayaran' check (status in (
                     'menunggu_pembayaran','dibayar','dikirim',
                     'menunggu_admin','selesai','direfund','dibatalkan')),
  midtrans_order_id   text,                            -- order_id yang dikirim ke Midtrans ({id}_{suffix})
  payment_url         text,                            -- link Snap, dipakai ulang selama belum kedaluwarsa
  payment_expires_at  timestamptz,
  metode_bayar        text,                            -- payment_type dari Midtrans (bank_transfer, qris, dst.)
  dibayar_at          timestamptz,
  hasil_kerja      text,
  keputusan_buyer  text check (keputusan_buyer in ('diterima','komplain')),
  alasan_komplain  text,
  created_at       timestamptz not null default now()
);
create index if not exists orders_buyer_idx  on public.orders(buyer_id);
create index if not exists orders_seller_idx on public.orders(seller_id);
create index if not exists orders_status_idx on public.orders(status);

create table if not exists public.reviews (
  id          uuid primary key default gen_random_uuid(),
  talent_id   uuid not null references public.talents(id) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  rating      int  not null check (rating between 1 and 5),
  komentar    text not null default '',
  created_at  timestamptz not null default now()
);
create index if not exists reviews_talent_idx on public.reviews(talent_id);

create table if not exists public.favorites (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  talent_id  uuid not null references public.talents(id) on delete cascade,
  unique (user_id, talent_id)
);
create index if not exists favorites_user_idx on public.favorites(user_id);

create table if not exists public.transaksi (
  id          uuid primary key default gen_random_uuid(),
  order_id    uuid references public.orders(id) on delete set null,
  user_id     uuid not null references public.profiles(id),
  jenis       text not null check (jenis in ('pembayaran_seller','refund_buyer')),
  nominal     int  not null,
  created_at  timestamptz not null default now()
);
create index if not exists transaksi_user_idx on public.transaksi(user_id);


-- 2. FUNGSI BANTU DAN TRIGGER

-- Cek apakah user yang sedang login adalah admin aktif.
create or replace function public.is_admin()
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin' and status = 'aktif'
  );
$$;

-- Cek role user login (dipakai di policy).
create or replace function public.my_role()
returns text
language sql stable security definer set search_path = public
as $$
  select role from public.profiles where id = auth.uid() and status = 'aktif';
$$;

-- Buat baris profiles otomatis saat user register.
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles (id, nama, lokasi, role)
  values (
    new.id,
    coalesce(nullif(trim(new.raw_user_meta_data->>'nama'), ''), split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'lokasi', ''),
    case when new.raw_user_meta_data->>'role' = 'penyedia' then 'penyedia' else 'pencari' end
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Order baru: seller, nama jasa, total, dan status diisi server (tidak percaya data dari app).
create or replace function public.orders_before_insert()
returns trigger
language plpgsql security definer set search_path = public
as $$
declare
  t public.talents;
begin
  select * into t from public.talents where id = new.talent_id;
  if not found then
    raise exception 'Jasa tidak ditemukan';
  end if;
  if t.owner_id = new.buyer_id then
    raise exception 'Tidak bisa memesan jasa sendiri';
  end if;

  new.seller_id       := t.owner_id;
  new.nama_jasa       := t.nama;
  new.total           := case new.paket
                           when 'Basic'    then t.harga_mulai
                           when 'Standard' then t.harga_mulai * 2
                           else                 t.harga_mulai * 4
                         end;
  new.status          := 'menunggu_pembayaran';
  new.midtrans_order_id  := null;
  new.payment_url        := null;
  new.payment_expires_at := null;
  new.metode_bayar       := null;
  new.dibayar_at         := null;
  new.hasil_kerja     := null;
  new.keputusan_buyer := null;
  new.alasan_komplain := null;
  return new;
end;
$$;

drop trigger if exists orders_before_insert on public.orders;
create trigger orders_before_insert
  before insert on public.orders
  for each row execute function public.orders_before_insert();


-- 3. VIEW RATING
create or replace view public.talent_stats as
select
  t.id as talent_id,
  coalesce(round(avg(r.rating)::numeric, 1), 0) as rata_rata,
  count(distinct r.id) as jumlah_ulasan,
  (select count(*) from public.orders o where o.talent_id = t.id and o.status = 'selesai') as jumlah_order
from public.talents t
left join public.reviews r on r.talent_id = t.id
group by t.id;

revoke all on public.talent_stats from anon;
grant select on public.talent_stats to authenticated;


-- 4. HAK AKSES KOLOM
revoke insert, update, delete on public.profiles  from anon, authenticated;
revoke update                 on public.orders    from anon, authenticated;
revoke insert, update, delete on public.transaksi from anon, authenticated;

grant select on public.profiles to authenticated;
grant update (nama, lokasi, avatar_path) on public.profiles to authenticated;


-- 5. ROW LEVEL SECURITY
alter table public.profiles  enable row level security;
alter table public.talents   enable row level security;
alter table public.orders    enable row level security;
alter table public.reviews   enable row level security;
alter table public.favorites enable row level security;
alter table public.transaksi enable row level security;

-- profiles: semua user login boleh membaca profil
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select to authenticated using (true);

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- talents
drop policy if exists talents_select on public.talents;
create policy talents_select on public.talents
  for select to authenticated using (true);

drop policy if exists talents_insert on public.talents;
create policy talents_insert on public.talents
  for insert to authenticated
  with check (owner_id = auth.uid() and public.my_role() = 'penyedia');

drop policy if exists talents_update on public.talents;
create policy talents_update on public.talents
  for update to authenticated
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists talents_delete on public.talents;
create policy talents_delete on public.talents
  for delete to authenticated using (owner_id = auth.uid());

-- orders: baca = buyer, seller, atau admin. Insert = pencari. Update hanya lewat RPC.
drop policy if exists orders_select on public.orders;
create policy orders_select on public.orders
  for select to authenticated
  using (buyer_id = auth.uid() or seller_id = auth.uid() or public.is_admin());

drop policy if exists orders_insert on public.orders;
create policy orders_insert on public.orders
  for insert to authenticated
  with check (buyer_id = auth.uid() and public.my_role() = 'pencari');

drop policy if exists orders_delete on public.orders;
create policy orders_delete on public.orders
  for delete to authenticated
  using (buyer_id = auth.uid() and status in ('dibatalkan','selesai','direfund'));

-- reviews
drop policy if exists reviews_select on public.reviews;
create policy reviews_select on public.reviews
  for select to authenticated using (true);

drop policy if exists reviews_insert on public.reviews;
create policy reviews_insert on public.reviews
  for insert to authenticated
  with check (user_id = auth.uid() and public.my_role() = 'pencari');

drop policy if exists reviews_update on public.reviews;
create policy reviews_update on public.reviews
  for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists reviews_delete on public.reviews;
create policy reviews_delete on public.reviews
  for delete to authenticated using (user_id = auth.uid());

-- favorites: hanya milik sendiri
drop policy if exists favorites_select on public.favorites;
create policy favorites_select on public.favorites
  for select to authenticated using (user_id = auth.uid());

drop policy if exists favorites_insert on public.favorites;
create policy favorites_insert on public.favorites
  for insert to authenticated with check (user_id = auth.uid());

drop policy if exists favorites_delete on public.favorites;
create policy favorites_delete on public.favorites
  for delete to authenticated using (user_id = auth.uid());

-- transaksi: baca milik sendiri atau admin. Tulis hanya lewat RPC.
drop policy if exists transaksi_select on public.transaksi;
create policy transaksi_select on public.transaksi
  for select to authenticated
  using (user_id = auth.uid() or public.is_admin());


-- 6. RPC: status order dan aksi admin

-- Dipanggil Edge Function saat pembayaran berhasil untuk mengubah status order ke dibayar
create or replace function public.order_tandai_dibayar(p_order uuid, p_midtrans_order_id text, p_metode text)
returns void
language plpgsql security definer set search_path = public
as $$
begin
  update public.orders
     set status            = 'dibayar',
         midtrans_order_id = coalesce(p_midtrans_order_id, midtrans_order_id),
         metode_bayar      = p_metode,
         dibayar_at        = now()
   where id = p_order and status = 'menunggu_pembayaran';
end;
$$;

-- Buyer: batalkan order yang belum dibayar.
create or replace function public.order_batalkan(p_order uuid)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  o public.orders;
begin
  select * into o from public.orders where id = p_order for update;
  if not found or o.buyer_id <> auth.uid() then
    raise exception 'Order tidak ditemukan';
  end if;
  if o.status <> 'menunggu_pembayaran' then
    raise exception 'Order yang sudah dibayar tidak bisa dibatalkan';
  end if;

  update public.orders set status = 'dibatalkan' where id = p_order;
end;
$$;

-- Seller: tandai pekerjaan selesai → status dikirim. Catatan/link hasil bersifat opsional.
create or replace function public.order_kirim_hasil(p_order uuid, p_hasil text default null)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  o public.orders;
begin
  select * into o from public.orders where id = p_order for update;
  if not found or o.seller_id <> auth.uid() then
    raise exception 'Order tidak ditemukan';
  end if;
  if o.status <> 'dibayar' then
    raise exception 'Order belum dibayar atau hasil sudah dikirim';
  end if;
  update public.orders
     set hasil_kerja = nullif(trim(coalesce(p_hasil, '')), ''), status = 'dikirim'
   where id = p_order;
end;
$$;

-- Buyer: terima atau komplain → status menunggu_admin.
create or replace function public.order_keputusan(p_order uuid, p_keputusan text, p_alasan text default null)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  o public.orders;
begin
  select * into o from public.orders where id = p_order for update;
  if not found or o.buyer_id <> auth.uid() then
    raise exception 'Order tidak ditemukan';
  end if;
  if o.status <> 'dikirim' then
    raise exception 'Hasil kerja belum dikirim';
  end if;
  if p_keputusan not in ('diterima','komplain') then
    raise exception 'Keputusan tidak valid';
  end if;
  if p_keputusan = 'komplain' and (p_alasan is null or length(trim(p_alasan)) = 0) then
    raise exception 'Alasan komplain wajib diisi';
  end if;

  update public.orders
     set keputusan_buyer = p_keputusan,
         alasan_komplain = case when p_keputusan = 'komplain' then trim(p_alasan) else null end,
         status = 'menunggu_admin'
   where id = p_order;
end;
$$;

-- Admin: setujui → saldo seller bertambah, status selesai.
create or replace function public.admin_approve_order(p_order uuid)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  o public.orders;
begin
  if not public.is_admin() then
    raise exception 'Hanya admin yang boleh melakukan ini';
  end if;

  select * into o from public.orders where id = p_order for update;
  if not found then
    raise exception 'Order tidak ditemukan';
  end if;
  if o.status <> 'menunggu_admin' then
    raise exception 'Order tidak menunggu persetujuan admin';
  end if;

  update public.profiles set saldo = saldo + o.total where id = o.seller_id;
  insert into public.transaksi (order_id, user_id, jenis, nominal)
    values (o.id, o.seller_id, 'pembayaran_seller', o.total);
  update public.orders set status = 'selesai' where id = o.id;
end;
$$;

-- Admin: tolak → saldo buyer dikembalikan, status direfund.
create or replace function public.admin_reject_order(p_order uuid)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  o public.orders;
begin
  if not public.is_admin() then
    raise exception 'Hanya admin yang boleh melakukan ini';
  end if;

  select * into o from public.orders where id = p_order for update;
  if not found then
    raise exception 'Order tidak ditemukan';
  end if;
  if o.status <> 'menunggu_admin' then
    raise exception 'Order tidak menunggu persetujuan admin';
  end if;

  update public.profiles set saldo = saldo + o.total where id = o.buyer_id;
  insert into public.transaksi (order_id, user_id, jenis, nominal)
    values (o.id, o.buyer_id, 'refund_buyer', o.total);
  update public.orders set status = 'direfund' where id = o.id;
end;
$$;

-- Admin: blokir / aktifkan akun.
create or replace function public.admin_set_status_akun(p_user uuid, p_status text)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  target public.profiles;
begin
  if not public.is_admin() then
    raise exception 'Hanya admin yang boleh melakukan ini';
  end if;
  if p_status not in ('aktif','diblokir') then
    raise exception 'Status tidak valid';
  end if;
  if p_user = auth.uid() then
    raise exception 'Tidak bisa mengubah status akun sendiri';
  end if;

  select * into target from public.profiles where id = p_user;
  if not found then
    raise exception 'User tidak ditemukan';
  end if;
  if target.role = 'admin' then
    raise exception 'Tidak bisa mengubah akun admin';
  end if;

  update public.profiles set status = p_status where id = p_user;
end;
$$;

-- Admin: ubah role pencari <-> penyedia.
create or replace function public.admin_set_role_akun(p_user uuid, p_role text)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  target public.profiles;
begin
  if not public.is_admin() then
    raise exception 'Hanya admin yang boleh melakukan ini';
  end if;
  if p_role not in ('pencari','penyedia') then
    raise exception 'Role tidak valid';
  end if;
  if p_user = auth.uid() then
    raise exception 'Tidak bisa mengubah role sendiri';
  end if;

  select * into target from public.profiles where id = p_user;
  if not found then
    raise exception 'User tidak ditemukan';
  end if;
  if target.role = 'admin' then
    raise exception 'Tidak bisa mengubah akun admin';
  end if;

  update public.profiles set role = p_role where id = p_user;
end;
$$;

-- Fungsi RPC hanya boleh dipanggil user yang sudah login.
revoke all on function public.is_admin()                                  from public, anon;
revoke all on function public.my_role()                                   from public, anon;
revoke all on function public.order_tandai_dibayar(uuid, text, text)      from public, anon, authenticated;
revoke all on function public.order_batalkan(uuid)                        from public, anon;
revoke all on function public.order_kirim_hasil(uuid, text)               from public, anon;
revoke all on function public.order_keputusan(uuid, text, text)           from public, anon;
revoke all on function public.admin_approve_order(uuid)                   from public, anon;
revoke all on function public.admin_reject_order(uuid)                    from public, anon;
revoke all on function public.admin_set_status_akun(uuid, text)           from public, anon;
revoke all on function public.admin_set_role_akun(uuid, text)             from public, anon;

grant execute on function public.is_admin()                               to authenticated;
grant execute on function public.my_role()                                to authenticated;
grant execute on function public.order_tandai_dibayar(uuid, text, text)   to service_role;
grant execute on function public.order_batalkan(uuid)                     to authenticated;
grant execute on function public.order_kirim_hasil(uuid, text)            to authenticated;
grant execute on function public.order_keputusan(uuid, text, text)        to authenticated;
grant execute on function public.admin_approve_order(uuid)                to authenticated;
grant execute on function public.admin_reject_order(uuid)                 to authenticated;
grant execute on function public.admin_set_status_akun(uuid, text)        to authenticated;
grant execute on function public.admin_set_role_akun(uuid, text)          to authenticated;


-- 7. STORAGE BUCKET (avatar: public)
insert into storage.buckets (id, name, public)
values ('avatar', 'avatar', true)
on conflict (id) do nothing;

-- avatar: user hanya boleh menulis file bernama id sendiri
drop policy if exists avatar_select on storage.objects;
create policy avatar_select on storage.objects
  for select to authenticated using (bucket_id = 'avatar');

drop policy if exists avatar_insert on storage.objects;
create policy avatar_insert on storage.objects
  for insert to authenticated
  with check (bucket_id = 'avatar' and name = auth.uid()::text || '.jpg');

drop policy if exists avatar_update on storage.objects;
create policy avatar_update on storage.objects
  for update to authenticated
  using (bucket_id = 'avatar' and name = auth.uid()::text || '.jpg')
  with check (bucket_id = 'avatar' and name = auth.uid()::text || '.jpg');

drop policy if exists avatar_delete on storage.objects;
create policy avatar_delete on storage.objects
  for delete to authenticated
  using (bucket_id = 'avatar' and name = auth.uid()::text || '.jpg');


-- 8. SET ADMIN: update public.profiles set role = 'admin' where id = (select id from auth.users where email = 'admin@contoh.com');


-- 9. MIGRASI DARI VERSI LAMA
alter table public.orders add column if not exists midtrans_order_id  text;
alter table public.orders add column if not exists payment_url        text;
alter table public.orders add column if not exists payment_expires_at timestamptz;
alter table public.orders add column if not exists metode_bayar       text;
alter table public.orders add column if not exists dibayar_at         timestamptz;

-- policy lama harus dihapus sebelum kolom bukti_transfer dibuang
drop policy if exists bukti_insert on storage.objects;
drop policy if exists bukti_update on storage.objects;
drop policy if exists bukti_select on storage.objects;
drop function if exists public.order_upload_bukti(uuid, text);
alter table public.orders drop column if exists bukti_transfer;
-- Bucket 'bukti-transfer' (kalau pernah dibuat) hapus manual lewat Dashboard → Storage.


-- 10. SEEDER AKUN TESTING (deva@gmail.com / deva123)
create extension if not exists pgcrypto;
insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
values (
  '00000000-0000-0000-0000-000000000000',
  'd0000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'deva@gmail.com',
  crypt('deva123', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"nama":"Deva","lokasi":"Bandung, Jawa Barat","role":"pencari"}',
  now(),
  now()
)
on conflict (id) do nothing;
