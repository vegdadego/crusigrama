import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../audio_service.dart';
import '../crossword_input_state.dart';
import '../game_stats.dart';
import '../model.dart';
import '../providers.dart';
import 'game_timer_widget.dart';
import 'hint_system_widget.dart';

class CrosswordPuzzleWidget extends ConsumerStatefulWidget {
  const CrosswordPuzzleWidget({super.key});

  @override
  ConsumerState<CrosswordPuzzleWidget> createState() => _CrosswordPuzzleWidgetState();
}

class _CrosswordPuzzleWidgetState extends ConsumerState<CrosswordPuzzleWidget> {
  @override
  void initState() {
    super.initState();
    // Iniciar timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timer = ref.read(gameTimerProvider.notifier);
      if (!timer.isRunning) {
        timer.start();
      }
    });
  }

  void _submitWord(Location location, String word, Direction direction) {
    final puzzleNotifier = ref.read(puzzleProvider.notifier);
    final audioService = ref.read(audioServiceProvider.notifier);
    
    puzzleNotifier.selectWord(
      location: location,
      word: word,
      direction: direction,
    );
    
    audioService.playSelectionSound();
  }

  void _showHintDialog() {
    final inputState = ref.read(crosswordInputProvider);
    if (inputState.selectedCell == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una celda primero'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final puzzle = ref.read(puzzleProvider);
    final character = puzzle.crossword.characters[inputState.selectedCell!];
    if (character == null) return;

    final acrossWord = character.acrossWord;
    final downWord = character.downWord;
    
    if (acrossWord == null && downWord == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D1B4E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Color(0xFFD4A5FF).withOpacity(0.5),
            width: 2,
          ),
        ),
        title: Text(
          'REVELAR PALABRA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: Color(0xFFD4A5FF),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (acrossWord != null)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(puzzleProvider.notifier).revealWordHint(
                    location: acrossWord.location,
                    direction: Direction.across,
                  );
                  ref.read(audioServiceProvider.notifier).playHintSound();
                },
                child: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD4A5FF).withOpacity(0.2),
                        Color(0xFFB794F6).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Color(0xFFD4A5FF).withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF1A0B2E),
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Horizontal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF2E9FE),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${acrossWord.word.length} letras • -50 pts',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFFFB3D9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (acrossWord != null && downWord != null)
              SizedBox(height: 12),
            if (downWord != null)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(puzzleProvider.notifier).revealWordHint(
                    location: downWord.location,
                    direction: Direction.down,
                  );
                  ref.read(audioServiceProvider.notifier).playHintSound();
                },
                child: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD4A5FF).withOpacity(0.2),
                        Color(0xFFB794F6).withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Color(0xFFD4A5FF).withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_downward,
                          color: Color(0xFF1A0B2E),
                          size: 22,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vertical',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF2E9FE),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${downWord.word.length} letras • -50 pts',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFFFB3D9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFD4A5FF),
            ),
            child: Text(
              'CANCELAR',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInputDialog() {
    final inputState = ref.read(crosswordInputProvider);
    if (inputState.selectedCell == null) return;

    final puzzle = ref.read(puzzleProvider);
    final character = puzzle.crossword.characters[inputState.selectedCell!];
    if (character == null) return;

    final currentWord = inputState.direction == Direction.across
        ? character.acrossWord
        : character.downWord;

    if (currentWord == null) return;

    final textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D1B4E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Color(0xFFD4A5FF).withOpacity(0.5),
            width: 2,
          ),
        ),
        title: Text(
          'Ingresar Palabra',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFD4A5FF),
            letterSpacing: 1,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${currentWord.word.length} letras',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFB8A3D4),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              autofocus: true,
              maxLength: currentWord.word.length,
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(
                color: Color(0xFFF2E9FE),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                hintStyle: TextStyle(color: Color(0xFFB8A3D4).withOpacity(0.5)),
                counterText: '',
                filled: true,
                fillColor: Color(0xFF3B2667),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFFD4A5FF), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFFD4A5FF), width: 2.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xFFB794F6).withOpacity(0.4), width: 1.5),
                ),
              ),
              onSubmitted: (value) {
                if (value.length == currentWord.word.length) {
                  Navigator.pop(context);
                  _submitWord(currentWord.location, value.toLowerCase(), currentWord.direction);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFB8A3D4),
            ),
            child: Text(
              'CANCELAR',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FilledButton(
              onPressed: () {
                final text = textController.text.toLowerCase();
                if (text.length == currentWord.word.length) {
                  Navigator.pop(context);
                  _submitWord(currentWord.location, text, currentWord.direction);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'ENVIAR',
                style: TextStyle(
                  color: Color(0xFF1A0B2E),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = ref.watch(sizeProvider);

    return Column(
      children: [
        // Barra superior con stats
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2D1B4E), Color(0xFF3B2667)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1A0B2E).withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(child: HintSystemWidget()),
              SizedBox(width: 12),
              const Expanded(child: GameTimerWidget()),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // TableView debe recibir toques primero
              Positioned.fill(
                child: TableView.builder(
                  diagonalDragBehavior: DiagonalDragBehavior.free,
                  cellBuilder: _buildCell,
                  columnCount: size.width,
                  columnBuilder: (index) => _buildSpan(context, index),
                  rowCount: size.height,
                  rowBuilder: (index) => _buildSpan(context, index),
                ),
              ),
              // Botones flotantes que no bloquean el resto
              Positioned(
                bottom: 100,
                right: 16,
                child: IgnorePointer(
                  ignoring: false,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showHintDialog,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFB3D9), Color(0xFFC9A9E9)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFB3D9).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: Color(0xFF1A0B2E),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Botón para escribir (móvil) con diseño dramático
              Positioned(
                bottom: 16,
                right: 16,
                child: Consumer(
                  builder: (context, ref, _) {
                    final inputState = ref.watch(crosswordInputProvider);
                    if (inputState.selectedCell == null) return const SizedBox.shrink();
                    
                    return IgnorePointer(
                      ignoring: false,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showInputDialog,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFD4A5FF).withOpacity(0.6),
                                  blurRadius: 25,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.keyboard,
                              color: Color(0xFF1A0B2E),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Widget de pistas en la parte inferior
        Consumer(
          builder: (context, ref, _) {
            final inputState = ref.watch(crosswordInputProvider);
            if (inputState.selectedCell == null) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2D1B4E), Color(0xFF1A0B2E)],
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF5A3D8A).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Selecciona una casilla para ver la pista',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFB8A3D4),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final puzzle = ref.watch(puzzleProvider);
            final character = puzzle.crossword.characters[inputState.selectedCell!];
            
            if (character == null) {
              return const SizedBox.shrink();
            }

            final currentWord = inputState.direction == Direction.across
                ? character.acrossWord
                : character.downWord;

            if (currentWord == null) {
              return const SizedBox.shrink();
            }

            final hint = currentWord.hint ?? 'Sin pista disponible';
            final directionText = inputState.direction == Direction.across ? 'Horizontal' : 'Vertical';
            
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2D1B4E), Color(0xFF3B2667)],
                ),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD4A5FF).withOpacity(0.4),
                    width: 2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1A0B2E).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFD4A5FF).withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          inputState.direction == Direction.across
                              ? Icons.arrow_forward
                              : Icons.arrow_downward,
                          size: 18,
                          color: Color(0xFF1A0B2E),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$directionText',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD4A5FF),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4A5FF).withOpacity(0.2),
                              Color(0xFFB794F6).withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Color(0xFFD4A5FF).withOpacity(0.5),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${currentWord.word.length} letras',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB8A3D4),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hint,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF2E9FE),
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Consumer(
        builder: (context, ref, _) {
          final character = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.crossword.characters[location],
            ),
          );
          
          final selectedCharacter = ref.watch(
            puzzleProvider.select(
              (puzzle) =>
                  puzzle.crosswordFromSelectedWords.characters[location],
            ),
          );
          
          final isRevealed = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.revealedLocations.contains(location),
            ),
          );

          final inputState = ref.watch(crosswordInputProvider);
          final isSelected = inputState.selectedCell == location;

          if (character != null) {
            // Determinar qué carácter mostrar
            String displayChar = '';
            if (isRevealed) {
              displayChar = character.character;
            } else {
              displayChar = selectedCharacter?.character ?? '';
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final inputNotifier = ref.read(crosswordInputProvider.notifier);
                final inputState = ref.read(crosswordInputProvider);
                
                if (isSelected) {
                  // Si ya está seleccionada, cambiar dirección
                  // Pero solo si hay palabra en la otra dirección
                  final currentDir = inputState.direction;
                  final otherDir = currentDir == Direction.across ? Direction.down : Direction.across;
                  final hasOtherDirection = otherDir == Direction.across 
                      ? character.acrossWord != null 
                      : character.downWord != null;
                  
                  if (hasOtherDirection) {
                    inputNotifier.toggleDirection();
                  }
                } else {
                  // Seleccionar esta celda con la dirección correcta
                  // Si solo hay una dirección disponible, usar esa
                  Direction? preferredDirection;
                  
                  if (character.acrossWord == null && character.downWord != null) {
                    // Solo tiene vertical
                    preferredDirection = Direction.down;
                  } else if (character.downWord == null && character.acrossWord != null) {
                    // Solo tiene horizontal
                    preferredDirection = Direction.across;
                  }
                  // Si tiene ambas, usar la dirección actual del estado
                  
                  inputNotifier.selectCell(location, preferredDirection: preferredDirection);
                }
              },
              child: AnimatedContainer(
                duration: Durations.medium1,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: isRevealed
                      ? LinearGradient(
                          colors: [Color(0xFFFFB3D9).withOpacity(0.3), Color(0xFFC9A9E9).withOpacity(0.3)],
                        )
                      : isSelected
                          ? LinearGradient(
                              colors: [Color(0xFFD4A5FF).withOpacity(0.4), Color(0xFFB794F6).withOpacity(0.3)],
                            )
                          : null,
                  color: isRevealed || isSelected ? null : Color(0xFF3B2667),
                  border: isSelected
                      ? Border.all(
                          color: Color(0xFFD4A5FF),
                          width: 3,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xFFD4A5FF).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Durations.medium1,
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 24,
                      color: isRevealed
                          ? Color(0xFFFFB3D9)
                          : isSelected
                              ? Color(0xFFF2E9FE)
                              : Color(0xFFD4A5FF),
                      fontWeight: isRevealed || isSelected
                          ? FontWeight.w900
                          : FontWeight.w700,
                      shadows: isSelected
                          ? [
                              Shadow(
                                color: Color(0xFFD4A5FF).withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(displayChar.toUpperCase()),
                  ),
                ),
              ),
            );
          }

          return ColoredBox(
            color: Color(0xFF1A0B2E),
          );
        },
      ),
    );
  }

  TableSpan _buildSpan(BuildContext context, int index) {
    return TableSpan(
      extent: const FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
            color: Color(0xFF5A3D8A).withOpacity(0.5),
            width: 1.5,
          ),
          trailing: BorderSide(
            color: Color(0xFF5A3D8A).withOpacity(0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

