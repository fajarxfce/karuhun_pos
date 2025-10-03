import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final String value;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool required;
  final Widget? suffix;

  const CustomFormField({
    Key? key,
    required this.label,
    this.hintText,
    this.errorText,
    required this.value,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            suffix: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}