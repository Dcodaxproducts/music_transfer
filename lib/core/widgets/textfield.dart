import 'package:pixart_app/imports.dart';
import '../theme/src/input_decoration_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText, hintText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool filled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final bool obscureText;

  const CustomTextField({
    this.controller,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.filled = false,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.obscureText = false,
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
      onSaved: onSaved,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: filled,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20.sp, color: context.theme.hintColor) : null,
        hintText: hintText,
        enabledBorder: border(color: context.theme.dividerColor),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20.sp, color: context.theme.hintColor) : null,
      ),
      style: context.font14,
    );
  }
}
