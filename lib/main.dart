import 'package:flutter/material.dart';

void main() {
  runApp(const AbsensiGeoApp());
}

class AbsensiGeoApp extends StatelessWidget {
  const AbsensiGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsensiGeo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A6D5E)),
        useMaterial3: true,
      ),
      home: const ProjectBootstrapPage(),
    );
  }
}

class ProjectBootstrapPage extends StatelessWidget {
  const ProjectBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AbsensiGeo'),
      ),
      body: const Center(
        child: Text('Project bootstrap siap digunakan.'),
      ),
    );
  }
}
