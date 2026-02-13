import 'package:flutter/material.dart';

class TextFieldwidget extends StatefulWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final OutlineInputBorder? style;
  const TextFieldwidget({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    required this.validator,
    required this.style,
  });

  @override
  State<TextFieldwidget> createState() => _TextFieldwidgetState();
}

bool isShowPassword = true;

class _TextFieldwidgetState extends State<TextFieldwidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.isPassword ? !isShowPassword : false,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        hintText: widget.label,
        suffixIcon: widget.isPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                child: Icon(
                  isShowPassword ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
