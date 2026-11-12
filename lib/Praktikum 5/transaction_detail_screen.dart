import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String category;
  final String date;

  const TransactionDetailScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = amount.contains('+');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== IKON TRANSAKSI =====
            CircleAvatar(
              radius: 40,
              backgroundColor:
                  isIncome ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                size: 40,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24),

            // ===== JUDUL TRANSAKSI =====
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ===== NOMINAL =====
            Text(
              amount,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),

            // ===== CHIP STATUS =====
            Chip(
              label: Text(
                isIncome ? 'Pemasukan' : 'Pengeluaran',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor:
                  isIncome ? Colors.green.shade50 : Colors.red.shade50,
            ),
            const Divider(height: 40, thickness: 2),

            // ===== DETAIL INFO =====
            _buildDetailRow('Kategori', category),
            const SizedBox(height: 16),
            _buildDetailRow('Tanggal', date),
            const SizedBox(height: 16),
            _buildDetailRow('Status', 'Berhasil'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
