import 'package:flutter/material.dart';

import '../Components/validations.dart';
import '../constants.dart';

class CustomTextBox extends StatelessWidget {
  final String? placeholderText;
  final bool required;
  final bool same;
  final String? password;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Function? onTap;
  final Function? onChange;
  final Function? onFieldSubmitted;
  final bool isForm;
  final bool autoFocus;
  final int? validator;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;

  CustomTextBox({
    this.focusNode,
    this.placeholderText,
    this.controller,
    this.errorText = 'Field cannot be left empty',
    this.required = false,
    this.same = false,
    this.autoFocus = false,
    this.password,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.maxLines,
    this.maxLength,
    this.onChange,
    this.onFieldSubmitted,
    this.prefix,
    this.suffix,
    this.validator,
    this.isForm = false,
  });

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        // color: textFieldColor,
      ),
      child: isForm
          ? TextFormField(
              onTap: () => onTap!(),
              focusNode: focusNode!,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              textInputAction: textInputAction!,
              validator: (value) => validations.validate(validator!, value!),
              style: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
              controller: controller!,
              onChanged: (val) {
                if (onChange != null) onChange!(val);
              },
              decoration: decor(),
              onFieldSubmitted: (val) {
                if (onFieldSubmitted != null) onFieldSubmitted!();
              },
              autofocus: autoFocus,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            )
          : TextField(
              onTap: () => onTap!(),
              focusNode: focusNode,
              keyboardType: keyboardType,
              obscureText: obscureText,
              readOnly: readOnly,
              maxLines: maxLines,
              maxLength: maxLength,
              style: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
              ),
              controller: controller,
              decoration: decor(),
              onSubmitted: (val) {
                if (onFieldSubmitted != null) onFieldSubmitted!();
              },
              autofocus: autoFocus,
            ),
    );
  }

  decor() {
    return InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding:
            new EdgeInsets.symmetric(vertical: 14, horizontal: 12.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: placeholderText,
        hintStyle: TextStyle(color: Colors.grey));
  }
}
