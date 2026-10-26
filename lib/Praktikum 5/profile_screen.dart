import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ===== AVATAR PROFIL =====
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              child: Text(
                // Inisial dari nama
                userName.isNotEmpty
                    ? userName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),

            // ===== NAMA USER (dari SQLite via Login) =====
            Text(
              userName,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // ===== EMAIL USER (dari SQLite via Login) =====
            Text(
              userEmail,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // ===== KARTU INFO AKUN =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    title: 'Nama Lengkap',
                    subtitle: userName,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: userEmail,
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Status Akun',
                    subtitle: 'Aktif',
                  ),
                  const Divider(height: 1),
                  _buildInfoTile(
                    icon: Icons.calendar_today_outlined,
                    title: 'Bergabung Sejak',
                    subtitle: 'Oktober 2026',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== MENU PENGATURAN — SEKARANG INTERAKTIF =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_outlined,
                        color: Colors.amber),
                    title: const Text('Pengaturan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _SettingsPage(
                            userName: userName,
                            userEmail: userEmail,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline,
                        color: Colors.amber),
                    title: const Text('Bantuan'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const _HelpPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline,
                        color: Colors.amber),
                    title: const Text('Tentang Aplikasi'),
                    subtitle: const Text('Expense Tracker v1.0 — Tugas Praktikum 5'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Expense Tracker',
                        applicationVersion: 'v1.0',
                        applicationIcon: const CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.account_balance_wallet,
                              color: Colors.white),
                        ),
                        children: [
                          const Text(
                            'Aplikasi pencatatan keuangan pribadi.\n\n'
                            'Dibuat sebagai Tugas Akhir Praktikum Aplikasi Mobile '
                            '(Praktikum 1–5).\n\n'
                            'Fitur:\n'
                            '• Login & Register (SQLite)\n'
                            '• Dashboard saldo real-time\n'
                            '• Tambah transaksi + DatePicker\n'
                            '• Riwayat & hapus transaksi\n'
                            '• Profil pengguna\n'
                            '• Bottom Navigation Bar\n'
                            '• Named Routes',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== TOMBOL LOGOUT =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Yakin ingin keluar dari akun?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                          child: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title,
          style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ===== HALAMAN PENGATURAN =====
class _SettingsPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const _SettingsPage({
    required this.userName,
    required this.userEmail,
  });

  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  bool _notifEnabled = true;
  bool _darkMode = false;
  String _currency = 'IDR (Rp)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // ===== AKUN =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text('AKUN',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(
                widget.userName.isNotEmpty
                    ? widget.userName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(widget.userName),
            subtitle: Text(widget.userEmail),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur edit profil akan hadir segera!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
          ),
          const Divider(),

          // ===== PREFERENSI =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('PREFERENSI',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined,
                color: Colors.amber),
            title: const Text('Notifikasi'),
            subtitle: Text(_notifEnabled ? 'Aktif' : 'Nonaktif'),
            value: _notifEnabled,
            activeThumbColor: Colors.amber,
            onChanged: (val) {
              setState(() => _notifEnabled = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val
                      ? 'Notifikasi diaktifkan'
                      : 'Notifikasi dinonaktifkan'),
                  backgroundColor: Colors.amber,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          SwitchListTile(
            secondary:
                const Icon(Icons.dark_mode_outlined, color: Colors.amber),
            title: const Text('Mode Gelap'),
            subtitle: Text(_darkMode ? 'Aktif' : 'Nonaktif'),
            value: _darkMode,
            activeThumbColor: Colors.amber,
            onChanged: (val) {
              setState(() => _darkMode = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val
                      ? 'Mode gelap diaktifkan (segera hadir)'
                      : 'Mode terang diaktifkan'),
                  backgroundColor: Colors.amber,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.currency_exchange, color: Colors.amber),
            title: const Text('Mata Uang'),
            subtitle: Text(_currency),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Pilih Mata Uang'),
                  children: [
                    'IDR (Rp)',
                    'USD (\$)',
                    'EUR (€)',
                    'GBP (£)',
                  ]
                      .map((c) => SimpleDialogOption(
                            onPressed: () {
                              setState(() => _currency = c);
                              Navigator.pop(ctx);
                            },
                            child: Text(c,
                                style: TextStyle(
                                  fontWeight: c == _currency
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: c == _currency
                                      ? Colors.amber
                                      : null,
                                )),
                          ))
                      .toList(),
                ),
              );
            },
          ),
          const Divider(),

          // ===== KEAMANAN =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('KEAMANAN',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          ListTile(
            leading:
                const Icon(Icons.lock_outline, color: Colors.amber),
            title: const Text('Ubah Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur ubah password akan hadir segera!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint, color: Colors.amber),
            title: const Text('Kunci Biometrik'),
            subtitle: const Text('Belum diaktifkan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Fitur kunci biometrik akan hadir segera!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
          ),
          const Divider(),

          // ===== DATA =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('DATA',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
          ListTile(
            leading:
                const Icon(Icons.download_outlined, color: Colors.amber),
            title: const Text('Ekspor Data'),
            subtitle: const Text('Unduh riwayat transaksi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur ekspor data akan hadir segera!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Hapus Semua Data',
                style: TextStyle(color: Colors.red)),
            subtitle: const Text('Hapus seluruh transaksi'),
            trailing:
                const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Semua Data?'),
                  content: const Text(
                      'Semua transaksi akan dihapus permanen. Aksi ini tidak bisa dibatalkan.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur ini akan hadir segera!'),
                            backgroundColor: Colors.amber,
                          ),
                        );
                      },
                      child: const Text('Hapus',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ===== HALAMAN BANTUAN =====
class _HelpPage extends StatelessWidget {
  const _HelpPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pertanyaan Umum (FAQ)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFaqTile(
            question: 'Bagaimana cara menambah transaksi?',
            answer:
                'Klik tombol + (FAB) di halaman Beranda, lalu isi form transaksi '
                '(pilih jenis, judul, nominal, kategori, tanggal) dan klik Simpan.',
          ),
          _buildFaqTile(
            question: 'Bagaimana cara menghapus transaksi?',
            answer:
                'Buka tab Riwayat, geser (swipe) transaksi ke kiri, '
                'lalu konfirmasi penghapusan.',
          ),
          _buildFaqTile(
            question: 'Bagaimana saldo dihitung?',
            answer:
                'Saldo dihitung otomatis dari selisih total pemasukan '
                'dikurangi total pengeluaran yang tersimpan di database.',
          ),
          _buildFaqTile(
            question: 'Apakah data saya aman?',
            answer:
                'Ya! Data disimpan secara lokal di perangkat menggunakan '
                'SQLite. Data tidak dikirim ke server manapun.',
          ),
          _buildFaqTile(
            question: 'Bagaimana cara logout?',
            answer:
                'Buka tab Profil, scroll ke bawah, dan klik tombol Logout.',
          ),
          _buildFaqTile(
            question: 'Bagaimana jika lupa password?',
            answer:
                'Saat ini fitur lupa password belum tersedia. Silakan '
                'buat akun baru melalui halaman Register.',
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.support_agent,
                      size: 40, color: Colors.amber),
                  SizedBox(height: 8),
                  Text(
                    'Butuh bantuan lebih?',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hubungi dosen pengampu praktikum untuk pertanyaan lebih lanjut.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFaqTile({
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading:
            const Icon(Icons.help_outline, color: Colors.amber),
        title: Text(question,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        children: [
          Text(answer,
              style: const TextStyle(
                  fontSize: 13, color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}
