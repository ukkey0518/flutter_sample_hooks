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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Parent color'),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: kMinInteractiveDimension,
                    child: ColoredBox(
                      color: parentColor.value,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _SelectColorButtons(
                    onSelected: (newColor) {
                      debugPrint(
                        'Parent color selected: '
                        '${parentColor.value.value} → ${newColor.value}',
                      );
                      parentColor.value = newColor;
                    },
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
    // final color = useState(initialColor);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Child color'),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: kMinInteractiveDimension,
              child: ColoredBox(
                color: color.value,
              ),
            ),
            const SizedBox(width: 16),
            _SelectColorButtons(
              onSelected: (newColor) {
                debugPrint(
                  'Child color selected: '
                  '${color.value.value} → ${newColor.value}',
                );
                color.value = newColor;
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectColorButtons extends StatelessWidget {
  const _SelectColorButtons({
    required this.onSelected,
  });

  final void Function(Color color) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => onSelected(Colors.blue),
              child: const Text('Blue'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => onSelected(Colors.green),
              child: const Text('Green'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => onSelected(Colors.red),
              child: const Text('Red'),
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
