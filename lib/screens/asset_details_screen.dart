import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:asset_tracker_app/blocs/asset/asset_bloc.dart';
import 'package:asset_tracker_app/widgets/barcode_preview.dart';
import 'package:asset_tracker_app/models/asset.dart';

class AssetDetailsScreen extends StatelessWidget {
  final int assetId;

  const AssetDetailsScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset Details')),
      body: BlocBuilder<AssetBloc, AssetState>(
        builder: (context, state) {
          if (state is AssetLoadSuccess) {
            final asset = state.assets.firstWhere(
                  (a) => a.id == assetId,
              orElse: () => throw Exception('Asset not found'),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  Text('Serial Number: ${asset.serialNumber}'),
                  Text('Status: ${asset.status}'),
                  if (asset.description != null)
                    Text('Description: ${asset.description}'),
                  if (asset.purchaseCost != null)
                    Text('Cost: \$${asset.purchaseCost!.toStringAsFixed(2)}'),
                  if (asset.purchaseDate != null)
                    Text('Purchase Date: ${asset.purchaseDate!.toLocal()}'.split(' ')[0]),
                  const SizedBox(height: 32),
                  BarcodePreview(
                    barcodeData: asset.barcode ?? 'AST${asset.id.toString().padLeft(6, '0')}',
                    assetName: asset.name,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _deleteAsset(context, asset.id!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete Asset'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _deleteAsset(BuildContext context, int assetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: const Text('Are you sure you want to delete this asset?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AssetBloc>().add(DeleteAsset(assetId));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}