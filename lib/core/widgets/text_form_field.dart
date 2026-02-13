import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String label;
  final Icon icon;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final OutlineInputBorder? style;

  const TextFormFieldWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    required this.validator,
    required this.style,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool isShowPassword;

  @override
  void initState() {
    super.initState();
    isShowPassword = true;
  }

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
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
