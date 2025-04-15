import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Taks Name'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newTaks = Task(
              id: DateTime.now().toString(),
              name: _controller.text,
            );
            widget.onAdd(newTaks);
            Provider.of<TimeEntryProvider>(
              context,
              listen: false,
            ).addTask(newTaks);
            _controller.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
