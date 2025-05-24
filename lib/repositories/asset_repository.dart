// lib/repositories/asset_repository.dart
import 'package:asset_tracker_app/database/database_helper.dart';
import 'package:asset_tracker_app/models/asset.dart';

class AssetRepository {
  final DatabaseHelper dbHelper;

  AssetRepository({required this.dbHelper});

  Future<int> createAsset(Asset asset) async {
    final db = await dbHelper.database;
    final id = await db.insert('assets', asset.toMap());
    print('Asset created with ID: $id'); // Add this
    return id;
  }

  Future<List<Asset>> getAllAssets() async {
    final db = await dbHelper.database;
    final result = await db.query('assets');
    print('Retrieved ${result.length} assets: $result'); // Add this
    return result.map((e) => Asset.fromMap(e)).toList();
  }

  Future<Asset?> getAssetById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Asset.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateAsset(Asset asset) async {
    final db = await dbHelper.database;
    return await db.update(
      'assets',
      asset.toMap(),
      where: 'id = ?',
      whereArgs: [asset.id],
    );
  }

  Future<int> deleteAsset(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'assets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String> generateBarcode(int assetId) async {
    return 'AST${assetId.toString().padLeft(6, '0')}';
  }
}