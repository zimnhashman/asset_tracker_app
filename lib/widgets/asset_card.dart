// lib/widgets/asset_card.dart
import 'package:flutter/material.dart';
import 'package:asset_tracker_app/models/asset.dart';

import '../screens/asset_details_screen.dart' show AssetDetailsScreen;

class AssetCard extends StatelessWidget {
  final Asset asset;

  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetDetailsScreen(assetId: asset.id!),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asset.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Serial: ${asset.serialNumber}'),
              Text('Status: ${asset.status}'),
              if (asset.barcode != null) Text('Barcode: ${asset.barcode}'),
            ],
          ),
        ),
      ),
    );
  }
}