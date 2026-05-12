import 'package:flutter/material.dart'; // bahan utama utk desain tampilan Flutter 
import 'home_page.dart'; // panggil halaman utama kalo login berhasil
import 'database_helper.dart'; // untuk cek username dan password

// bikin halaman login
// StatefulWidget dipakai karena isi halaman bisa berubah
// misalnya input user atau muncul error login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState(); // menghubungkan LoginPage dengan class state
}

class _LoginPageState extends State<LoginPage> { // tempat semua isi dan logika halaman login
  final TextEditingController _usernameController = TextEditingController(); // controller untuk ngambil isi username
  final TextEditingController _passwordController = TextEditingController(); // controller untuk ngambil isi password
  final DatabaseHelper _dbHelper = DatabaseHelper(); // membuat object db helper

  void _handleLogin() async {   // fungsi login
    String username = _usernameController.text; // ngambil isi username dari textfield
    String password = _passwordController.text; // ngambil isi password dari textfield

    final user = await _dbHelper.login(username, password); // ngecek login ke database

    if (user != null) { // kalau username & password benar
      // Navigate to HomePage (Beranda)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else { 
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar( // kalau login gagal tampil pesan error
        const SnackBar(
          content: Text('Username atau Password salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  // Scaffold = kerangka utama halaman
      backgroundColor: Colors.white, // warna background halaman
      body: Center(
        child: SingleChildScrollView( // biar halaman bisa discroll kalau layar kecil
          padding: const EdgeInsets.symmetric(horizontal: 30), // jarak kanan kiri
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, // posisi isi di tengah
            children: [
              // 1. Logo Aplikasi
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 24),

              // 2. Nama Aplikasi
              const Text(
                'AGENDA NUSANTARA',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0E305D),
                ),
              ), 
              const Text( 
                'Productivity by PT. SDM', // Subtitle aplikasi
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 48),

              // 3. Input Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'username',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Input Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 5. Tombol Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin, // jalankan fungsi login saat tombol ditekan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E305D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '© 2024 PT. Sumber Daya Makmur',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
