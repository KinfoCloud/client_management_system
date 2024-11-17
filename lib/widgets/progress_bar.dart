import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final List<String> steps;
  final int currentStep;

  const ProgressBar({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isCompact = constraints.maxWidth < 600;
        final double dotSize = isCompact ? 24 : 40;
        final double fontSize = isCompact ? 10 : 12;
        final double lineHeight = isCompact ? 3 : 5;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              // Progress Dots and Lines
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(steps.length * 2 - 1, (index) {
                  if (index.isEven) {
                    // Progress Dot
                    return SizedBox(
                      width: dotSize,
                      child: _buildProgressDot(context, index ~/ 2, dotSize),
                    );
                  } else {
                    // Progress Line
                    return Expanded(
                      child:
                          _buildProgressLine(context, index ~/ 2, lineHeight),
                    );
                  }
                }),
              ),

              const SizedBox(height: 8),

              // Step Titles (Text Below Dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: steps.asMap().entries.map((entry) {
                  return Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: entry.key <= currentStep
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis, // Prevents wrapping
                        maxLines: 1, // Ensures only one line
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressDot(BuildContext context, int index, double size) {
    bool isCompleted = index < currentStep;
    bool isCurrent = index == currentStep;
    bool isActive = isCompleted || isCurrent;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? Colors.green
            : (isCurrent ? Theme.of(context).primaryColor : Colors.grey[300]),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.grey,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: size * 0.5)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: size * 0.4,
                  color: isCurrent ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildProgressLine(BuildContext context, int index, double height) {
    bool isCompleted = index < currentStep;
    return Container(
      height: height,
      color: isCompleted ? Colors.green : Colors.grey[300],
    );
  }
}
