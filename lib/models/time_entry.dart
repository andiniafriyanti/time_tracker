class TimeEntry {
  final String id;
  final String projectId;
  final String projectName;
  final String taskId;
  final String taskName;
  final double totalTime;
  final DateTime date;
  final String notes;
  TimeEntry({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.taskId,
    required this.taskName,
    required this.totalTime,
    required this.date,
    required this.notes,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      projectName: json['projectName'],
      taskName: json['taskName'],
      totalTime: json['totalTime'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'projectName': projectName,
      'taskName': taskName,
      'totalTime': totalTime,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
