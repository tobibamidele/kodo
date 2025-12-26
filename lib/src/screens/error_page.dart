import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? error;
  const ErrorPage({super.key, this.error});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Text(
              (error != null) ? error! : "Oops... An error occured",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
