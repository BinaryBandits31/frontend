class ActivityRecord {
  final String name;
  final String time;
  final String activity;

  ActivityRecord({
    required this.name,
    required this.time,
    required this.activity,
  });

  factory ActivityRecord.fromJson(dynamic json) => ActivityRecord(
        name: json['employee_Id'],
        time: json['created_At'],
        activity: json['activity'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'created_At': time,
        'activity': activity,
      };


}
