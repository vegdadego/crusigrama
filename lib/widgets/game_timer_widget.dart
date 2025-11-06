import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_stats.dart';
import '../providers.dart';
import '../utils.dart';

class GameTimerWidget extends ConsumerStatefulWidget {
  const GameTimerWidget({super.key});

  @override
  ConsumerState<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends ConsumerState<GameTimerWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (mounted) {
        setState(() {});
      }
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerNotifier = ref.watch(gameTimerProvider.notifier);
    final elapsed = timerNotifier.elapsed;
    final size = ref.watch(sizeProvider);
    final sizeKey = size.name;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5A3D8A).withOpacity(0.6),
            Color(0xFF3B2667).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFB794F6).withOpacity(0.4),
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
                colors: [Color(0xFFB794F6), Color(0xFF5A3D8A)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.schedule,
              color: Color(0xFFF2E9FE),
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
                  elapsed.formatted,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF2E9FE),
                    letterSpacing: 0.5,
                  ),
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final bestTimesAsync = ref.watch(bestTimesProvider);
                    return bestTimesAsync.when(
                      data: (times) {
                        final bestTime = times[sizeKey] ?? 0;
                        if (bestTime > 0) {
                          return Text(
                            '⭐ ${Duration(seconds: bestTime).formatted}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB8A3D4),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

