import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), backgroundColor: cs.primary),
      body: Center(
        child: Text(
          'Home Page Placeholder',
          style: TextStyle(fontSize: 18, color: cs.onSurface),
        ),
      ),
    );
  }
}
