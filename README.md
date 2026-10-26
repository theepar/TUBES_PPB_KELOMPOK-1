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

1. **Beranda (`lib/pages/beranda_page.dart`)**
   - Banner pengenalan platform SewaSkill
   - Navigasi cepat: *Cari Talent* dan *Daftarkan Jasa*
   - Seksi kategori jasa populer (Edit Video, Desain Thumbnail, Tutor Koding, Penulisan Konten)
   - Seksi keunggulan layanan dan testimoni pengguna

2. **Katalog Jasa (`lib/pages/katalog_page.dart`)**
   - Penjelajahan daftar talent freelance
   - Pencarian dan filter kategori keahlian

3. **Detail Jasa (`lib/pages/detail_jasa_page.dart`)**
   - Profil lengkap talent, bidang keahlian, rating, dan jumlah ulasan
   - Rincian opsi paket jasa (Basic, Standard, Premium)

4. **Tambah Jasa (`lib/pages/tambah_jasa_page.dart`)**
   - Formulir registrasi dan penawaran jasa baru bagi freelancer

5. **Pemesanan / Order (`lib/pages/order_page.dart`)**
   - Pemilihan tingkatan paket jasa (Basic, Standard, Premium)
   - Kalkulasi otomatis rincian biaya (harga paket + biaya layanan 5% + total biaya)
   - Formulir kelengkapan identitas pemesan (nama, email, nomor telepon, catatan pesanan)
   - Pilihan metode pembayaran (Transfer Bank & E-Wallet: BCA, Mandiri, BRI, GoPay, OVO, DANA)
   - Validasi input form di sisi klien serta notifikasi konfirmasi pemesanan

---

## Cara Menjalankan Proyek

### 1. Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.13 ke atas)
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

```text
TUBES_PPB_KELOMPOK-1/
├── android/                      # Konfigurasi native Android
├── ios/                          # Konfigurasi native iOS
├── lib/                          # Kode sumber utama Flutter
│   ├── pages/                    # Komponen halaman antarmuka
│   │   ├── beranda_page.dart     # Halaman utama & pengenalan platform
│   │   ├── detail_jasa_page.dart # Halaman profil talent & paket
│   │   ├── katalog_page.dart     # Halaman katalog penjelajahan jasa
│   │   ├── order_page.dart       # Halaman kalkulasi dan checkout pemesanan
│   │   └── tambah_jasa_page.dart # Halaman pendaftaran jasa baru
│   ├── talent.dart               # Model data Talent & logika harga paket
│   ├── talent_data.dart          # Mock dataset talent freelance
│   └── main.dart                 # Entry point aplikasi & konfigurasi tema Material 3
├── test/                         # Pengujian unit & widget
├── pubspec.yaml                  # Konfigurasi dependensi dan metadata proyek
└── README.md                     # Dokumentasi proyek
```
