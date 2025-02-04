import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'guru.dart'; // Import halaman Guru

class AbsensiPage extends StatefulWidget {
  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  List<Map<String, dynamic>> students = [
    {'name': 'Siswa 1', 'isPresent': false},
    {'name': 'Siswa 2', 'isPresent': false},
    {'name': 'Siswa 3', 'isPresent': false},
    {'name': 'Siswa 4', 'isPresent': false},
    {'name': 'Siswa 5', 'isPresent': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadAbsensi();
  }

  // Fungsi untuk memuat status absensi yang disimpan
  _loadAbsensi() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < students.length; i++) {
      bool isPresent = prefs.getBool('absensi_siswa_${i + 1}') ?? false;
      setState(() {
        students[i]['isPresent'] = isPresent;
      });
    }
  }

  // Fungsi untuk mengubah status absensi
  void _toggleAbsensi(int index) {
    setState(() {
      students[index]['isPresent'] = !students[index]['isPresent'];
    });
    _saveAbsensi(index);
  }

  // Fungsi untuk menyimpan status absensi per siswa
  _saveAbsensi(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('absensi_siswa_${index + 1}', students[index]['isPresent']);
  }

  // Fungsi untuk menyimpan seluruh absensi dan pindah ke halaman Guru
  void _saveAllAbsensi() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < students.length; i++) {
      prefs.setBool('absensi_siswa_${i + 1}', students[i]['isPresent']);
    }

    // Menampilkan snack bar dan pindah ke halaman Guru setelah absensi disimpan
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Absensi Disimpan')));
    
    // Pindah ke halaman Guru setelah absensi disimpan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()), // Halaman Guru
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Absensi Siswa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Fungsi untuk kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Siswa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      students[index]['isPresent']
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: students[index]['isPresent']
                          ? Colors.green
                          : Colors.grey,
                    ),
                    title: Text(students[index]['name']),
                    onTap: () => _toggleAbsensi(index),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAllAbsensi,  // Menyimpan absensi dan pindah ke halaman Guru
              child: Text('Simpan Absensi'),
            ),
          ],
        ),
      ),
    );
  }
}
