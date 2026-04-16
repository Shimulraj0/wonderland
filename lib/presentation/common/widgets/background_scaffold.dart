import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget body;
  final bool showBottomNav;

  const BackgroundScaffold({
    super.key,
    required this.body,
    this.showBottomNav = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Root background is visible
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: body,
      ),
    );
  }
}
