import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../providers.dart';
import 'crossword_puzzle_app.dart';

class MainMenuWidget extends ConsumerWidget {
  const MainMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(sizeProvider);
    final audioServiceAsync = ref.watch(audioServiceProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF3B2667),
              Color(0xFF2D1B4E),
              Color(0xFF1A0B2E),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              children: [
                // Logo/Título con diseño dramático
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5A3D8A),
                        Color(0xFF3B2667),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFD4A5FF).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
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
                              color: Color(0xFFD4A5FF).withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.grid_4x4,
                          size: 48,
                          color: Color(0xFF1A0B2E),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'CRUCIGRAMA',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF2E9FE),
                          letterSpacing: 6,
                          shadows: [
                            Shadow(
                              color: Color(0xFFD4A5FF).withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Desafía tu Mente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFB8A3D4),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Selección de tamaño con glassmorphism
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B2667).withOpacity(0.6),
                        Color(0xFF2D1B4E).withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Color(0xFFD4A5FF).withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF1A0B2E).withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
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
                            ),
                            child: Icon(
                              Icons.tune,
                              size: 20,
                              color: Color(0xFF1A0B2E),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'ELIGE TU DESAFÍO',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD4A5FF),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ...CrosswordSize.values.map((size) {
                        final isSelected = size == selectedSize;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              ref.read(sizeProvider.notifier).setSize(size);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFFD4A5FF).withOpacity(0.3),
                                          Color(0xFFB794F6).withOpacity(0.2),
                                        ],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Color(0xFFD4A5FF)
                                      : Color(0xFFD4A5FF).withOpacity(0.2),
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Color(0xFFD4A5FF).withOpacity(0.3),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                                            )
                                          : null,
                                      border: Border.all(
                                        color: isSelected
                                            ? Color(0xFFD4A5FF)
                                            : Color(0xFFB8A3D4).withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(Icons.check, size: 16, color: Color(0xFF1A0B2E))
                                        : null,
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    size.label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected
                                          ? Color(0xFFF2E9FE)
                                          : Color(0xFFB8A3D4),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Controles de audio con glassmorphism
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B2667).withOpacity(0.6),
                        Color(0xFF2D1B4E).withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Color(0xFFD4A5FF).withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF1A0B2E).withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: audioServiceAsync.when(
                    data: (_) {
                      final audioService = ref.read(audioServiceProvider.notifier);
                      return Column(
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
                                ),
                                child: Icon(
                                  Icons.volume_up,
                                  size: 20,
                                  color: Color(0xFF1A0B2E),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'CONFIGURACIÓN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD4A5FF),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _AudioToggle(
                            icon: audioService.isMusicEnabled ? Icons.music_note : Icons.music_off,
                            label: 'Música de Fondo',
                            isEnabled: audioService.isMusicEnabled,
                            onTap: () => audioService.toggleMusic(),
                          ),
                          SizedBox(height: 12),
                          _AudioToggle(
                            icon: audioService.isSFXEnabled ? Icons.volume_up : Icons.volume_off,
                            label: 'Efectos de Sonido',
                            isEnabled: audioService.isSFXEnabled,
                            onTap: () => audioService.toggleSFX(),
                          ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => Text(
                      'Error al cargar audio',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Botón de jugar dramático
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFD4A5FF).withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Invalidar los providers para regenerar el puzzle con el nuevo tamaño
                      ref.invalidate(workQueueProvider);
                      ref.invalidate(puzzleProvider);
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CrosswordPuzzleApp(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 32, color: Color(0xFF1A0B2E)),
                        SizedBox(width: 12),
                        Text(
                          'COMENZAR',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: Color(0xFF1A0B2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;
  final VoidCallback onTap;

  const _AudioToggle({
    required this.icon,
    required this.label,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    Color(0xFFD4A5FF).withOpacity(0.3),
                    Color(0xFFB794F6).withOpacity(0.2),
                  ],
                )
              : null,
          color: isEnabled ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEnabled
                ? Color(0xFFD4A5FF)
                : Color(0xFFD4A5FF).withOpacity(0.2),
            width: isEnabled ? 2.5 : 1.5,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Color(0xFFD4A5FF).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)])
                    : null,
                color: isEnabled ? null : Color(0xFF5A3D8A).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isEnabled ? Color(0xFF1A0B2E) : Color(0xFFB8A3D4).withOpacity(0.6),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isEnabled ? FontWeight.w700 : FontWeight.w500,
                  color: isEnabled ? Color(0xFFF2E9FE) : Color(0xFFB8A3D4),
                  letterSpacing: 1,
                ),
              ),
            ),
            Container(
              width: 54,
              height: 28,
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(
                        colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                      )
                    : null,
                color: isEnabled ? null : Color(0xFF5A3D8A).withOpacity(0.3),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: Color(0xFFD4A5FF).withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(3),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A0B2E),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

