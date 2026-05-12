import 'package:flutter/material.dart'; // bahan utama utk desain tampilan Flutter 
import 'database_helper.dart'; // untuk cek username dan password
import 'package:intl/intl.dart'; // untuk format tanggal Indonesia
import 'add_important_task_page.dart'; // import halaman tambah tugas penting
import 'add_normal_task_page.dart'; // import halaman tambah tugas biasa
import 'task_list_page.dart'; // import halaman daftar tugas
import 'settings_page.dart'; // import halaman pengaturan

class HomePage extends StatefulWidget { // membuat halaman Home/Beranda
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();   // menghubungkan HomePage dengan class state
}

class _HomePageState extends State<HomePage> { // tempat isi dan logika halaman home
  final DatabaseHelper _dbHelper = DatabaseHelper(); // membuat object database helper
  Map<String, int> _stats = { // menyimpan data statistik tugas
    'total_important': 0,
    'total_normal': 0,
    'total_completed': 0,
    'total_pending': 0,
  };
  List<int> _chartData = [0, 0, 0, 0, 0, 0, 0]; // menyimpan data grafik 7 hari terakhir

  @override
  void initState() {
    super.initState(); // dipanggil pertama kali saat halaman dibuka
    _refreshData(); // memuat data dari database
  }

  void _refreshData() async { // fungsi untuk refresh data
    final stats = await _dbHelper.getTaskStats(); // ambil statistik tugas dari database
    final chartData = await _dbHelper.getTasksPerDay(); // ambil data grafik tugas per hari
    setState(() { // update tampilan halaman
      _stats = stats;
      _chartData = chartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()); // nyimpen tgl hari ini format Indonesia
    
    return Scaffold( // Scaffold = kerangka utama halaman
      backgroundColor: Colors.white, // warna background halaman
      appBar: AppBar( // AppBar bagian atas aplikasi
        title: const Text('Beranda', style: TextStyle(fontWeight: FontWeight.bold)), // judul halaman
        backgroundColor: const Color(0xFF0E305D), // warna appbar
        foregroundColor: Colors.white, // warna tulisan/icon appbar
        elevation: 0,
        actions: [ // widget di kanan atas appbar
          Padding(  // padding logo
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/images/logo.png', height: 30), // logo aplikasi
          ),
        ],
      ),
      body: SingleChildScrollView( // isi halaman
        child: Column( // biar halaman bisa discroll
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Greeting
            Padding( 
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row( // sapaan user
                        children: [
                          const Text( 
                            'Halo, Putri Shaqinah Azelea!',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Text('👋', style: TextStyle(fontSize: 24)), // emoji tangan
                        ],
                      ),
                      Text( // tgl hari ini
                        today,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2.  Card jumlah tugas selesai & belum selesai
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [ 
                  _buildSummaryCard('TUGAS SELESAI', _stats['total_completed'].toString(), Colors.green), // card tugas selesai
                  const SizedBox(width: 16),
                  _buildSummaryCard('BELUM SELESAI', _stats['total_pending'].toString(), const Color(0xFF0E305D)), // card belum selesai
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Bagian grafik tugas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text( // judul grafik
                      'JUMLAH TUGAS / HARI (7 HARI TERAKHIR)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildSimpleBarChart(), // menampilkan grafik sederhana
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Tombol navigasi menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildNavButton( // button tambah tugas penting
                        'Tambah Tugas Penting',
                        Icons.add,
                        Colors.red,
                        () async {
                          final result = await Navigator.push( // pindah halaman tambah tugas penting
                            context,
                            MaterialPageRoute(builder: (context) => const AddImportantTaskPage()),
                          );
                          if (result == true) { // refresh data klo berhasil tambah tugas
                            _refreshData();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildNavButton( // button tambah tugas biasa
                        'Tambah Tugas Biasa',
                        Icons.add,
                        Colors.green,
                        () async { // fungsi saat tombol ditekan
                          final result = await Navigator.push( // pindah ke halaman tambah tugas biasa
                            context,
                            MaterialPageRoute(builder: (context) => const AddNormalTaskPage()),
                          );
                          if (result == true) { // klo berhasil tambah tugas, refresh data
                            _refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildNavButton( // button daftar tugas
                        'Daftar Tugas',
                        Icons.list_alt_rounded,
                        Colors.blueAccent,
                        () async { // fungsi saat tombol ditekan
                          final result = await Navigator.push( // pindah ke halaman daftar tugas
                            context,
                            MaterialPageRoute(builder: (context) => const TaskListPage()),
                          );
                          if (result == true) {
                            _refreshData(); // refresh data kalo ada perubahan 
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildNavButton( // button pengaturan
                        'Pengaturan',
                        Icons.settings,
                        Colors.blueGrey,
                        () {
                          Navigator.push( // pindah ke halaman pengaturan
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // widget utk buat card jumlah tugas
  // string : parameter judul card, jumlah angka; color : warna angka
  Widget _buildSummaryCard(String title, String count, Color color) { 
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16), // jarak isi card
        decoration: BoxDecoration( // desain card
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( // judul card
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text( // jumlah tugas
              count,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart() { // widget utk buat grafik batang sederhana
    // Labels for the last 7 days
    final List<String> days = []; // menyimpan nama hari
    DateTime now = DateTime.now(); // mengambil tanggal sekarang
    for (int i = 6; i >= 0; i--) { // mengambil 7 hari terakhir
      days.add(DateFormat('E', 'id_ID').format(now.subtract(Duration(days: i))));
    }

    // Calculate max to scale bars
    int maxCount = _chartData.reduce((curr, next) => curr > next ? curr : next); // mencari angka terbesar untuk ukuran grafik
    if (maxCount == 0) maxCount = 1; // jika kosong maka isi 1

    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) { // membuat 7 batang grafik
          double normalizedHeight = (_chartData[index] / maxCount) * 60; // Reduced from 80 to 60 / mengatur tinggi batang grafik
          if (normalizedHeight < 5 && _chartData[index] > 0) normalizedHeight = 5; // minimal tinggi batang

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text( // menampilkan angka grafik
                _chartData[index] > 0 ? _chartData[index].toString() : '',
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0E305D)),
              ),
              const SizedBox(height: 2),
              Container( // batang grafik
                width: 30,
                height: normalizedHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E305D),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4), // Reduced from 8 to 4

              Text( // nama hari
                days[index],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }

// Parameter judul tombol, Parameter icon, parameter warna, parameter fungsi saat tombol ditekan
  Widget _buildNavButton(String title, IconData icon, Color color, VoidCallback onTap) { // widget utk buat tombol menu navigasi
    return Expanded(
      child: InkWell(
        onTap: onTap, // fungsi saat tombol diklik
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration( // desain button
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [

              Container( // background icon
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28), // icon tombol
              ),
              const SizedBox(height: 12),
              Text( // judul tombol
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

/*
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';
import 'add_important_task_page.dart';
import 'add_normal_task_page.dart';
import 'task_list_page.dart';
import 'settings_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, int> _stats = {
    'total_important': 0,
    'total_normal': 0,
    'total_completed': 0,
    'total_pending': 0,
  };
  List<int> _chartData = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final stats = await _dbHelper.getTaskStats();
    final chartData = await _dbHelper.getTasksPerDay();
    setState(() {
      _stats = stats;
      _chartData = chartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  title: const Text(
    'Beranda',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  elevation: 0,

  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    ),

    Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Image.asset(
        'assets/images/logo.png',
        height: 30,
      ),
    ),
  ],
),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Greeting
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Halo, User!',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          const Text('👋', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      Text(
                        today,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  _buildSummaryCard('TUGAS SELESAI', _stats['total_completed'].toString(), Colors.green),
                  const SizedBox(width: 16),
                  _buildSummaryCard('BELUM SELESAI', _stats['total_pending'].toString(), Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Chart Section [BONUS]
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'JUMLAH TUGAS / HARI (7 HARI TERAKHIR)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildSimpleBarChart(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Navigation Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildNavButton(
                        'Tambah Tugas Penting',
                        Icons.add,
                        Colors.red,
                        () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddImportantTaskPage()),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildNavButton(
                        'Tambah Tugas Biasa',
                        Icons.add,
                        Colors.green,
                        () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddNormalTaskPage()),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildNavButton(
                        'Daftar Tugas',
                        Icons.list_alt_rounded,
                        Colors.blueAccent,
                        () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TaskListPage()),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildNavButton(
                        'Pengaturan',
                        Icons.settings,
                        Colors.blueGrey,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    // Labels for the last 7 days
    final List<String> days = [];
    DateTime now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      days.add(DateFormat('E', 'id_ID').format(now.subtract(Duration(days: i))));
    }

    // Calculate max to scale bars
    int maxCount = _chartData.reduce((curr, next) => curr > next ? curr : next);
    if (maxCount == 0) maxCount = 1;

    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          double normalizedHeight = (_chartData[index] / maxCount) * 60; // Reduced from 80 to 60
          if (normalizedHeight < 5 && _chartData[index] > 0) normalizedHeight = 5;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _chartData[index] > 0 ? _chartData[index].toString() : '',
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 2),
              Container(
                width: 30,
                height: normalizedHeight,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4), // Reduced from 8 to 4
              Text(
                days[index],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNavButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halaman $title segera hadir!')),
    );
  }
}

*/