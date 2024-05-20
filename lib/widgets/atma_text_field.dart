import 'package:atmakitchen_mobile/constants/sizes.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isEnable;
  final bool isReadOnly;
  final bool mandatory;
  final int maxLines;
  final List<TextInputFormatter>? inputFormat;
  final String? initialValue;
  final Widget? suffixIcon;
  final double textFieldHeight;

  const AtmaTextField(
      {Key? key,
      this.title,
      this.hintText,
      this.controller,
      this.onChange,
      this.onSubmitted,
      this.obscureText = false,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.isEnable = true,
      this.isReadOnly = false,
      this.mandatory = false,
      this.maxLines = 1,
      this.inputFormat,
      this.suffixIcon,
      this.initialValue,
      this.textFieldHeight = 56.0})
      : super(key: key);

  @override
  State<AtmaTextField> createState() => _AtmaTextFieldState();
}

class _AtmaTextFieldState extends State<AtmaTextField> {
  late bool _obsecureText;
  final FocusNode _focusNode = FocusNode();

  Color _borderColor = TW3Colors.slate.shade400;

  @override
  void initState() {
    super.initState();
    _obsecureText = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {
        _borderColor = _focusNode.hasFocus
            ? TW3Colors.orange.shade600
            : TW3Colors.slate.shade400;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: widget.textFieldHeight,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(ASize.roundedSm),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12.0, bottom: 3.0),
        child: TextFormField(
            initialValue: widget.initialValue,
            inputFormatters: widget.inputFormat,
            readOnly: widget.isReadOnly,
            onChanged: widget.onChange,
            onFieldSubmitted: widget.onSubmitted,
            controller: widget.controller,
            obscureText: _obsecureText,
            validator: (val) {
              if ((val?.isEmpty ?? true) && widget.mandatory) {
                setState(() {
                  _borderColor = TW3Colors.red.shade600;
                });
                return '${(widget.hintText ?? widget.title ?? 'This Field').trim()} is required';
              }
              if (widget.validator != null) {
                final String? validationResult = widget.validator!(val);
                if (validationResult != null) {
                  setState(() {
                    _borderColor = TW3Colors.red.shade600;
                  });
                  return validationResult;
                }
              }
              return null;
            },
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            enabled: widget.isEnable,
            maxLines: widget.maxLines,
            focusNode: _focusNode,
            style: AStyle.textStyleNormal,
            cursorColor: TW3Colors.slate.shade900,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              filled: widget.isReadOnly,
              labelText: widget.title,
              floatingLabelStyle: TextStyle(color: TW3Colors.slate.shade800),
              suffixIcon: widget.suffixIcon ??
                  (widget.obscureText
                      ? IconButton(
                          icon: _obsecureText
                              ? Icon(
                                  Icons.visibility,
                                  color: _borderColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: _borderColor,
                                ),
                          onPressed: () {
                            setState(() {
                              _obsecureText = !_obsecureText;
                            });
                          },
                        )
                      : null),
            )),
      )
    ]);
  }
}
