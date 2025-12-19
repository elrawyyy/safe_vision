import 'package:flutter/material.dart';
import 'theme_controller.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ValueListenableBuilder(
        valueListenable: ThemeController.themeMode,
        builder: (_, ThemeMode mode, __) {
          return Icon(
            mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
          );
        },
      ),
      onPressed: ThemeController.toggleTheme,
    );
  }
}
