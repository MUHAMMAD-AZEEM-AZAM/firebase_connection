import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePick extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  DatePick({required this.onDateSelected});

  @override
  _DatePickWidgetState createState() => _DatePickWidgetState();
}

class _DatePickWidgetState extends State<DatePick> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Set your preferred range
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });

      widget.onDateSelected(_selectedDate);
      print(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _selectDate(context), // Only select date
            child: Text(
              "Select Date of Birth",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          // SizedBox(height: 20.0),
          Text(
            "Date Of Birth: ${_selectedDate != null ? DateFormat('dd-MM-yyyy').format(_selectedDate!) : 'Not selected'}",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
