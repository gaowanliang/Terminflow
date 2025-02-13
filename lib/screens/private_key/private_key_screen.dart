import 'package:flutter/material.dart';

class PrivateKeyScreen extends StatelessWidget {
  const PrivateKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私钥管理'),
      ),
      body: Center(
        child: Text('私钥管理'),
      ),
    );
  }
}
