import 'package:flutter/material.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: const Center(
        child: Text('HELLO PERMISSION SCREEN', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
