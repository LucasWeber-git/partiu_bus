import 'package:flutter/material.dart';
import 'package:partiu_bus/widgets/route_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title, style: TextStyle(color: Colors.white)),
        elevation: 2,
      ),
      body: Center(child: RouteWidget()),
    );
  }
}
