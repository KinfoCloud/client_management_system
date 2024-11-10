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
        final EdgeInsets padding = isCompact
            ? const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0)
            : const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0);

        return Container(
          width: double.infinity,
          padding: padding,
          child: Column(
            children: [
              Row(
                children: List.generate(steps.length * 2 - 1, (index) {
                  if (index.isEven) {
                    return _buildProgressDot(
                        context, index ~/ 2, dotSize, fontSize);
                  } else {
                    return Expanded(
                        child: _buildProgressLine(
                            context, index ~/ 2, lineHeight));
                  }
                }),
              ),
              if (!isCompact) const SizedBox(height: 16),
              if (!isCompact)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: steps.asMap().entries.map((entry) {
                    return Expanded(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: entry.key <= currentStep
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          fontSize: fontSize,
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

  Widget _buildProgressDot(
      BuildContext context, int index, double size, double fontSize) {
    bool isCompleted = index < currentStep;
    bool isCurrent = index == currentStep;
    bool isActive = isCompleted || isCurrent;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : (isCurrent
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]),
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: size * 0.5)
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
          ),
        ),
      ],
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
