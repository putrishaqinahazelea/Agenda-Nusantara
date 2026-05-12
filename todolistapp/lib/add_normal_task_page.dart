import 'package:flutter/material.dart'; // Import Flutter untuk membuat tampilan
import 'package:intl/intl.dart'; // Import intl untuk format tanggal
import 'database_helper.dart'; // Import database helper untuk menyimpan data ke SQLite

// Halaman tambah tugas biasa
// Pakai StatefulWidget karena input dan tanggal bisa berubah
class AddNormalTaskPage extends StatefulWidget {
  const AddNormalTaskPage({super.key});

  @override
  State<AddNormalTaskPage> createState() => _AddNormalTaskPageState();
}

// Tempat isi dan logika halaman tambah tugas biasa
class _AddNormalTaskPageState extends State<AddNormalTaskPage> {

  // Controller untuk mengambil isi judul tugas
  final TextEditingController _titleController = TextEditingController();

  // Controller untuk mengambil isi deskripsi tugas
  final TextEditingController _descriptionController = TextEditingController();

  // Menyimpan tanggal yang dipilih user
  DateTime _selectedDate = DateTime.now();

  // Object database helper untuk akses database
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {

    // Menampilkan date picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),

      // Mengatur warna date picker menjadi hijau
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50), // Green color for picker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    // Jika user memilih tanggal, simpan tanggalnya
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi untuk menyimpan tugas
  void _saveTask() async {

    // Cek kalau judul kosong
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tugas tidak boleh kosong')),
      );
      return;
    }

    // Menyimpan tugas ke database sebagai kategori Biasa
    await _dbHelper.insertTask({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'due_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'category': 'Biasa',
      'is_completed': 0,
    });

    // Kembali ke halaman sebelumnya dan kirim tanda agar data direfresh
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar bagian atas
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),

        // Judul halaman
        title: const Text(
          'Tambah Tugas Biasa',
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
            
            // Label kategori biasa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'BIASA',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Label tanggal Jatuh Tempo
            const Text(
              'TANGGAL JATUH TEMPO',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Kotak tanggal yang bisa diklik
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [

                    // Icon kalender
                    const Icon(Icons.calendar_month, color: Color(0xFF546E7A)),
                    const SizedBox(width: 12),

                    // Menampilkan tanggal yang dipilih
                    Text(
                      DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // label judul Tugas
            const Text(
              'JUDUL TUGAS',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Input judul tugas
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Contoh: Beli buah',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Label deskripsi
            const Text(
              'DESKRIPSI',
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Input deskripsi tugas
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan tugas...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Button Simpan
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(

                // Saat tombol diklik, jalankan fungsi simpan
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'SIMPAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
