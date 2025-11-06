import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class HintSystemWidget extends ConsumerWidget {
  const HintSystemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(puzzleProvider);
    final hintsUsed = puzzle.hintsUsed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (hintsUsed > 0 ? Color(0xFFFFB3D9) : Color(0xFF5A3D8A)).withOpacity(0.6),
            (hintsUsed > 0 ? Color(0xFFC9A9E9) : Color(0xFF3B2667)).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hintsUsed > 0 
              ? Color(0xFFFFB3D9).withOpacity(0.6)
              : Color(0xFFB794F6).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hintsUsed > 0
                    ? [Color(0xFFFFB3D9), Color(0xFFC9A9E9)]
                    : [Color(0xFFD4A5FF), Color(0xFFB794F6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              hintsUsed > 0 ? Icons.lightbulb : Icons.lightbulb_outline,
              color: Color(0xFF1A0B2E),
              size: 16,
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PISTAS: $hintsUsed',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF2E9FE),
                    letterSpacing: 0.5,
                  ),
                ),
                if (hintsUsed > 0)
                  Text(
                    '-${hintsUsed * 50} pts',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: hintsUsed > 0
                          ? Color(0xFFFFB3D9)
                          : Color(0xFFB8A3D4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

