import 'package:flutter/material.dart';

class FlowItLogo extends StatelessWidget {
  const FlowItLogo({super.key, this.size = 32, this.style = FlowItLogoStyle.text});

  final double size;
  final FlowItLogoStyle style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case FlowItLogoStyle.text:
        return Text(
          '💧 FlowIt',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: size,
              ),
        );

      case FlowItLogoStyle.icon:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(size / 4),
          ),
          child: Icon(Icons.water_drop, size: size * 0.6, color: Colors.white),
        );

      case FlowItLogoStyle.badge:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.5, vertical: size * 0.3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, size: size * 0.8, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: size * 0.4),
              Text('FlowIt', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        );
    }
  }
}

enum FlowItLogoStyle { text, icon, badge }
