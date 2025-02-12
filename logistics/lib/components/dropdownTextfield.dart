import 'package:flutter/material.dart';

class MyDropDownTextField extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final InputDecoration? decoration;
  final Color borderColor;
  final double borderWidth;
  final Color selectedTextColor;

  const MyDropDownTextField({
    required this.labelText,
    required this.options,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.isEnabled = true,
    this.decoration,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.selectedTextColor = const Color(0xFF0F0156),
    super.key,
  });

  @override
  State<MyDropDownTextField> createState() => _MyDropDownTextFieldState();
}

class _MyDropDownTextFieldState extends State<MyDropDownTextField> {
  late final TextEditingController _controller;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _selectedValue = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      enabled: widget.isEnabled,
      validator: widget.validator,
      style: TextStyle(color: widget.selectedTextColor), // Selected text color
      decoration: (widget.decoration ??
              InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(color: Color(0xFF0F0156)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: widget.borderWidth,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: widget.borderWidth,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: widget.borderWidth + 1,
                  ),
                ),
              ))
          .copyWith(
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedValue,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: widget.isEnabled
                ? (String? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                      _controller.text = newValue ?? '';
                    });
                    if (widget.onChanged != null && newValue != null) {
                      widget.onChanged!(newValue);
                    }
                  }
                : null,
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: _selectedValue == value
                        ? widget.selectedTextColor
                        : Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      readOnly: true,
    );
  }
}
