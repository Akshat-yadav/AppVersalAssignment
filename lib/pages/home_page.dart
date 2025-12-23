import 'package:appversal/components/scratch_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OverlayEntry? _overlayEntry;

  void _showScratchOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: ScratchCard(
            onClose: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppVersal Assignment')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showScratchOverlay,
          child: const Text('Show Scratch Card'),
        ),
      ),
    );
  }
}
