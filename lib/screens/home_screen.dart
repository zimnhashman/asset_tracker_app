// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asset_tracker_app/blocs/asset/asset_bloc.dart';
import 'package:asset_tracker_app/screens/add_asset_screen.dart';
import 'package:asset_tracker_app/screens/scan_screen.dart';
import 'package:asset_tracker_app/widgets/asset_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanScreen()),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AssetBloc, AssetState>(
        builder: (context, state) {
          if (state is AssetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AssetLoadSuccess) {
            return ListView.builder(
              itemCount: state.assets.length,
              itemBuilder: (context, index) => AssetCard(
                key: ValueKey<int>(state.assets[index].id!),
                asset: state.assets[index],
              ),
            );
          } else if (state is AssetLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No assets found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddAssetScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}