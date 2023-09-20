import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({
    required this.timer,
    required this.button,
  });

  final Widget timer;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              height: mediaQuery.size.height * (4 / 5),
              child: Center(child: timer),
            ),
            button,
          ],
        ),
      ),
    );
  }
}
