import 'package:flutter/material.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';

/// DOKAN Official Brand Logo Widget
/// Uses the official asset image provided by the user (`assets/images/dokan_logo.png`).
class DokanLogo extends StatelessWidget {
  final double size;
  final bool isWhite;
  final bool showTagline;

  const DokanLogo({
    super.key,
    this.size = 40,
    this.isWhite = false,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter: isWhite
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
          child: Image.asset(
            'assets/images/dokan_logo.png',
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                height: size,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: isWhite ? Colors.white : kEmeraldGreen,
                      size: size * 0.8,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'دكان OKAN',
                      style: TextStyle(
                        fontSize: size * 0.45,
                        fontWeight: FontWeight.w900,
                        color: isWhite ? Colors.white : kDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 12),
          Text(
            'كل اللي نفسك فيه عند بابك',
            style: TextStyle(
              color: isWhite ? Colors.white : kDark,
              fontSize: size * 0.22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
