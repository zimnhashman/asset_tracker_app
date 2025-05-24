import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarcodePreview extends StatelessWidget {
  final String barcodeData;
  final String assetName;

  const BarcodePreview({
    super.key,
    required this.barcodeData,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(assetName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            BarcodeWidget(
              barcode: Barcode.code128(),
              data: barcodeData,
              width: 250,
              height: 80,
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: barcodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 16),
            Text(barcodeData),
          ],
        ),
      ),
    );
  }
}