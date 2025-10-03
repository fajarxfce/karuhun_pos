import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final bool required;
  final bool isLoading;

  const CustomDropdown({
    Key? key,
    required this.label,
    this.hintText,
    this.errorText,
    this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.required = false,
    this.isLoading = false,
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
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          onChanged: isLoading ? null : onChanged,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
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