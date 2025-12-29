import 'package:flutter/material.dart';
import 'package:kodo/src/services/user_service.dart';
import 'package:kodo/src/widgets/add_user_modal.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';
import 'package:kodo/src/widgets/input_field.dart';
import 'package:kodo/utils/helpers.dart';

class FindUserPage extends StatefulWidget {
  static const String routeName = "/find-user";
  const FindUserPage({super.key});
  @override
  State<FindUserPage> createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  bool doesUserExist = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Find a user",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Enter a username into the text box below to start a new chat.",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
              inputFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            "@",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: InputField(
            controller: controller,
            focusNode: focusNode,
            labelText: "Enter a username",
            onSubmitted: () async {
              final user = await KodoUserService().getUserByUsername(
                controller.text.trim(),
              );
              if (user == null) {
                setState(() {
                  doesUserExist = false;
                });
              } else {
                setState(() {
                  doesUserExist = true;
                });
                if (user.username == getCurrentUsername()) {
                  setState(() {
                    doesUserExist = false;
                  });
                  return;
                }
                if (!mounted) return;
                showKodoBottomModal(
                  context,
                  builder: (dismiss) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // critical
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              AddUserModal(user: user, dismiss: dismiss),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            textInputType: TextInputType.text,
            onChanged: (_) {},
            suffixIcon: (controller.text.trim().isNotEmpty)
                ? doesUserExist
                      ? Icon(Icons.check)
                      : Icon(Icons.error)
                : null,
          ),
        ),
      ],
    );
  }
}
