import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color activeColor = colorScheme.primary;
    final Color inactiveColor = colorScheme.primary.withOpacity(0.25);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 30 : 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}
