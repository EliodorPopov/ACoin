import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime> getCupertinoDate(context, TextEditingController dateController,
    DateTime initialDate, DateFormat dateFormat) {
  DateTime returnDate = initialDate;
  return showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              initialDateTime: returnDate,
              onDateTimeChanged: (DateTime newdate) {
                returnDate = newdate;
              },
              use24hFormat: true,
              maximumDate: new DateTime(2030, 1, 1),
              minimumYear: 2010,
              maximumYear: 2030,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.dateAndTime,
            ));
      }).then((_) {
    if (returnDate == null) {
      returnDate = DateTime.now();
    }
    dateController.text = dateFormat.format(returnDate);
    return returnDate;
  });
}
