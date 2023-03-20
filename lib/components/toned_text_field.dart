import 'package:flutter/material.dart';
import 'package:toned_australia/Components/validations.dart';

class SeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? title;
  final Function? onTap;
  final Function? onChange;
  final Function? onFieldSubmitted;
  final bool readOnly = false;
  final bool required = true;
  final double bottomPadding;
  final bool obscure;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool isForm;
  final bool autoFocus;
  final int? validator;
  final FocusNode focusNode;

  const SeTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    this.title,
    this.onTap,
    this.onChange,
    this.onFieldSubmitted,
    this.validator,
    this.textInputType = TextInputType.text,
    this.autoFocus = false,
    this.obscure = false,
    this.bottomPadding = 16,
    this.textInputAction = TextInputAction.done,
    this.isForm = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 6),
            child: Text(title!),
          ),
        ],
        TextFormField(
          controller: controller,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          obscureText: obscure,
          onFieldSubmitted: (val) {
            if (onFieldSubmitted != null) onFieldSubmitted!(val);
          },
          autofocus: autoFocus,
          validator: (value) => validations.validate(validator!, value!),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: textInputAction,
          focusNode: focusNode,
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }
}

Widget seTextField({
  required TextEditingController controller,
  required String hintText,
  String? title,
  Function? onTap,
  Function? onChange,
  Function? onFieldSubmitted,
  bool readOnly = false,
  bool required = true,
  double bottomPadding = 16,
  bool obscure = false,
  TextInputType textInputType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.done,
  bool isForm = false,
  bool autoFocus = false,
  int? validator,
  required FocusNode focusNode,
}) {
  Validations validations = Validations();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 6),
        child: title == null ? Container() : Text(title),
      ),
      TextFormField(
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        obscureText: obscure,
        onFieldSubmitted: (val) {
          if (onFieldSubmitted != null) onFieldSubmitted(val);
        },
        autofocus: autoFocus,
        validator: (value) => validations.validate(validator!, value!),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        focusNode: focusNode,
      ),
      SizedBox(height: bottomPadding),
    ],
  );
}

/*
import 'package:flutter/material.dart';

import 'text_box.dart';

Widget seTextField({
  required TextEditingController controller,
  required String hintText,
  String? title,
  Function? onTap,
  Function? onChange,
  Function? onFieldSubmitted,
  bool readOnly = false,
  bool required = true,
  double bottomPadding = 16,
  bool obscure = false,
  TextInputType textInputType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.done,
  bool isForm = false,
  bool autoFocus = false,
  int? validator,
  int? maxLines,
  int? maxLength,
  Widget? prefix,
  Widget? suffix,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 6),
        child: title == null ? Container() : Text(title),
      ),
      CustomTextBox(
        required: required,
        controller: controller,
        // onTap: onTap!,
        readOnly: readOnly,
        obscureText: obscure,
        keyboardType: textInputType,
        isForm: isForm,
        validator: validator!,
        // prefix: prefix!,
        placeholderText: hintText,
        // suffix: suffix!,
        // onChange: onChange!,
        // onFieldSubmitted: onFieldSubmitted!,
        textInputAction: textInputAction,
        // maxLines: maxLines!,
        // maxLength: maxLength!,
        autoFocus: autoFocus,
      ),
      SizedBox(
        height: bottomPadding
      ),
    ],
  );
}

* */
