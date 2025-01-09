import 'package:flutter/material.dart';

class NumberInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const NumberInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onChanged(value > 1 ? value - 1 : 1),
            ),
            Text('$value', style: const TextStyle(fontSize: 18)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class DurationInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const DurationInput({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onChanged(value > 10 ? value - 10 : 10),
            ),
            Text('$value s', style: const TextStyle(fontSize: 18)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 10),
            ),
          ],
        ),
      ],
    );
  }
}
