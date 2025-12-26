import 'dart:io';

import 'package:flutter/material.dart';

class KodoIconButtons {
  static IconButton backIcon(VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Platform.isIOS
          ? Icon(Icons.arrow_back_ios)
          : Icon(Icons.arrow_back),
    );
  }

  /// Returns the eye off or eye icon
  static IconButton eyeIcon(VoidCallback? onPressed, bool hide) {
    return IconButton(
      onPressed: onPressed,
      icon: hide ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
    );
  }
}
