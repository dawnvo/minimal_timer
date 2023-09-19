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
        child: Column(children: [
          SizedBox(
            height: mediaQuery.size.height / 1.2,
            child: Center(child: timer),
          ),
          button,
        ]),
      ),
    );
  }
}
