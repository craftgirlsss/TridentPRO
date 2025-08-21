import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk currency formatter
import 'package:tridentpro/src/components/colors/default.dart';

class NumberTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool? readOnly;
  final String? fieldName;
  final int? maxLength;
  final int? minLength;
  final String? preffix;
  final TextEditingController? controller;
  final bool? useValidator;
  final IconData? iconData;
  final Function(String)? onSubmitted;
  final bool? withCurrencyFormatter; // tambahan
  final String? currencyType; // tambahan, contoh: "US", "ID"

  const NumberTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.minLength,
    this.controller,
    this.readOnly,
    this.onSubmitted,
    this.fieldName,
    this.maxLength,
    this.useValidator,
    this.preffix,
    this.withCurrencyFormatter = false, // default false
    this.currencyType = "ID", this.iconData, // default Indonesia
  });

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  RxBool isNumber = false.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    if ((widget.controller?.text.length ?? 0) >= 1) {
      isNumber(true);
      setState(() {});
    }
  }

  String _formatCurrency(String value) {
    // Hilangkan semua karakter non-digit
    String numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.isEmpty) return '';

    // Tentukan locale berdasarkan currencyType
    String locale = 'id_ID';
    String symbol = 'Rp ';
    if (widget.currencyType?.toUpperCase() == 'US') {
      locale = 'en_US';
      symbol = '\$ ';
    }

    final formatter = NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);
    return formatter.format(int.parse(numericString));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(
        () => isLoading.value
          ? const SizedBox()
          : TextFormField(
            readOnly: widget.readOnly ?? false,
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUnfocus,
            keyboardType: TextInputType.number,
            maxLength: widget.maxLength ?? 100,
            cursorColor: CustomColor.secondaryColor,
            validator: (value) {
              if (widget.useValidator == true) {
                if (value == null || value.isEmpty) {
                  return 'Mohon isikan ${widget.fieldName}';
                } else if (!isNumber.value) {
                  return 'Mohon isikan ${widget.fieldName} yang benar';
                }
                return null;
              }
              return null;
            },
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              prefixIcon: SizedBox(width: 30, child: Icon(widget.iconData ?? AntDesign.number_outline, color: Colors.black54),),
              prefix: Text(widget.preffix ?? "",
                  style: GoogleFonts.inter(fontSize: 18)),
              hintText: widget.hintText,
              hintStyle: GoogleFonts.inter(
                  color: CustomColor.textThemeDarkSoftColor,
                  fontSize: 14),
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                  color: CustomColor.textThemeDarkSoftColor),
              filled: false,
              suffix: widget.useValidator == false
                ? const SizedBox()
                : AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isNumber.value == false
                      ? Colors.red
                      : CustomColor.secondaryColor,
                    shape: BoxShape.circle),
                  child: isNumber.value == false
                    ? const Icon(Icons.close,
                      color: Colors.white, size: 16)
                    : const Icon(Icons.done,
                      color: Colors.white, size: 16),
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: CustomColor.secondaryColor)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: CustomColor.textThemeDarkSoftColor)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: CustomColor.textThemeDarkSoftColor))),
            onChanged: (value) {
              if (widget.withCurrencyFormatter == true) {
                String formatted = _formatCurrency(value);
                widget.controller?.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }

              if (value.length >= (widget.maxLength ?? 0)) {
                isNumber(true);
              } else {
                isNumber(false);
              }
            },
          ),
      ),
    );
  }
}
