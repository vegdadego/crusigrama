import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../providers.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';

class CrosswordPuzzleApp extends ConsumerStatefulWidget {
  const CrosswordPuzzleApp({super.key});

  @override
  ConsumerState<CrosswordPuzzleApp> createState() => _CrosswordPuzzleAppState();
}

class _CrosswordPuzzleAppState extends ConsumerState<CrosswordPuzzleApp> {
  @override
  void initState() {
    super.initState();
    // Initialize audio and start background music (non-blocking)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider.future).then((_) {
        ref.read(audioServiceProvider.notifier).playBackgroundMusic();
      }).catchError((e) {
        debugPrint('Error initializing audio: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFD4A5FF)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'CRUCIGRAMA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4A5FF),
              letterSpacing: 3,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D1B4E), Color(0xFF3B2667)],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                Color(0xFF2D1B4E),
                Color(0xFF1A0B2E),
              ],
            ),
          ),
          child: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzleSolved = ref.watch(
                puzzleProvider.select((puzzle) => puzzle.solved),
              );

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty) {
                    final puzzle = ref.watch(puzzleProvider);
                    // Show loading while puzzle is being created in isolate
                    if (puzzle.crossword.words.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A5FF)),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Preparando Puzzle...',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD4A5FF),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Generando palabras alternativas',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFB8A3D4),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return CrosswordPuzzleWidget();
                  }
                  return CrosswordGeneratorWidget();
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A5FF)),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Error: $error',
                    style: TextStyle(color: Color(0xFFFFB3D9)),
                  ),
                ),
              );
            },
          ),
        ),
          ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}
