import 'package:feild_visit_app/features/home/screens/add_visit_screen.dart';
import 'package:feild_visit_app/features/home/screens/visit_list_screeen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false, // keep content below AppBar
      appBar: AppBar(
        title: const Text(
          'Farm Visit',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
      ),
      body: const VisitListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AddVisitScreen())),
        child: const Icon(Icons.add_box_outlined, color: Colors.black87),
      ),
      backgroundColor: Colors.green.shade100,
    );
  }
}
