import 'package:flutter/material.dart';
import 'package:notes_application/sql/items.dart';

class PrioritiesDropdown extends StatefulWidget {
  List<Priority> priorities;

  Function(Priority) priorityCallback;

  PrioritiesDropdown(
      this.priorities,
      this.priorityCallback, {
        Key? key,
      }) : super(key: key);

  @override
  State<PrioritiesDropdown> createState() => _PrioritiesDropdownState();
}

class _PrioritiesDropdownState extends State<PrioritiesDropdown> {
  var selectedPriority;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Priority>(
        value: selectedPriority,
        hint: const Text('Select Priority'),
        isExpanded: true,
        items: widget.priorities.map((priorityTable){
          return DropdownMenuItem(
            value: priorityTable,
            child: Text(priorityTable.priority!),
          );
        }).toList(),
        onChanged: (Priority? value){
          setState(() {
            widget.priorityCallback(value!);
            selectedPriority = value;
          });
        }
    );
  }
}
