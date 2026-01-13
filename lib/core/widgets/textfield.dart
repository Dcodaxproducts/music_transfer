import 'package:pixart_app/imports.dart';
import '../theme/src/input_decoration_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final bool obscureText;
  final FocusNode? focusNode;
  final List<String>? autofillHints;

  const CustomTextField({
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.obscureText = false,
    this.focusNode,
    this.autofillHints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      focusNode: focusNode,
      obscureText: obscureText,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20.sp, color: context.theme.hintColor) : null,
        hintText: hintText,
        enabledBorder: border(color: context.theme.dividerColor),
        suffixIcon: suffixIcon,
      ),
      style: context.font14,
    );
  }
}
