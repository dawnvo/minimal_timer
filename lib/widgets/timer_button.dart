import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerButton extends ConsumerWidget {
  const TimerButton({
    required this.child,
    this.onPressed,
    this.isSecondary = false,
    this.isDestructiveAction = false,
  });

  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isDestructiveAction;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final buttonColor = isDestructiveAction
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    const buttonSize = Size(120, 48);

    if (!isSecondary) {
      return FilledButton(
        style: FilledButton.styleFrom(
          fixedSize: buttonSize,
          textStyle: theme.textTheme.bodyLarge,
          backgroundColor: buttonColor.withOpacity(0.6),
        ),
        onPressed: onPressed,
        child: child,
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          fixedSize: buttonSize,
          textStyle: theme.textTheme.bodyLarge,
          side: BorderSide(color: buttonColor.withOpacity(0.8)),
          foregroundColor: buttonColor,
        ),
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
