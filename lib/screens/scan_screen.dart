import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:asset_tracker_app/screens/confirm_add_asset_screen.dart'; // Import the confirmation screen

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? scannedCode;
  bool _isProcessing = false; // To prevent multiple navigations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Asset'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && !_isProcessing) {
                  setState(() {
                    scannedCode = barcode.rawValue;
                    _isProcessing = true; // Prevent further processing until navigation is done
                  });
                  _processScannedCode(barcode.rawValue!);
                }
              }
            },
          ),
          if (scannedCode != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  'Scanned: $scannedCode',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _processScannedCode(String code) {
    if (code.startsWith('AST')) {
      final assetId = int.tryParse(code.substring(3));
      if (assetId != null) {
        Navigator.pop(context, assetId);
      } else {
        _showInvalidCodeMessage();
        setState(() => _isProcessing = false);
      }
    } else {
      // Assume the scanned code is in a format we can parse (e.g., JSON)
      try {
        final Map<String, dynamic> scannedAssetData = jsonDecode(code);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmAddAssetScreen(scannedData: scannedAssetData),
          ),
        ).then((_) => setState(() => _isProcessing = false)); // Reset processing flag after navigation
      } catch (e) {
        _showInvalidCodeMessage();
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showInvalidCodeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid QR code format')),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}