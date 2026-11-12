import 'package:flutter/material.dart';
import 'database/db_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // ===== AMBIL SEMUA TRANSAKSI DARI SQLITE =====
  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllTransactions();
    if (mounted) {
      setState(() {
        _transactions = data;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada riwayat transaksi',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tambah transaksi dari halaman Beranda',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTransactions,
                  color: Colors.amber,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      final bool isIncome = tx['is_income'] == 1;
                      final double amount = tx['amount'] as double;

                      // ===== SWIPE TO DELETE =====
                      return Dismissible(
                        key: Key(tx['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Transaksi'),
                              content:
                                  Text('Hapus transaksi "${tx['title']}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Hapus',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          final messenger = ScaffoldMessenger.of(context);
                          await DatabaseHelper.instance
                              .deleteTransaction(tx['id'] as int);
                          setState(() {
                            _transactions.removeAt(index);
                          });
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Transaksi berhasil dihapus'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            tx['title'],
                            style:
                                const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                              '${tx['category']} • ${tx['date']}'),
                          trailing: Text(
                            '${isIncome ? '+' : '-'} ${_formatRupiah(amount)}',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                      );
                    },
                  ),
                ),
    );
  }
}
