import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/helpers/validator/email_validator.dart';

class OTPTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool? readOnly;
  final TextEditingController? controller;
  const OTPTextField({super.key, this.hintText, this.labelText, this.controller, this.readOnly});

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  RxBool isPhone = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofillHints: const [AutofillHints.oneTimeCode],
        keyboardAppearance: Brightness.dark,
        keyboardType: TextInputType.number,
        cursorColor: CustomColor.defaultColor,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Mohon isikan ${widget.labelText}';
          }else if(validateEmailBool(value) == false){
            return 'Mohon isikan ${widget.labelText} yang benar';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            color: CustomColor.textThemeDarkSoftColor
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: CustomColor.defaultColor),
          filled: false,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                  color: CustomColor.defaultColor
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                  color: CustomColor.textThemeDarkSoftColor
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                  color: CustomColor.textThemeDarkSoftColor
              )
          )
        ),
        onChanged: (value) {
          if(value.length > 4){
            isPhone(true);
          }else{
            isPhone(false);
          }
        },
      ),
    );
  }
}