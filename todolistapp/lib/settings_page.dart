import 'package:flutter/material.dart'; // Import Flutter untuk membuat tampilan aplikasi
import 'database_helper.dart'; // Import database helper untuk akses database SQLite

// Halaman pengaturan
// StatefulWidget dipakai karena input password bisa berubah
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

// Tempat isi dan logika halaman pengaturan
class _SettingsPageState extends State<SettingsPage> {

  // Controller untuk mengambil password saat ini
  final TextEditingController _currentPasswordController = TextEditingController();

  // Controller untuk mengambil password baru
  final TextEditingController _newPasswordController = TextEditingController();

  // Object database helper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Untuk show/hide password saat ini
  bool _obscureCurrent = true;

  // Untuk show/hide password baru
  bool _obscureNew = true;

  // Fungsi ganti password
  void _changePassword() async {

    // Mengambil isi password saat ini
    String currentInput = _currentPasswordController.text;

    // Mengambil isi password baru
    String newInput = _newPasswordController.text;

    // Validasi jika field kosong
    if (currentInput.isEmpty || newInput.isEmpty) {
      _showSnackBar('Harap isi semua field');
      return;
    }

    // 1. Validasi Password Saat Ini (Asumsi user default adalah "user")
    var user = await _dbHelper.login('user', currentInput);
    
    if (user != null) {
      // 2. Jika benar, update ke password baru
      await _dbHelper.updateUserPassword('user', newInput);
      // Tampilkan pesan berhasil
      _showSnackBar('Password berhasil diperbarui!', isError: false);

      // Mengosongkan input password
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } else {
      // 3. Jika salah, tampilkan error
      _showSnackBar('Password saat ini salah');
    }
  }

  // Fungsi untuk menampilkan snackbar
  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        // Warna merah jika error
        // Warna hijau jika berhasil
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold = kerangka utama halaman

      // Warna background halaman
      backgroundColor: const Color(0xFFF5F7F9),
      // AppBar bagian atas
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A8B7A),

        // Judul halaman
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        // Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),

      // Isi halaman bisa discroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Section Ganti Password
            const Text(
              'GANTI PASSWORD',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
           
            const SizedBox(height: 12),
            
            // Card ganti password
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  // Label password saat ini
                  const Text('PASSWORD SAAT INI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _currentPasswordController,
                    
                    // Password disembunyikan
                    obscureText: _obscureCurrent,
                    decoration: InputDecoration(
                      hintText: '••••',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      
                      // Tombol show/hide password
                      suffixIcon: IconButton(
                        icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Label password baru
                  const Text('PASSWORD BARU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  
                  const SizedBox(height: 8),
                  
                  // Input password baru
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      
                      // Tombol show/hide password
                      suffixIcon: IconButton(
                        icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tombol simpan password
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      
                      // Jalankan fungsi ganti password
                      onPressed: _changePassword,
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A8B7A),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('SIMPAN PASSWORD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Judul bagian developer
            const Text(
              'DEVELOPER',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            
            // Card informasi developer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              
              // Foto/icon developer
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFCFD8DC),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  
                /*
                child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/azel.jpeg'),
                  ),
                */

                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // Nama developer
                        const Text(
                          'Putri Shaqinah Azelea', // Silakan ganti dengan nama asli kamu
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        
                        // NIM developer
                        const Text(
                          'NIM: 254107027011', // Silakan ganti dengan NIM asli kamu
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Label developer aplikasi
                        const Text(
                          'DEVELOPER APLIKASI',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4A8B7A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
