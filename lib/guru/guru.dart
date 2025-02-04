import 'package:aplikasi_ortu/guru/chatlist_page.dart';
import 'package:aplikasi_ortu/guru/absensi_page.dart'; // Pastikan AbsensiPage diimpor
import 'package:flutter/material.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late PageController _pageController;
  late Timer _timer;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= 5) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatListPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AbsensiPage()), // Navigasi ke halaman Absensi
      );
    }
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 2:
        return Center(child: Text('News Page', style: TextStyle(fontSize: 24)));
      case 4:
        return Center(child: Text('Grade Page', style: TextStyle(fontSize: 24)));
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page View Card Items',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _buildCardItem(),
          SizedBox(height: 20),
          Text('Presentase Mengajar',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildTeachingProgress(),
          SizedBox(height: 20),
          Text('Jadwal Mengajar',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: List.generate(4, (index) => _buildScheduleItem()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Dashboard'),
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Absensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'Grade',
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem() {
    return SizedBox(
      height: 155,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Card ${index + 1}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeachingProgress() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPercentageProgress('Mengajar Matematika', 70),
          _buildPercentageProgress('Mengajar Fisika', 85),
          _buildPercentageProgress('Mengajar Kimia', 90),
        ],
      ),
    );
  }

  Widget _buildScheduleItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Jadwal Mengajar', style: TextStyle(color: Colors.white)),
          Icon(Icons.check_box, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildPercentageProgress(String title, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: percentage / 100,
          minHeight: 10,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
