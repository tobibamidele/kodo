import 'package:flutter/material.dart';

/// Shows the custom bottom modal of the app
void showKodoBottomModal(
  BuildContext context, {
  required Widget Function(VoidCallback dismiss) builder,
  Color? backgroundColor,
  bool dismissOnTapOutside = true,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  backgroundColor = backgroundColor ?? Theme.of(context).cardTheme.color;

  entry = OverlayEntry(
    builder: (context) {
      return _BottomModal(
        dismissOnTapOutside: dismissOnTapOutside,
        backgroundColor: backgroundColor,
        onDismissed: () => entry.remove(),
        childBuilder: (dismiss) => builder(dismiss),
      );
    },
  );

  overlay.insert(entry);
}

class _BottomModal extends StatefulWidget {
  final Widget Function(VoidCallback dismiss) childBuilder;
  final bool dismissOnTapOutside;
  final VoidCallback onDismissed;
  final Color? backgroundColor;

  const _BottomModal({
    required this.childBuilder,
    required this.backgroundColor,
    required this.onDismissed,
    required this.dismissOnTapOutside,
  });
  @override
  State<_BottomModal> createState() => __BottomModalState();
}

class __BottomModalState extends State<_BottomModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Dimmed background
          FadeTransition(
            opacity: _opacity,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.dismissOnTapOutside ? _dismiss : null,
              child: Container(color: Colors.black54),
            ),
          ),

          // Bottom panel
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slide,
              child: Material(
                color: widget.backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: SafeArea(
                  top: false,
                  child: widget.childBuilder(_dismiss),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
