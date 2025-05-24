// lib/blocs/asset/asset_event.dart
part of 'asset_bloc.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();

  @override
  List<Object> get props => [];
}

class LoadAssets extends AssetEvent {}

class AddAsset extends AssetEvent {
  final Asset asset;

  const AddAsset(this.asset);

  @override
  List<Object> get props => [asset];
}

class UpdateAsset extends AssetEvent {
  final Asset asset;

  const UpdateAsset(this.asset);

  @override
  List<Object> get props => [asset];
}

class DeleteAsset extends AssetEvent {
  final int assetId;

  const DeleteAsset(this.assetId);

  @override
  List<Object> get props => [assetId];
}