import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  static const String routeName = "/onboarding";
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: bottomButtons(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png", height: 250),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _buildText(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: <TextSpan>[
              TextSpan(
                text: "Connect easily with\n",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),

              TextSpan(
                text: "Kodo",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                  color: Colors.green.shade900,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Text(
          "Chat with friends and loved ones the Kodo way.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget bottomButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60, right: 35, left: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    context.push(AppRoutes.register);
                  },
                  child: Text(
                    "Get started",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.login);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
