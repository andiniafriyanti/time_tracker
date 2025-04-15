import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  List<TimeEntry> _entries = [];

  final List<Project> _project = [
    Project(id: '1', name: 'Project Alpha'),
    Project(id: '2', name: 'Project Beta'),
    Project(id: '3', name: 'Project Gamma'),
    Project(id: '4', name: 'Project Delta'),
    Project(id: '5', name: 'Project Epsilon'),
  ];

  final List<Task> _task = [
    Task(id: '1', name: 'Task A'),
    Task(id: '2', name: 'Task B'),
    Task(id: '3', name: 'Task C'),
    Task(id: '4', name: 'Task D'),
    Task(id: '5', name: 'Task E'),
  ];

  List<TimeEntry> get entries => _entries;
  List<Project> get project => _project;
  List<Task> get task => _task;

  TimeEntryProvider(this.storage) {
    _loadTimeEntryFromStorage();
  }

  void _loadTimeEntryFromStorage() async {
    var storedTimeEntry = storage.getItem('entries');
    if (storedTimeEntry != null) {
      _entries = List<TimeEntry>.from(
        (storedTimeEntry as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntryToStorage();
    notifyListeners();
  }

  void _saveTimeEntryToStorage() {
    storage.setItem(
      'entries',
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }

  void addOrUpdateTimeEntry(TimeEntry entry) {
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }
    _saveTimeEntryToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryToStorage();
    notifyListeners();
  }

  void addProject(project) {
    if (!_project.any((projct) => projct.name == projct.name)) {
      _project.add(project);
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    _project.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void addTask(Task task) {
    if (!_task.any((t) => t.name == task.name)) {
      _task.add(task);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _task.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void removeTimeEntry(String id) {
    _entries.removeWhere((entries) => entries.id == id);
    _saveTimeEntryToStorage();
    notifyListeners();
  }
}
