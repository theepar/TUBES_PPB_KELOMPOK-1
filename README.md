# SewaSkill - Platform Freelance Jasa Digital (Mobile App)

> Tugas Besar - Pemrograman Perangkat Bergerak  
> Kelompok 1

---

## Deskripsi Proyek

SewaSkill adalah aplikasi mobile untuk mencari dan memesan jasa freelance digital skala mikro, seperti edit video, desain grafis, bimbingan koding, dan penulisan konten.

Aplikasi ini dikembangkan menggunakan **Flutter** dan **Dart** dengan antarmuka modern berbasis **Material Design 3**, mendukung arsitektur modular multi-platform (Android, iOS, dsb).

---

## Tim Pengembang

| No  | Nama Anggota                  |      GitHub      |
| :-: | :---------------------------- | :--------------: |
|  1  | **Fadhil R.**                 |   `@fadhilr2`    |
|  2  | **I Putu Gede Deva Gundhala** |    `@theepar`    |
|  3  | **Adita R.**                  |   `@aditarhm`    |
|  4  | **Jeni**                      | `@ejeniamutiara` |
|  5  | **Abdurrahman Saleh**         |  `@JustAHermit`  |

---

## Tech Stack

- **Framework:** Flutter (Channel stable)
- **Language:** Dart (SDK ^3.13.2)
- **UI & Design System:** Material Design 3 (`ThemeData` ColorScheme from seed)
- **Linter & Code Style:** `flutter_lints: ^6.0.0`
- **Target Platform:** Android & iOS

---

## Halaman dan Fitur

Aplikasi ini merupakan demo frontend dengan data dummy dalam memori. Tidak ada database, API, Supabase, atau Midtrans yang terhubung. Data kembali ke awal saat aplikasi dimulai ulang. Hot reload dapat mempertahankan state; gunakan hot restart untuk mengulang demo dari awal.

| Halaman | Fitur |
|---|---|
| Login/Register | Validasi form, akun baru selalu pencari, tiga pilihan akun demo, penolakan akun diblokir |
| Beranda | Sapaan, statistik, rekomendasi kota, rekomendasi sesuai kebutuhan, jasa terakhir dilihat. Akun penyedia juga melihat grafik usahanya: kali dibeli, rating rata-rata, pembelian per jasa, sebaran rating, ulasan terbaru |
| Katalog | Pencarian nama jasa, talent, dan lokasi; favorit, edit/hapus jasa milik penyedia sendiri |
| Detail Jasa | Paket, portfolio, komentar dan bintang, tambah/edit/hapus ulasan milik sendiri |
| Tambah/Edit Jasa | Nama jasa, lokasi, validasi form, harga Basic/Standard/Premium diisi secara terpisah |
| Order | Data pemesan, brief, pilihan paket/metode, biaya layanan 5% |
| Pembayaran | Dua aksi utama; hasil berhasil/gagal dipilih pada panel simulasi terpisah; cek status melalui dialog |
| Riwayat Order | Filter status, bayar ulang, batal, hasil kerja, diterima/komplain, hapus riwayat akhir |
| Favorit | Daftar favorit per akun, hapus favorit dengan konfirmasi |
| Profil | Edit nama/lokasi, saldo demo, logout, daftar menjadi penyedia |
| Daftar Penyedia | Pencari mengisi keahlian, pengalaman, dan lokasi untuk mulai menawarkan jasa |
| Manajemen Pembelian | Detail order, approve ke saldo penyedia, reject/refund ke saldo pembeli |
| Manajemen Akun | Cari akun, tambah akun baru, edit nama/lokasi, blokir/aktifkan, ubah role, hapus akun; akun admin dilindungi |
| Hapus Akun Sendiri | Pencari/penyedia menghapus akunnya dari Profil; jasa, ulasan, favorit ikut terhapus. Ditolak jika masih ada pesanan aktif |

`main.dart` menjalankan `SewaSkillApp` dari `app/app.dart`. `SewaSkillApp` membuka login atau `MainPage` sesuai sesi. `MainPage` memegang navbar dan tab. Beranda merupakan salah satu tab, bukan pengatur seluruh aplikasi.

Akun pencari dan penyedia memiliki lima tab: Beranda, Katalog, Riwayat, Favorit, Profil. Akun admin langsung masuk Panel Admin dengan tab Ringkasan, Akun, Postingan, dan Keamanan. Akun admin tidak memiliki beranda pelanggan, katalog, favorit, atau mode akun biasa. Peninjauan pesanan tersedia lewat **Tinjau pesanan** di Ringkasan admin.

### Akun demo

| Role | Email | Password |
|---|---|---|
| Pencari | `deva@example.com` | `demo123` |
| Penyedia | `rizky@example.com` | `demo123` |
| Admin | `admin@example.com` | `demo123` |

Registrasi selalu membuat akun pencari. Untuk menjadi penyedia, buka Profil lalu pilih **Daftar menjadi penyedia** dan lengkapi data keahlian. Tombol **Demo penyedia** masuk ke akun contoh yang sudah terdaftar sebagai penyedia.

