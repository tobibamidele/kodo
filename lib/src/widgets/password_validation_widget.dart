import 'package:flutter/material.dart';

class PasswordValidationWidget extends StatefulWidget {
  final String password;
  final PasswordValidation passwordValidation;
  const PasswordValidationWidget({
    super.key,
    required this.password,
    required this.passwordValidation,
  });

  @override
  State<PasswordValidationWidget> createState() =>
      _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState extends State<PasswordValidationWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8, // horizontal spacing
        runSpacing: 8, // vertical spacing
        children: [
          _ValidationChip(
            text: 'At least 8 characters',
            isValid: widget.passwordValidation.hasMinLength,
          ),
          _ValidationChip(
            text: 'One uppercase letter (A-Z)',
            isValid: widget.passwordValidation.hasUppercase,
          ),
          _ValidationChip(
            text: 'One lowercase letter (a-z)',
            isValid: widget.passwordValidation.hasLowercase,
          ),
          _ValidationChip(
            text: 'One number',
            isValid: widget.passwordValidation.hasDigit,
          ),
          _ValidationChip(
            text: 'One special character',
            isValid: widget.passwordValidation.hasSpecialChar,
          ),
        ],
      ),
    );
  }
}

class _ValidationChip extends StatelessWidget {
  final String text;
  final bool isValid;

  const _ValidationChip({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).textTheme.labelSmall!.color!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isValid ? Colors.green : baseColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // critical for Wrap
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isValid ? Colors.green : baseColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontSize: 11,
              color: isValid ? Colors.green : baseColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordValidation {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecialChar;

  const PasswordValidation({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecialChar,
  });

  bool get isValid =>
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasDigit &&
      hasSpecialChar;

  static PasswordValidation newValidator() {
    return PasswordValidation(
      hasMinLength: false,
      hasDigit: false,
      hasLowercase: false,
      hasSpecialChar: false,
      hasUppercase: false,
    );
  }

  static validate(String password) {
    return PasswordValidation(
      hasMinLength: password.length >= 8,
      hasUppercase: password.contains(RegExp(r'[A-Z]')),
      hasLowercase: password.contains(RegExp(r'[a-z]')),
      hasDigit: password.contains(RegExp(r'[0-9]')),
      hasSpecialChar: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    );
  }
}
