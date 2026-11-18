# MyPortfolio Mobile

Implementasi Tutorial 08: Basic Flutter, PBP Gasal 2026/2027.

Halaman utama menggunakan StatelessWidget, InfoCard untuk identitas pemilik portofolio, dan ItemCard untuk Lihat Proyek, Tambah Proyek, serta Logout. Pada Tutorial 08, setiap tombol menampilkan SnackBar.

## Tutorial 09

Drawer menyediakan menu Home dan Add Project. Form juga bisa dibuka lewat kartu Tambah Proyek. Isi nama dan deskripsi, pilih kategori, lalu isi teknologi dan tautan bila diperlukan. Tombol Save menampilkan isian pada dialog. Tombol OK menutup dialog dan mereset form. Data belum disimpan ke database.

## Menjalankan aplikasi

```sh
flutter pub get
flutter run -d chrome
```

## Pemeriksaan

```sh
flutter analyze
flutter test
```

### Tugas 7

1. **Apa itu widget tree dan bagaimana hubungan parent-child bekerja?** Widget tree adalah susunan widget yang membentuk tampilan aplikasi. Di proyek ini, `MyApp` membangun `MaterialApp`, lalu `MaterialApp` menampilkan `MyHomePage` sebagai halaman awal. Contoh hubungan induk dan anak bisa dilihat di bagian profil. `Row` menyusun tiga kartu secara horizontal, sementara `Expanded` membantu membagi lebar yang tersedia. Saya memberi kartu nama `flex: 2` supaya ruangnya lebih lebar dan nama lengkap bisa turun ke baris berikutnya kalau layarnya sempit. Secara umum, widget induk memberi batas ukuran, widget anak menentukan ukurannya dalam batas itu, lalu induk mengatur posisinya.

2. **Widget apa saja yang dipakai di proyek ini?** Aplikasi dimulai dari `MyApp`, yang membangun `MaterialApp` dan membuka `MyHomePage`. Di halaman utama, `Scaffold` menyediakan struktur halaman, `AppBar` menampilkan judul, dan `SingleChildScrollView` membuat isi halaman bisa digulir. Saya memakai `Padding` untuk memberi ruang di sekeliling konten, `Column` untuk menyusun elemen ke bawah, `Row` untuk menyejajarkan kartu profil, `Expanded` untuk membagi lebarnya, `SizedBox` untuk memberi jarak, dan `Center` untuk menengahkan isi.

   Untuk bagian profil, `InfoCard` memakai `Card` sebagai wadah dan `Text` untuk menampilkan label serta isinya. Bagian menu memakai `GridView.count` untuk menyusun tiga `ItemCard`. Di dalam setiap kartu aksi, `Material` memberi warna latar, `InkWell` menangani ketukan dan efek sentuh, `Icon` menampilkan ikon, dan `Text` menampilkan nama aksi. Saat kartu ditekan, `ScaffoldMessenger` menampilkan `SnackBar` dengan pesan sesuai tombol yang dipilih. Nama, ikon, dan warna tiap aksi disimpan di model `ItemHomepage`.

3. **Apa fungsi `MaterialApp`?** `MaterialApp` adalah tempat untuk mengatur hal yang dipakai bersama oleh halaman aplikasi, seperti tema dan navigasi. Biasanya widget ini diletakkan dekat akar widget tree supaya halaman di bawahnya bisa memakai pengaturan yang sama. Di proyek saya, `MaterialApp` menetapkan `MyHomePage` sebagai halaman awal lewat `home` dan mengatur tema dengan warna dasar indigo. Warna utama dari tema itu kemudian dipakai oleh `AppBar`.

4. **Apa bedanya `StatelessWidget` dan `StatefulWidget`?** Saya memakai `StatelessWidget` untuk `MyHomePage` karena data profil dan pilihan menunya sudah tersedia saat halaman dibangun. Kartu tetap bisa merespons ketukan karena pesan yang muncul dikelola oleh `ScaffoldMessenger`. `StatefulWidget` lebih cocok kalau bagian dari tampilan perlu berubah mengikuti data yang disimpan di objek `State`. Misalnya, kalau nanti ada formulir tambah proyek, saya bisa menyimpan status proses simpan di `State` dan memakai `setState()` untuk memperbarui tampilannya saat proses dimulai atau selesai.

5. **Apa itu `BuildContext` dan bagaimana cara memakainya?** `BuildContext` menunjukkan posisi widget di dalam widget tree. Flutter memakai posisi itu untuk mencari sesuatu yang disediakan oleh widget di atasnya. Contohnya, di `MyHomePage.build()` saya memakai `Theme.of(context)` untuk mengambil warna utama tema. Di `ItemCard`, `context` yang diterima oleh `build()` juga dipakai saat kartu diketuk. `ScaffoldMessenger.of(context)` mencari `ScaffoldMessenger` terdekat supaya pesan bisa muncul di halaman yang sedang dibuka.

6. **Apa bedanya hot reload, hot restart, dan full restart?** Kalau saya hanya mengubah jarak antarkartu atau warna di dalam `build()`, biasanya hot reload sudah cukup. Flutter menerapkan perubahan kode Dart dan membangun ulang tampilan sambil mempertahankan state yang sedang berjalan. Hot reload tidak menjalankan ulang `main()` atau `initState()`, jadi kalau perubahan ada di bagian inisialisasi, saya bisa memakai hot restart. Hot restart menjalankan ulang aplikasi Dart dari `main()` dan mereset state di memori. Kalau saya mengubah kode native Android atau iOS, saya perlu menghentikan aplikasi lalu menjalankannya lagi agar bagian native ikut dibangun ulang.

#### Penggunaan AI

Saya menggunakan bantuan AI untuk dalam mengerjakan Tugas 7 dan membagi pengerjaannya menjadi beberapa tahap. Saya mulai dari hasil Tutorial 08, lalu mengganti data profil contoh dengan nama, NPM, dan kelas saya. Setelah profil selesai, saya lanjut ke kartu aksi. Setiap kartu diberi warna berbeda, lalu saya menggunakan bantuan AI untuk menjalankan `flutter analyze` dan `flutter test` agar ketiga tombol tetap menampilkan SnackBar sesuai labelnya.
