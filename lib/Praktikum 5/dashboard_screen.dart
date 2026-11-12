import 'package:flutter/material.dart';
import 'database/db_helper.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final Function(int)? onTabSwitch; // callback untuk pindah tab

  const DashboardScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    this.onTabSwitch,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _balance = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<Map<String, dynamic>> _recentTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ===== AMBIL DATA DARI SQLITE =====
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final balance = await DatabaseHelper.instance.getTotalBalance();
    final transactions = await DatabaseHelper.instance.getRecentTransactions(5);

    // Hitung total pemasukan & pengeluaran
    double income = 0;
    double expense = 0;
    final allTx = await DatabaseHelper.instance.getAllTransactions();
    for (var tx in allTx) {
      if (tx['is_income'] == 1) {
        income += tx['amount'] as double;
      } else {
        expense += tx['amount'] as double;
      }
    }

    if (mounted) {
      setState(() {
        _balance = balance;
        _totalIncome = income;
        _totalExpense = expense;
        _recentTransactions = transactions;
        _isLoading = false;
      });
    }
  }

  // ===== FORMAT RUPIAH =====
  String _formatRupiah(double amount) {
    final abs = amount.abs();
    final str = abs.toStringAsFixed(0);
    final buffer = StringBuffer();
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (counter > 0 && counter % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      counter++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== FAB — Named Route =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Tunggu hasil dari form tambah transaksi
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) _loadData(); // Refresh data kalau ada transaksi baru
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Colors.amber,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== SALAM USER (dari Praktikum 4) =====
                    Text(
                      'Halo, ${widget.userName}!',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.userEmail,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // ===== KARTU SALDO (dari Praktikum 4 — sekarang real dari SQLite) =====
                    _buildBalanceCard(),
                    const SizedBox(height: 12),

                    // ===== KARTU PEMASUKAN & PENGELUARAN =====
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            label: 'Pemasukan',
                            amount: _totalIncome,
                            icon: Icons.arrow_downward,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            label: 'Pengeluaran',
                            amount: _totalExpense,
                            icon: Icons.arrow_upward,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ===== QUICK ACTIONS (dari Praktikum 4) — SEKARANG INTERAKTIF =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickAction(
                            icon: Icons.add_circle_outline,
                            label: 'Tambah',
                            color: Colors.amber,
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                  context, '/add');
                              if (result == true) _loadData();
                            }),
                        _buildQuickAction(
                            icon: Icons.history,
                            label: 'Riwayat',
                            color: Colors.blue,
                            onTap: () {
                              // Pindah ke tab Riwayat
                              if (widget.onTabSwitch != null) {
                                widget.onTabSwitch!(1);
                              }
                            }),
                        _buildQuickAction(
                            icon: Icons.download,
                            label: 'Terima',
                            color: Colors.green,
                            onTap: () async {
                              // Shortcut: langsung buka form dengan tipe Pemasukan
                              final result = await Navigator.pushNamed(
                                  context, '/add');
                              if (result == true) _loadData();
                            }),
                        _buildQuickAction(
                            icon: Icons.receipt_long,
                            label: 'Tagihan',
                            color: Colors.orange,
                            onTap: () async {
                              // Shortcut: langsung buka form dengan tipe Pengeluaran
                              final result = await Navigator.pushNamed(
                                  context, '/add');
                              if (result == true) _loadData();
                            }),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ===== TRANSAKSI TERAKHIR =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transaksi Terakhir',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (_recentTransactions.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              if (widget.onTabSwitch != null) {
                                widget.onTabSwitch!(1);
                              }
                            },
                            child: const Text('Lihat Semua',
                                style: TextStyle(color: Colors.amber)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _recentTransactions.isEmpty
                        ? _buildEmptyState()
                        : _buildTransactionList(context),

                    // Extra padding bawah supaya scroll bisa lanjut
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  // ===== KARTU SALDO — SALDO DIHITUNG DARI SQLITE =====
  Widget _buildBalanceCard() {
    final bool isNegative = _balance < 0;
    return Card(
      elevation: 4,
      color: isNegative ? Colors.red.shade400 : Colors.amber,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Utama',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              _formatRupiah(_balance),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isNegative ? '⚠ Saldo minus!' : '✓ Saldo normal',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ===== KARTU RINGKASAN PEMASUKAN / PENGELUARAN =====
  Widget _buildSummaryCard({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(
                    _formatRupiah(amount),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== QUICK ACTION BUTTON (dari Praktikum 4) =====
  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ===== DAFTAR TRANSAKSI TERAKHIR — DATA DARI SQLITE =====
  Widget _buildTransactionList(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: _recentTransactions.asMap().entries.map((entry) {
          final index = entry.key;
          final tx = entry.value;
          final bool isIncome = tx['is_income'] == 1;
          final double amount = tx['amount'] as double;

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(tx['title']),
                subtitle: Text('${tx['category']} • ${tx['date']}'),
                trailing: Text(
                  '${isIncome ? '+' : '-'} ${_formatRupiah(amount)}',
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: {
                      'title': tx['title'] as String,
                      'amount':
                          '${isIncome ? '+' : '-'} ${_formatRupiah(amount)}',
                      'category': tx['category'] as String,
                      'date': tx['date'] as String,
                    },
                  );
                },
              ),
              if (index < _recentTransactions.length - 1)
                const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ===== TAMPILAN KOSONG =====
  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 50, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Belum ada transaksi',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'Klik tombol + untuk menambahkan',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
