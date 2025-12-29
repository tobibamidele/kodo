import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kodo/core/routing/app_routes.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/providers/settings/settings_page_controller.dart';
import 'package:kodo/src/state/settings/settings_page_state.dart';
import 'package:kodo/src/widgets/avatar.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsStateAsync = ref.watch(settingsPageControllerProvider);
    return settingsStateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (settingsState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: _buildSettingsPage(settingsState),
        );
      },
    );
  }

  Widget _buildSettingsPage(SettingsPageState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            ProfileHeader(user: state.user),
            Divider(),
            if (state.tiles != null)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.tiles!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      state.tiles![index].title,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      state.tiles![index].subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    leading: state.tiles![index].leading,
                    onTap: state.tiles![index].onTap,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends ConsumerStatefulWidget {
  final KodoUser? user;
  const ProfileHeader({super.key, required this.user});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Avatar(photoUrl: widget.user?.photoUrl, radius: 26),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user?.displayName ?? "",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "@${widget.user?.username}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.green.shade400),
                ),

                const SizedBox(height: 8),
                Text(
                  widget.user?.about ?? "",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // const SizedBox(width: 20),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit_rounded, color: Colors.green.shade400),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.qr_code_rounded, color: Colors.green.shade400),
                onPressed: () {
                  context.push(AppRoutes.qrCode);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
