import 'package:flutter/material.dart';
import 'package:frontend/services/activity_logs_services.dart';
import 'package:frontend/models/activity_record.dart';




class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {

  bool isLoading = true;
  List<ActivityRecord> records = [];

  @override
  void initState() {
    super.initState();
    ActivityLogsServices.fetchRecords().then((value) => setState(() {
      records = value;
      isLoading = false;
    }));
  }

  Widget build(BuildContext context) {
    return isLoading ?
    const Center(child: CircularProgressIndicator()) :
    ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(records[index].activity),
          subtitle: Text(records[index].name),
          trailing: Text(records[index].time),
        );
      },
    );
  }
}
