import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../game_stats.dart';
import '../providers.dart';
import '../utils.dart';

class PuzzleCompletedWidget extends ConsumerStatefulWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  ConsumerState<PuzzleCompletedWidget> createState() =>
      _PuzzleCompletedWidgetState();
}

class _PuzzleCompletedWidgetState
    extends ConsumerState<PuzzleCompletedWidget> {
  bool _scoresSaved = false;

  @override
  void initState() {
    super.initState();
    // Stop the timer, play victory sound and save scores
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final timer = ref.read(gameTimerProvider.notifier);
      timer.stop();
      
      // Play victory sound
      await ref.read(audioServiceProvider.notifier).playVictorySound();
      
      await _saveScoresIfNeeded();
    });
  }

  Future<void> _saveScoresIfNeeded() async {
    if (_scoresSaved) return;
    
    final timer = ref.read(gameTimerProvider.notifier);
    final puzzle = ref.read(puzzleProvider);
    final size = ref.read(sizeProvider);
    final elapsed = timer.elapsed;
    
    final score = puzzle.calculateScore(elapsed);
    final sizeKey = size.name;

    await ref.read(highScoresProvider.notifier).saveScore(sizeKey, score);
    await ref.read(bestTimesProvider.notifier).saveTime(sizeKey, elapsed.inSeconds);
    
    setState(() {
      _scoresSaved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = ref.watch(puzzleProvider);
    final timerNotifier = ref.watch(gameTimerProvider.notifier);
    final elapsed = timerNotifier.elapsed;
    final score = puzzle.calculateScore(elapsed);
    final size = ref.watch(sizeProvider);
    final sizeKey = size.name;

    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        margin: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3B2667),
              Color(0xFF2D1B4E),
              Color(0xFF1A0B2E),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color(0xFFD4A5FF).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD4A5FF).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFD4A5FF),
                    Color(0xFFB794F6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD4A5FF).withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events,
                size: 56,
                color: Color(0xFF1A0B2E),
              ),
            ),
            SizedBox(height: 28),
            Text(
              '¡COMPLETADO!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Color(0xFFD4A5FF),
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Color(0xFFD4A5FF).withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            _StatRow(
              icon: Icons.score,
              label: 'Puntuación',
              value: '$score puntos',
              color: Color(0xFFD4A5FF),
            ),
            SizedBox(height: 16),
            _StatRow(
              icon: Icons.timer,
              label: 'Tiempo',
              value: elapsed.formatted,
              color: Color(0xFFB794F6),
            ),
            SizedBox(height: 16),
            _StatRow(
              icon: Icons.lightbulb,
              label: 'Pistas Usadas',
              value: '${puzzle.hintsUsed}',
              color: puzzle.hintsUsed > 0
                  ? Color(0xFFFFB3D9)
                  : Color(0xFFC9A9E9),
            ),
            SizedBox(height: 16),
            _StatRow(
              icon: Icons.grid_on,
              label: 'Palabras',
              value: '${puzzle.crossword.words.length}',
              color: Color(0xFFC9A9E9),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Consumer(
              builder: (context, ref, _) {
                final highScoresAsync = ref.watch(highScoresProvider);
                final bestTimesAsync = ref.watch(bestTimesProvider);

                return Column(
                  children: [
                    highScoresAsync.when(
                      data: (scores) {
                        final record = scores[sizeKey] ?? 0;
                        final isNewRecord = score > record;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isNewRecord)
                              Icon(Icons.stars, color: Colors.amber, size: 20),
                            if (isNewRecord) SizedBox(width: 8),
                            Text(
                              isNewRecord
                                  ? '¡Nuevo Récord de Puntuación!'
                                  : 'Récord: $record puntos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isNewRecord ? FontWeight.bold : FontWeight.normal,
                                color: isNewRecord
                                    ? Colors.amber
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    ),
                    SizedBox(height: 8),
                    bestTimesAsync.when(
                      data: (times) {
                        final bestTime = times[sizeKey] ?? 0;
                        final isNewRecord = bestTime == 0 || elapsed.inSeconds < bestTime;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isNewRecord)
                              Icon(Icons.speed, color: Colors.green, size: 20),
                            if (isNewRecord) SizedBox(width: 8),
                            Text(
                              bestTime > 0
                                  ? (isNewRecord
                                      ? '¡Nuevo Récord de Tiempo!'
                                      : 'Mejor Tiempo: ${Duration(seconds: bestTime).formatted}')
                                  : '¡Primer Récord!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isNewRecord ? FontWeight.bold : FontWeight.normal,
                                color: isNewRecord
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => SizedBox.shrink(),
                      error: (_, __) => SizedBox.shrink(),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF5A3D8A),
                          Color(0xFF3B2667),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFFD4A5FF).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Volver al menú principal
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: Icon(Icons.home, size: 22, color: Color(0xFFD4A5FF)),
                      label: Text(
                        'MENÚ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD4A5FF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD4A5FF).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Invalidar providers para regenerar el puzzle
                        ref.invalidate(workQueueProvider);
                        ref.invalidate(puzzleProvider);
                        ref.read(gameTimerProvider.notifier).reset();
                      },
                      icon: Icon(Icons.refresh, size: 22, color: Color(0xFF1A0B2E)),
                      label: Text(
                        'NUEVO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A0B2E),
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: Color(0xFF1A0B2E)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB8A3D4),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}


