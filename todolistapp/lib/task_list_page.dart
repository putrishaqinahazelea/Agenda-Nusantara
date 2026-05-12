import 'package:flutter/material.dart'; // Import Flutter untuk membuat tampilan aplikasi
import 'database_helper.dart'; // Import database helper untuk mengambil data tugas dari SQLite
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

// Halaman daftar tugas
// StatefulWidget dipakai karena data tugas bisa berubah
class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

// Tempat isi dan logika halaman daftar tugas
class _TaskListPageState extends State<TaskListPage> {
 
  // Object database helper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // List untuk menyimpan semua data tugas
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {

    // Dipanggil pertama kali saat halaman dibuka
    super.initState();

    // Mengambil data tugas dari database
    _fetchTasks();
  }

  // Fungsi mengambil semua tugas
  Future<void> _fetchTasks() async {

    // Menampilkan loading
    setState(() => _isLoading = true);

    // Mengambil data tugas dari database
    final data = await _dbHelper.queryAllTasks();

    // Update tampilan
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  // Fungsi mengubah status tugas selesai/belum
  void _toggleTaskStatus(Map<String, dynamic> task) async {

    // Jika selesai jadi belum selesai
    // Jika belum selesai jadi selesai
    int newStatus = task['is_completed'] == 1 ? 0 : 1;

    // Update status tugas di database
    await _dbHelper.updateTask({
      'id': task['id'],
      'is_completed': newStatus,
    });

    // Refresh data tugas
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {

    // Scaffold = kerangka utama halaman
    return Scaffold(

      // Background halaman
      backgroundColor: const Color(0xFFF5F7F9),

      // AppBar bagian atas
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A8B7A),

        // Judul halaman
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        // Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),

          // Kembali ke halaman sebelumnya
          onPressed: () => Navigator.pop(context, true),
        ),
        elevation: 0,
      ),
      
      // Jika loading tampil loading
      body: _isLoading

          ? const Center(child: CircularProgressIndicator())

          // Jika data kosong tampil pesan
          : _tasks.isEmpty

              ? const Center(child: Text('Belum ada tugas.'))

              // Jika ada data tampil list tugas
              : ListView.builder(
                  padding: const EdgeInsets.all(16),

                  // Jumlah item tugas
                  itemCount: _tasks.length,

                  // Membuat item satu per satu
                  itemBuilder: (context, index) {

                    // Mengambil data tugas berdasarkan index
                    final task = _tasks[index];

                    // Mengecek tugas selesai atau belum
                    bool isCompleted = task['is_completed'] == 1;

                    // Mengecek tugas penting atau biasa
                    bool isImportant = task['category'] == 'Penting';
                    
                    // Variabel untuk menyimpan tanggal
                    String formattedDate = '';

                    // Jika ada tanggal
                    if (task['due_date'] != null) {

                      // Mengubah string jadi DateTime
                      DateTime dt = DateTime.parse(task['due_date']);

                      // Format tanggal Indonesia
                      formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(dt);
                    }
                    
                    // Card tugas
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                        // Checkbox status tugas
                        leading: Transform.scale(

                          scale: 1.2,
                          child: Checkbox(

                            // Status checkbox
                            value: isCompleted,

                            activeColor: const Color(0xFF4A8B7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            
                            // Saat checkbox diklik
                            onChanged: (_) => _toggleTaskStatus(task),
                          ),
                        ),
                        
                        // Judul tugas
                        title: Text(
                          task['title'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            
                            // Warna abu jika selesai
                            color: isCompleted ? Colors.grey : Colors.black87,
                            
                            // Coret tulisan jika selesai
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        
                        // Subtitle tanggal & kategori
                        subtitle: Text(
                          '$formattedDate · ${task['category']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        
                        // Icon kanan
                        trailing: Icon(
                          Icons.play_arrow_rounded,
                          
                          // Merah jika penting
                          // Hijau jika biasa
                          color: isImportant ? Colors.red : Colors.green,
                          size: 24,
                        ),
                        
                        // Saat item diklik
                        onTap: () => _toggleTaskStatus(task),
                      ),
                    );
                  },
                ),
    );
  }
}
