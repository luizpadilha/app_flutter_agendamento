import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybabernew/components/box_decorator.dart';
import 'package:mybabernew/components/input_decorator.dart';
import 'package:mybabernew/constants.dart';

class DatePickerComponent extends StatelessWidget {
  final Function(DateTime) onDateChanged;
  final bool isForm;
  final bool hasTime;

  DatePickerComponent({
    required this.onDateChanged,
    required this.isForm,
    required this.hasTime,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      helpText: 'Selecione a Data',
      cancelText: 'Cancelar',
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 366)),
      keyboardType: TextInputType.datetime,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (hasTime) {
        showTimePicker(
          helpText: 'Selecione o Horário',
          cancelText: 'Cancelar',
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true),
              child: child ?? Container(),
            );
          },
        ).then((pickedTime) {
          if (pickedTime == null) {
            return;
          }
          DateTime pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          onDateChanged(pickedDateTime);
        });
      } else {
        onDateChanged(pickedDate);
      }
    });
  }

  _showCupertinoModalPopup(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: deviceSize.height * 0.40,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.white,
                    use24hFormat: true,
                    mode: hasTime ? CupertinoDatePickerMode.dateAndTime : CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime.now(),
                    onDateTimeChanged: onDateChanged,
                    showDayOfWeek: true,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: <Widget>[
          TextButton(
            onPressed: () => _showDatePicker(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      );
    });
  }
}
