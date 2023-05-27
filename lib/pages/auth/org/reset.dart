import 'package:flutter/material.dart';

class ResetOrgID extends StatefulWidget {
  const ResetOrgID({super.key});

  @override
  State<ResetOrgID> createState() => _ResetOrgIDState();
}

class _ResetOrgIDState extends State<ResetOrgID> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset ID')),
      body: const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Reset Organization ID here')],
      )),
    );
  }
}
