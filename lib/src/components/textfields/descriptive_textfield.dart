import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tridentpro/src/components/colors/default.dart';

class DescriptiveTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final bool? readOnly;
  final String? fieldName;
  final TextEditingController? controller;
  final bool? useValidator;
  const DescriptiveTextField({super.key, this.hintText, this.labelText, this.controller, this.readOnly, this.fieldName, this.useValidator});

  @override
  State<DescriptiveTextField> createState() => _DescriptiveTextFieldState();
}

class _DescriptiveTextFieldState extends State<DescriptiveTextField> {
  RxBool isName = false.obs;

  @override
  void initState() {
    super.initState();
    if((widget.controller?.text.length ?? 0) > 2){
      isName(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(
        () => TextFormField(
          minLines: 5,
          maxLines: 5,
          readOnly: widget.readOnly ?? false,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: const [AutofillHints.name],
          keyboardAppearance: Brightness.dark,
          keyboardType: TextInputType.name,
          style: GoogleFonts.inter(),
          cursorColor: CustomColor.defaultColor,
          validator: (value) {
            if(widget.useValidator == true){
              if (value == null || value.isEmpty) {
                return 'Mohon isikan ${widget.fieldName}';
              }else if(!isName.value){
                return 'Mohon isikan ${widget.fieldName} yang benar';
              }
              return null;
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: widget.hintText,
              alignLabelWithHint: true,
              hintStyle: GoogleFonts.inter(
                color: CustomColor.textThemeDarkSoftColor,
                fontSize: 14
              ),
              labelText: widget.labelText,
              labelStyle: const TextStyle(color: CustomColor.textThemeDarkSoftColor),
              filled: false,
              suffix: widget.useValidator == false ? const SizedBox() : AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(2),
                decoration:  BoxDecoration(
                    color: isName.value == false ? Colors.red : CustomColor.defaultColor,
                    shape: BoxShape.circle),
                child: isName.value == false ? const Icon(Icons.close, color: Colors.white, size: 16) : const Icon(Icons.done, color: Colors.white, size: 16),
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
            if(value.length > 2){
              isName(true);
            }else{
              isName(false);
            }
          },
        ),
      ),
    );
  }
}