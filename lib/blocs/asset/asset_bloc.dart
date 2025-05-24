// lib/blocs/asset/asset_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:asset_tracker_app/models/asset.dart';
import 'package:asset_tracker_app/repositories/asset_repository.dart';

part 'asset_event.dart';
part 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository assetRepository;

  AssetBloc({required this.assetRepository}) : super(AssetInitial()) {

    on<LoadAssets>((event, emit) async {
    emit(AssetLoading());
    try {
    final assets = await assetRepository.getAllAssets();
    emit(AssetLoadSuccess(assets));
    } catch (e) {
    emit(AssetLoadFailure(error: e.toString()));
    }
    });

    on<AddAsset>((event, emit) async {
    try {
    // Show loading state
    emit(AssetLoading());

    // Create asset and get its ID
    final newAssetId = await assetRepository.createAsset(event.asset);

    // Get updated list from database
    final assets = await assetRepository.getAllAssets();
    emit(AssetLoadSuccess(assets));
    } catch (e) {
    emit(AssetOperationFailure(error: e.toString()));
    }
    });
    on<UpdateAsset>((event, emit) async {
      try {
        await assetRepository.updateAsset(event.asset);
        final assets = await assetRepository.getAllAssets();
        emit(AssetLoadSuccess(assets));
      } catch (e) {
        emit(AssetOperationFailure(error: e.toString()));
      }
    });

    on<DeleteAsset>((event, emit) async {
      try {
        await assetRepository.deleteAsset(event.assetId);
        final assets = await assetRepository.getAllAssets();
        emit(AssetLoadSuccess(assets));
      } catch (e) {
        emit(AssetOperationFailure(error: e.toString()));
      }
    });
  }
}