import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.maxLine,
    required this.hintText,
    this.validator,
    required this.title,
  });

  final TextEditingController controller;
  final int? maxLine;
  final String? hintText;
  final String title;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.displaySmall!.copyWith(fontSize: 16),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(
            context,
          ).textTheme.labelMedium,
          maxLines: maxLine,
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
