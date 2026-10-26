import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // ===== AMBIL DATA USER DARI LOGIN (Map: name, email, id) =====
    final args = ModalRoute.of(context)?.settings.arguments;
    String userName = 'Pengguna';
    String userEmail = '';

    if (args is Map) {
      userName = args['name'] ?? 'Pengguna';
      userEmail = args['email'] ?? '';
    } else if (args is String) {
      // Kompatibel dengan versi lama yang hanya kirim email
      userEmail = args;
    }

    // ===== DAFTAR HALAMAN BOTTOM NAV =====
    final List<Widget> pages = [
      DashboardScreen(
        userName: userName,
        userEmail: userEmail,
        onTabSwitch: _switchTab, // callback untuk pindah tab dari dashboard
      ),
      const HistoryScreen(),
      ProfileScreen(userName: userName, userEmail: userEmail),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: pages[_selectedIndex],

      // ===== BOTTOM NAVIGATION BAR (fitur Praktikum 5) =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ===== JUDUL APPBAR SESUAI TAB AKTIF =====
  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard Keuangan';
      case 1:
        return 'Riwayat Transaksi';
      case 2:
        return 'Profil Saya';
      default:
        return 'Expense Tracker';
    }
  }
}
