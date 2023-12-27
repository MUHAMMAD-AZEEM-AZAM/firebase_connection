import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickWidget extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  DatePickWidget({required this.onDateTimeSelected});

  @override
  _DatePickWidgetState createState() => _DatePickWidgetState();
}

class _DatePickWidgetState extends State<DatePickWidget> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDateAndTime(BuildContext context) async {
    DateTime? pickedDate;
    TimeOfDay? pickedTime;
    int currentYear = DateTime.now().year;

    pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(currentYear),
      lastDate: DateTime(currentYear + 5),
    );

    if (pickedDate != null) {
      pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate!.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime!.hour,
            pickedTime.minute,
          );
          _selectedTime = pickedTime;
        });

        widget.onDateTimeSelected(_selectedDate);
      } else {}
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
            onPressed: () => _selectDateAndTime(context),
            child: Text(
              "Select Event Date and Time",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          // SizedBox(height: 20.0),
            Text(
              "Date and Time: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(_selectedDate)}",
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
