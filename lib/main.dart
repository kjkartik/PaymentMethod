import 'package:flutter/material.dart';
import 'package:paymentmethod/paymentpage.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Method',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentMethod(),
    );
  }
}
