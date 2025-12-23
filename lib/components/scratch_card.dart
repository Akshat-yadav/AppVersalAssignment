import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCard extends StatefulWidget {
  final VoidCallback onClose;

  const ScratchCard({super.key, required this.onClose});

  @override
  State<ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<ScratchCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScratcherState> _scratcherKey = GlobalKey<ScratcherState>();
  bool isScratched = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _handleClose() {
    setState(() {
      isScratched = false;
    });
    widget.onClose();
  }

  void _showBottomOverlaySheet() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        _controller.forward(); // Start animation
        return Material(
          color: Colors.black87, // opaque background
          child: GestureDetector(
            onTap: () {
              _controller.reverse().then((value) => entry.remove());
            },
            child: Stack(
              children: [
                // Tap outside to dismiss
                Container(color: Colors.transparent),
                // Bottom sheet
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: GestureDetector(
                      onTap: () {}, // absorb taps inside
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: const Text(
                            "Eligibility:\n"
                            "Only users who meet the campaign criteria are eligible.\n\n"
                            "Non-Transferable & One-Time Use:\n"
                            "Each scratch code/reward is unique and valid for a single use.\n\n"
                            "Fraud Prevention:\n"
                            "Misuse or duplication will result in disqualification.\n\n"
                            "Validity & Expiry:\n"
                            "All scratch cards/codes must be redeemed within the specified validity period.",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Close button
        GestureDetector(
          onTap: _handleClose,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ),

        // Scratch Card
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Reward content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.asset(
                        'assets/image/cashback.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      "Offer from AppStorys",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cashback on mobile and recharge',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow, width: 4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Text(
                        "A1B2C3D4E5F",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scratch layer
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Scratcher(
                  key: _scratcherKey,
                  brushSize: 40,
                  threshold: 35,
                  image: Image.asset(
                    'assets/image/scratch.png',
                    fit: BoxFit.cover,
                  ),
                  onThreshold: () {
                    _scratcherKey.currentState?.reveal();
                    setState(() {
                      isScratched = true;
                    });
                  },
                  child: Container(),
                ),
              ),
            ],
          ),
        ),

        // Buttons only after scratch
        if (isScratched) ...[
          const SizedBox(height: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: const Text(
                  "Claim offer now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showBottomOverlaySheet,
                child: const Text(
                  "Terms & Conditions*",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    isScratched = false;
    super.dispose();
  }
}
