import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("CUSTOMER HOMEPAGE"),
        ),
      ),
      body: Center(child: Text("Welcome Customer"),),
    );
  }
}
