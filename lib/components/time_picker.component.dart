import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerComponent extends StatelessWidget {
  final Function(TimeOfDay) onTimeChanged;
  final String helpText;

  TimePickerComponent({
    required this.onTimeChanged,
    required this.helpText,
  });

  _showTimePicker(BuildContext context) {
    showTimePicker(
      helpText: helpText,
      cancelText: 'Cancelar',
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      onTimeChanged(pickedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: <Widget>[
          TextButton(
            onPressed: () => _showTimePicker(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      );
    });
  }
}
