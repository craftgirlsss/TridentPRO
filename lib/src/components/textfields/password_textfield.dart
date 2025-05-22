import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tridentpro/src/components/colors/default.dart';
import 'package:tridentpro/src/helpers/validator/email_validator.dart';

class PasswordTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? fieldName;
  final bool? readOnly;
  final TextEditingController? controller;
  const PasswordTextField({super.key, this.hintText, this.labelText, this.controller, this.readOnly, this.fieldName});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  RxBool isEmail = false.obs;
  RxBool show = true.obs;
  RxBool isEightCharacter = false.obs;

  @override
  void initState() {
    super.initState();
    if(validateEmailBool(widget.controller?.text) == true){
      isEmail(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(
        () => TextFormField(
          readOnly: widget.readOnly ?? false,
          controller: widget.controller,
          obscureText: show.value,
          cursorColor: CustomColor.defaultColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: const [AutofillHints.password],
          keyboardAppearance: Brightness.dark,
          validator: (value){
            RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~/]).{8,}$');
            var passNonNullValue = value ?? "";
            if(passNonNullValue.isEmpty){
              return ("Mohon inputkan kata sandi");
            }
            else if(passNonNullValue.length < 8){
              return ("Kata sandi kurang dari 8 karakter");
            }
            else if(!regex.hasMatch(passNonNullValue)){
              return ("Kata sandi tidak terdapat huruf kapital, huruf kecil, angka atau simbol");
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
            labelStyle: const TextStyle(color: CustomColor.defaultColor),
            filled: false,
            suffixIcon: CupertinoButton(
              onPressed: (){
                show.value = !show.value;
              },
              child: show.value ? Icon(HeroIcons.eye, color: CustomColor.textThemeDarkSoftColor) : Icon(HeroIcons.eye_slash, color: CustomColor.textThemeDarkSoftColor),
            ),
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
            if(value.length < 8){
              isEightCharacter(false);
            }else{
              isEightCharacter(true);
            }
          },
        ),
      ),
    );
  }
}