import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_application/sql/items.dart';

class StatusDropdown extends StatefulWidget {
  List<Status> status;

  Function(Status) statusCallback;

  StatusDropdown(
      this.status,
      this.statusCallback, {
        Key? key,
      }) : super(key: key);

  @override
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  var selectedStatus;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Status>(
        value: selectedStatus,
        hint: const Text('Select Status'),
        isExpanded: true,
        items: widget.status.map((statusTable){
          return DropdownMenuItem(
            value: statusTable,
            child: Text(statusTable.status!),
          );
        }).toList(),
        onChanged: (Status? value){
          setState(() {
            widget.statusCallback(value!);
            selectedStatus = value;
          });
        }
    );
  }
}
