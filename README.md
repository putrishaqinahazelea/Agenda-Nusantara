# Agenda Nusantara

Agenda Nusantara merupakan aplikasi mobile berbasis database lokal yang dirancang untuk membantu pengguna mencatat, mengatur, dan memonitor aktivitas serta tugas harian. Aplikasi ini dikembangkan berdasarkan skenario **Tes Observasi SERTIKOM BNSP DIPA 2026** pada skema **Pemrograman Aplikasi Mobile Berbasis Database**.

Seluruh data pada aplikasi disimpan secara offline menggunakan **SQLite**, sehingga aplikasi tetap dapat digunakan tanpa membutuhkan koneksi internet, server, maupun layanan API eksternal.

---

## Deskripsi Aplikasi

Aplikasi **Agenda Nusantara** digunakan untuk mengelola daftar tugas (*todo list*) yang dibagi menjadi dua jenis kategori, yaitu:

1. **Tugas Penting**
2. **Tugas Biasa**

Setiap data tugas menyimpan informasi berupa tanggal deadline, judul tugas, deskripsi, kategori tugas, serta status penyelesaian. Selain itu, pengguna juga dapat melihat statistik jumlah tugas yang telah selesai maupun yang masih pending pada halaman utama aplikasi.

---

## Fitur Utama

- Login menggunakan username dan password.
- Menampilkan statistik tugas selesai dan belum selesai.
- Menambahkan tugas penting.
- Menambahkan tugas biasa.
- Menyimpan data menggunakan database lokal SQLite.
- Menampilkan daftar tugas dalam bentuk list yang dapat di-scroll.
- Menandai tugas sebagai selesai.
- Menampilkan indikator warna berdasarkan kategori tugas.
- Mengubah password melalui halaman pengaturan.
- Menampilkan informasi developer aplikasi.

---

## Tampilan Aplikasi

### 1. Halaman Login

![Halaman Login](login.png)

Halaman Login digunakan sebagai akses awal pengguna sebelum masuk ke aplikasi.

Fitur:
- Logo aplikasi
- Nama aplikasi
- Input username
- Input password
- Tombol login
- Validasi akun default

---

### 2. Halaman Beranda

![Halaman Beranda](beranda.png)

Halaman Beranda menampilkan informasi utama dan menu navigasi aplikasi.

Fitur:
- Total tugas selesai
- Total tugas belum selesai
- Grafik tugas selesai harian
- Navigasi ke halaman:
  - Tambah Tugas Penting
  - Tambah Tugas Biasa
  - Daftar Tugas
  - Pengaturan

---

### 3. Halaman Tambah Tugas Penting

![Tambah Tugas Penting](penting.png)

Halaman ini digunakan untuk menambahkan tugas kategori **Penting**.

Data yang diinput:
- Tanggal jatuh tempo menggunakan date picker
- Judul tugas
- Deskripsi tugas

---

### 4. Halaman Tambah Tugas Biasa

![Tambah Tugas Biasa](biasa.png)

Halaman ini digunakan untuk menambahkan tugas kategori **Biasa**.

Data yang diinput:
- Tanggal jatuh tempo menggunakan date picker
- Judul tugas
- Deskripsi tugas

---

### 5. Halaman Daftar Tugas

![Daftar Tugas](daftar tugas.png)

Halaman ini menampilkan seluruh tugas yang telah disimpan.

Fitur:
- Menampilkan seluruh data tugas
- List dapat di-scroll
- Menampilkan judul dan deadline tugas
- Indikator warna kategori:
  - Merah untuk tugas penting
  - Hijau untuk tugas biasa
- Menandai tugas sebagai selesai

---

### 6. Halaman Pengaturan

![Halaman Pengaturan](pengaturan.png)

Halaman Pengaturan digunakan untuk mengganti password pengguna.

Fitur:
- Input password lama
- Input password baru
- Validasi password
- Menampilkan identitas developer

---

## Teknologi yang Digunakan

- Flutter
- Dart
- SQLite (`sqflite`)
- Intl
- Path

---

## Cara Menjalankan Project

Clone repository:

```bash
git clone https://github.com/username/agenda_nusantara.git
