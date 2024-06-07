import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerComponent extends StatelessWidget {
  final Function(DateTime) onDateChanged;
  final bool isForm;
  final bool hasTime;
  final DateTime firstDate;
  final DateTime initialDate;

  DatePickerComponent({
    required this.onDateChanged,
    required this.isForm,
    required this.hasTime,
    required this.firstDate,
    required this.initialDate,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, // button text color
                ),
              ),
            ),
            child: child!);
      },
      helpText: 'Selecione a Data',
      cancelText: 'Cancelar',
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 366)),
      keyboardType: TextInputType.datetime,
      barrierColor: Colors.black,
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
            return Theme(
              data: Theme.of(context).copyWith(
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),

                ),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: true,
                ),
                child: child ?? Container(),
              ),
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
                    mode: hasTime
                        ? CupertinoDatePickerMode.dateAndTime
                        : CupertinoDatePickerMode.date,
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
      return IconButton(
        color: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.calendar_month),
        onPressed: () => _showDatePicker(context),
      );
    });
  }
}
