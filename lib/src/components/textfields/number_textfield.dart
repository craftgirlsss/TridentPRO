import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class NumberTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool? readOnly;
  final String? fieldName;
  final int? maxLength;
  final TextEditingController? controller;
  const NumberTextField({super.key, this.hintText, this.labelText, this.controller, this.readOnly, this.fieldName, this.maxLength});

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  RxBool isNumber = false.obs;
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(
        () => isLoading.value ? const SizedBox() : TextFormField(
          readOnly: widget.readOnly ?? false,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUnfocus,
          keyboardType: TextInputType.number,
          cursorColor: CustomColor.defaultColor,
          validator: (value) {
            int? length = widget.maxLength ?? 1;
            if (value == null || value.isEmpty) {
              return 'Mohon isikan ${widget.fieldName}';
            }else if(!isNumber.value){
              return 'Mohon isikan ${widget.fieldName} yang benar';
            }else if(value.length < length){
              return 'Mohon isikan ${widget.fieldName} dengan jumlah yang benar';
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
              suffix: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isNumber.value == false ? Colors.red : CustomColor.defaultColor,
                  shape: BoxShape.circle),
                child: isNumber.value == false ? const Icon(Icons.close, color: Colors.white, size: 16) : const Icon(Icons.done, color: Colors.white, size: 16),
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
            int? length = widget.maxLength ?? 1;
            if(value.length > length){
              isNumber(true);
            }else{
              isNumber(false);
            }
          },
        ),
      ),
    );
  }
}