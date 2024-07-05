import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/box_decorator.dart';

class DatePickerRangeComponent extends StatelessWidget {
  final Function(DateTimeRange) onDateChanged;
  static final DateTime now = DateTime.now();
  static final DateTime _startDate =
      now.subtract(Duration(days: now.weekday - 1));
  static final DateTime _endDate = _startDate.add(const Duration(days: 6));
  final DateTimeRange initialDateRange =
      DateTimeRange(start: _startDate, end: _endDate);
  final bool isSemanal;

  DatePickerRangeComponent({
    super.key,
    required this.onDateChanged,
    required this.isSemanal,
  });

  _showDatePicker(BuildContext context) {
    showDateRangePicker(
      helpText: 'Selecione o Período',
      cancelText: 'Cancelar',
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(now.year + 1, 1, 1),
      keyboardType: TextInputType.datetime,
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (isSemanal) {
        final differenceInDays =
            pickedDate.end.difference(pickedDate.start).inDays;
        if (differenceInDays <= 6) {
          onDateChanged(pickedDate);
        } else {
          AlertComponent.show(context,
              title: "Ops!",
              subTitle: "Deve ser selecionado um período de no máximo 7 dias.",
              style: AlertStyle.error);
        }
      } else {
        onDateChanged(pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: constraints.maxWidth, maxWidth: constraints.maxWidth),
        child: Container(
          height: 60,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoratorComponent().boxDecorator(),
          child: Row(
            children: [
              TextButton(
                onPressed: () => _showDatePicker(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Selecionar",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(width: 5),
                    const SizedBox(
                      child: Icon(
                        Icons.calendar_month,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
