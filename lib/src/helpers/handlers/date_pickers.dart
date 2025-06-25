import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomDatePicker {

  static String formatTanggalIndonesia(DateTime dateTime) {
    final DateFormat formatter = DateFormat("EEEE, dd MMMM yyyy HH:mm:ss", "id_ID");
    return formatter.format(dateTime);
  }

  static String formatIndonesiaDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat("EEEE, dd MMMM yyyy", "id_ID");
    return formatter.format(dateTime);
  }

  static String normalFormat(DateTime dateTime) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    return formatter.format(dateTime);
  }

  static Future<DateTime?> material(BuildContext context, {int? firstYear}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(firstYear ?? 1950),
      lastDate: DateTime.now(),
    );
    return pickedDate;
  }
}