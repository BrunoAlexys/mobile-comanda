import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_comanda/util/utils.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final Color? cursorColor;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final double borderRadius;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.borderColor,
    this.cursorColor,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.borderRadius = 6.0,
    this.hintStyle,
    this.contentPadding,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscureText,
      cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscureText ? Icons.lock_outline : Icons.lock_open,
                  color: Colors.grey,
                ),
                onPressed: _toggleObscureText,
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: widget.fillColor ?? Utils.hexToColor('F9FAFB'),
        contentPadding: widget.contentPadding,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor ?? Utils.hexToColor('D9D9D9'),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor ?? Utils.hexToColor('D9D9D9'),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
      ),
    );
  }
}