Gunakan tombol akun demo pada halaman login untuk masuk langsung. Logout lalu masuk dengan role berbeda untuk melanjutkan pesanan yang sama. Semua akun tambahan pada demo juga memakai password `demo123`.

### Alur demo lengkap

1. Masuk sebagai pencari. Pilih jasa, isi order, lalu simulasikan pembayaran berhasil.
2. Masuk sebagai penyedia. Buka Riwayat dan pilih **Tandai selesai** pada pesanan yang dibayar.
3. Masuk kembali sebagai pencari. Pilih **Pekerjaan diterima** atau **Ajukan komplain**.
4. Masuk sebagai admin, lalu pilih **Tinjau pesanan** di Ringkasan admin.
5. Pilih **Approve** untuk menambah saldo demo penyedia sebesar harga jasa, atau **Reject / Refund** untuk menambah saldo demo pembeli sebesar total pembayaran termasuk biaya layanan.

Setiap status juga memiliki contoh pesanan awal agar halaman dapat langsung dicoba. Hapus riwayat menyembunyikan pesanan dari daftar pembeli, sementara catatan admin tetap tersedia.

---

## Cara Menjalankan Proyek

### 1. Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (dengan Dart SDK yang sesuai `pubspec.yaml`, saat ini `^3.13.2`)
- [Android Studio](https://developer.android.com/studio) / VS Code dengan ekstensi Flutter & Dart
- Emulator Android / iOS Simulator atau perangkat fisik dengan fitur *USB Debugging* aktif

### 2. Clone Repository

```bash
git clone https://github.com/theepar/TUBES_PPB_KELOMPOK-1.git
cd TUBES_PPB_KELOMPOK-1
```

### 3. Install Dependensi

Jalankan perintah berikut untuk mengunduh semua paket dependensi:

```bash
flutter pub get
```

### 4. Jalankan Aplikasi

Pastikan emulator atau perangkat target sudah terhubung:

```bash
flutter run
```

### 5. Perintah Lainnya

- Menjalankan analisis kode dan linter:
  ```bash
  flutter analyze
  ```
- Build APK Android (Release):
  ```bash
  flutter build apk --release
  ```

---

## Struktur Folder

Project memakai struktur **by feature** yang sederhana. Setiap fitur menyimpan halamannya sendiri. Model, data dummy, dan widget yang dipakai lintas fitur ada di `core`.

```text
lib/
  main.dart                         # Entry point
  app/
    app.dart                        # App, theme, and login gate
    main_page.dart                  # Main tabs and navigation
    app_route.dart                  # Instant page navigation
    widgets/
      navbar.dart
  core/
    data/
      demo_store.dart               # Shared in-memory ChangeNotifier: state, seed data, getters
      store_sesi.dart               # Login, register, logout, edit profile
      store_akun.dart               # Provider signup, admin account CRUD, delete own account
      store_jasa.dart               # Save and delete services
      store_katalog.dart            # Favorites and admin post moderation
      store_ulasan.dart             # Review create, update, delete
      store_pesanan.dart            # Order, payment, delivery, decisions
      store_statistik.dart          # Provider business statistics
      talent_data.dart              # Initial service data
    models/
      pengguna.dart
      talent.dart
      pesanan.dart
      ulasan.dart
      statistik_penyedia.dart
    utils/
      validators.dart               # Shared email and password validators
    theme/
      app_colors.dart
      app_spacing.dart
    widgets/
      demo_ui.dart                  # Shared dialogs and status badge
      talent_card.dart              # Catalog and favorites card
      choice_pill.dart              # Accessible horizontal filter controls
      app_select.dart               # Custom selection and action menus
  features/
    auth/pages/
      auth_page.dart
    beranda/
      pages/beranda_page.dart
      widgets/ringkasan_beranda.dart
      widgets/dashboard_penyedia.dart
    katalog/pages/
      katalog_page.dart
    jasa/pages/
      detail_jasa_page.dart
      tambah_jasa_page.dart
    order/pages/
      order_page.dart
      pembayaran_page.dart
      riwayat_order_page.dart
    order/widgets/
      order_detail_sheet.dart
    favorit/pages/
      favorit_page.dart
    profil/pages/
      profil_page.dart
      daftar_penyedia_page.dart
    admin/pages/
      admin_shell_page.dart
      admin_dashboard_page.dart
      admin_postingan_page.dart
      admin_keamanan_page.dart
      admin_pembelian_page.dart
      admin_akun_page.dart
      admin_form_akun_page.dart
```

- Tambahkan halaman dan widget khusus fitur di dalam `features/<nama-fitur>/`.
- Gunakan `core/widgets/` untuk komponen yang benar-benar dipakai lintas fitur.
- Simpan state dummy bersama di `core/data/demo_store.dart` agar akun, pesanan, favorit, ulasan, dan saldo tetap sinkron.
- `app/main_page.dart` mengatur tab; halaman fitur tidak memegang navbar utama.

Tidak ada tambahan layer MVVM, repository, atau paket state management. Data tetap disimpan dalam memori. Tautan portfolio dibuka melalui browser eksternal menggunakan `url_launcher`.

Jalankan `flutter analyze` untuk memeriksa kode sebelum commit.
