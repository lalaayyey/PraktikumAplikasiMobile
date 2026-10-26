import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String amount;
  final String category;
  final String date;
  final bool isIncome;
  final IconData? icon;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
    this.icon,
  });
}
