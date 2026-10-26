import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker — Tugas Praktikum 5',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),

      // ===== INITIAL ROUTE — Mulai dari Halaman Login =====
      initialRoute: '/login',

      // ===== NAMED ROUTES (fitur utama Praktikum 5) =====
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/': (context) => const MainScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },

      // ===== ROUTE DENGAN ARGUMEN (Detail Transaksi) =====
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              title: args['title']!,
              amount: args['amount']!,
              category: args['category']!,
              date: args['date']!,
            ),
          );
        }
        return null;
      },
    );
  }
}
