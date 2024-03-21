import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Parent build()');
    final parentColor = useState<Color>(Colors.blue);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  _SelectColorsButtons(
                    label: 'Parent color',
                    onSelected: (newColor) {
                      debugPrint(
                        'Parent color selected: '
                        '${parentColor.value.value} → ${newColor.value}',
                      );
                      parentColor.value = newColor;
                    },
                  ),
                  const Spacer(),
                  SizedBox.square(
                    dimension: kMinInteractiveDimension,
                    child: ColoredBox(
                      color: parentColor.value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ChildWidget(
                initialColor: parentColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildWidget extends HookWidget {
  const _ChildWidget({
    required this.initialColor,
  });

  final Color initialColor;

  @override
  Widget build(BuildContext context) {
    debugPrint('Child build()');
    final color = useEffectiveState(initialColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SelectColorsButtons(
          label: 'Child color',
          onSelected: (newColor) {
            debugPrint(
              'Child color selected: '
              '${color.value.value} → ${newColor.value}',
            );
            color.value = newColor;
          },
        ),
        const Spacer(),
        SizedBox.square(
          dimension: kMinInteractiveDimension,
          child: ColoredBox(
            color: color.value,
          ),
        ),
      ],
    );
  }
}

class _SelectColorsButtons extends StatelessWidget {
  const _SelectColorsButtons({
    required this.label,
    required this.onSelected,
  });

  final String label;
  final void Function(Color color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => onSelected(Colors.blue),
              child: const Text('Blue'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => onSelected(Colors.green),
              child: const Text('Green'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              onPressed: () => onSelected(Colors.yellow),
              child: const Text('Yellow'),
            ),
          ],
        ),
      ],
    );
  }
}

ValueNotifier<T> useEffectiveState<T>(T initialData) {
  final state = useState(initialData);
  useEffect(
    () {
      if (state.value != initialData) {
        state.value = initialData;
      }
      return null;
    },
    [initialData],
  );
  return state;
}
