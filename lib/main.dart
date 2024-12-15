import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RectanglePage(),
    );
  }
}

// Define state class for rectangle dimensions
class RectangleState {
  final double length;
  final double width;
  final double area;

  RectangleState({
    required this.length,
    required this.width,
    required this.area,
  });
}

// Define StateNotifier for rectangle calculations
final rectangleProvider = StateNotifierProvider<RectangleNotifier, RectangleState>((ref) => RectangleNotifier());

class RectangleNotifier extends StateNotifier<RectangleState> {
  RectangleNotifier() : super(RectangleState(length: 0, width: 0, area: 0));

  void calculateArea(double length, double width) {
    state = RectangleState(
      length: length,
      width: width,
      area: length * width,
    );
  }
}

class RectanglePage extends ConsumerStatefulWidget {
  const RectanglePage({super.key});

  @override
  ConsumerState<RectanglePage> createState() => _RectanglePageState();
}

class _RectanglePageState extends ConsumerState<RectanglePage> {
  final lengthController = TextEditingController();
  final widthController = TextEditingController();

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rectangleState = ref.watch(rectangleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rectangle Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: lengthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Length',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Width',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final length = double.tryParse(lengthController.text) ?? 0;
                final width = double.tryParse(widthController.text) ?? 0;
                ref.read(rectangleProvider.notifier).calculateArea(length, width);
              },
              child: const Text('Calculate Area'),
            ),
            const SizedBox(height: 24),
            Text(
              'Area: ${rectangleState.area}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}