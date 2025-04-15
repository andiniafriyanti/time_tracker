import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? initTimeEntry;
  const AddTimeEntryScreen({super.key, this.initTimeEntry});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  void initState() {
    super.initState();
    date = widget.initTimeEntry?.date ?? DateTime.now();
    projectId = widget.initTimeEntry?.projectId;
    taskId = widget.initTimeEntry?.taskId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF4E9A8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                value: projectId,
                onChanged: (String? newValue) {
                  setState(() {
                    projectId = newValue!;
                  });
                },
                items:
                    Provider.of<TimeEntryProvider>(context).project
                        .map(
                          (Project project) => DropdownMenuItem<String>(
                            value: project.id,
                            child: Text(project.name),
                          ),
                        )
                        .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a project';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Task',
                  border: OutlineInputBorder(),
                ),
                value: taskId,
                onChanged: (String? newValue) {
                  setState(() {
                    taskId = newValue!;
                  });
                },
                items:
                    Provider.of<TimeEntryProvider>(context).task
                        .map(
                          (Task task) => DropdownMenuItem<String>(
                            value: task.id,
                            child: Text(task.name),
                          ),
                        )
                        .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a task';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${DateFormat('yyyy-MM-dd').format(date)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                      ),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != date) {
                          setState(() {
                            date = picked;
                          });
                        }
                      },
                      child: const Text(
                        'Select Date',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Time (in hours)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                  }
                  return null;
                },
                onSaved: (value) => notes = value!,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final provider = Provider.of<TimeEntryProvider>(
                        context,
                        listen: false,
                      );
                      final selectedProject = provider.project.firstWhere(
                        (p) => p.id == projectId,
                      );
                      final selectedTask = provider.task.firstWhere(
                        (t) => t.id == taskId,
                      );
                      Provider.of<TimeEntryProvider>(
                        context,
                        listen: false,
                      ).addTimeEntry(
                        TimeEntry(
                          id: DateTime.now().toString(),
                          projectId: projectId!,
                          taskId: taskId!,
                          totalTime: totalTime,
                          date: date,
                          notes: notes,
                          projectName: selectedProject.name,
                          taskName: selectedTask.name,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Time Entry',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
