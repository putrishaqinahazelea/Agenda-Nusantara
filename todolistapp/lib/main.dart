import 'dart:io'; // utk tahu aplikasi lagi jalan di laptop apa (Windows/Linux)
import 'package:flutter/material.dart'; // bahan utama utk desain tampilan Flutter 
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // buat simpan data khusus di komputer/laptop
import 'package:intl/date_symbol_data_local.dart'; // utk ngatur format tanggal (Senin, Selasa, dll)
import 'package:google_fonts/google_fonts.dart'; // utk ambil font bagus dari Google (Poppins)
import 'login_page.dart'; // memanggil file login_page.dart biar bs ditampilkan

void main() async { // pastiin sistem Flutter siap sebelum mulai.
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database untuk Windows dan Linux
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit(); // inisialisasi db untuk desktop
    databaseFactory = databaseFactoryFfi; // pakai mesin db versi desktop
  }

  // inisialisasi format tanggal bahasa indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp()); // perintah buat munculin tampilan aplikasi utama.
}

class MyApp extends StatelessWidget { // ATUR TAMPILAN (Ngatur warna dan gaya aplikasi)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Nusantara', // nama aplikasi (muncul di taskbar/info)
      debugShowCheckedModeBanner: false, // // hapus tulisan merah "DEBUG" di layar
      theme: ThemeData( // pengaturan tampilan (warna & font)
        useMaterial3: true, // pakai desain gaya terbaru dari Google (material 3)
        colorScheme: ColorScheme.fromSeed( 
          seedColor: const Color(0xFF0E305D), // warna dasar (biru tua)
          primary: const Color(0xFF0E305D), // warna utama utk tombol/appbar
        ),
        textTheme: GoogleFonts.poppinsTextTheme( // mengatur semua teks di aplikasi pakai font "Poppins"
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoginPage(), // menentukan halaman yg pertama kali muncul (halaman login)
    );
  }
}
