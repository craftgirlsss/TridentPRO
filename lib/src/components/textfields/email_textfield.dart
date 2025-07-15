import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/helpers/validator/email_validator.dart';

class EmailTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? fieldName;
  final bool? readOnly;
  final bool? useValidator;
  final TextEditingController? controller;
  const EmailTextField({super.key, this.hintText, this.labelText, this.controller, this.readOnly, this.fieldName, this.useValidator});

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  RxBool isEmail = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofillHints: const [AutofillHints.email],
        keyboardType: TextInputType.emailAddress,
        cursorColor: CustomColor.defaultColor,
        validator: (value) {
          if(widget.useValidator == true) {
            if (value == null || value.isEmpty) {
              return 'Mohon isikan ${widget.fieldName}';
            } else if (validateEmailBool(value) == false) {
              return 'Mohon isikan ${widget.fieldName} yang benar';
            }
            return null;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            color: CustomColor.textThemeDarkSoftColor,
            fontSize: 14
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: CustomColor.textThemeDarkSoftColor),
          filled: false,
          suffix: widget.useValidator == true ? Obx(
              () => AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(2),
              decoration:  BoxDecoration(
                color: isEmail.value == false ? Colors.red : CustomColor.defaultColor,
                shape: BoxShape.circle),
              child: isEmail.value == false ? const Icon(Icons.close, color: Colors.white, size: 16) : const Icon(Icons.done, color: Colors.white, size: 16),
            ),
          ) : null,
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
            if(validateEmailBool(value) == true){
              isEmail(true);
            }else{
              isEmail(false);
            }
          },
        ),

    );
  }
}