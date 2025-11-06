import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../model.dart';
import '../providers.dart';

class CrosswordGeneratorWidget extends ConsumerWidget {
  const CrosswordGeneratorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: _buildCell,
      columnCount: size.width,
      columnBuilder: (index) => _buildSpan(context, index),
      rowCount: size.height,
      rowBuilder: (index) => _buildSpan(context, index),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Consumer(
        builder: (context, ref, _) {
          final character = ref.watch(
            workQueueProvider.select(
              (workQueueAsync) => workQueueAsync.when(
                data: (workQueue) => workQueue.crossword.characters[location],
                error: (error, stackTrace) => null,
                loading: () => null,
              ),
            ),
          );

          final explorationCell = ref.watch(
            workQueueProvider.select(
              (workQueueAsync) => workQueueAsync.when(
                data: (workQueue) =>
                    workQueue.locationsToTry.keys.contains(location),
                error: (error, stackTrace) => false,
                loading: () => false,
              ),
            ),
          );

          if (character != null) {
            return AnimatedContainer(
              duration: Durations.extralong1,
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: explorationCell
                    ? LinearGradient(
                        colors: [Color(0xFFD4A5FF), Color(0xFFB794F6)],
                      )
                    : null,
                color: explorationCell ? null : Color(0xFF3B2667),
                boxShadow: explorationCell
                    ? [
                        BoxShadow(
                          color: Color(0xFFD4A5FF).withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: Durations.extralong1,
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: explorationCell
                        ? Color(0xFF1A0B2E)
                        : Color(0xFFD4A5FF),
                  ),
                  child: Text('•'), // https://www.compart.com/en/unicode/U+2022
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
      extent: FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
            color: Color(0xFF5A3D8A).withOpacity(0.5),
          ),
          trailing: BorderSide(
            color: Color(0xFF5A3D8A).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

