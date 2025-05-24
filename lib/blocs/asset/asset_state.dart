// lib/blocs/asset/asset_state.dart
part of 'asset_bloc.dart';

abstract class AssetState extends Equatable {
  const AssetState();

  @override
  List<Object> get props => [];
}

class AssetInitial extends AssetState {}

class AssetLoading extends AssetState {}

class AssetLoadSuccess extends AssetState {
  final List<Asset> assets;

  const AssetLoadSuccess(this.assets);

  @override
  List<Object> get props => [assets];
}

class AssetOperationSuccess extends AssetState {}

class AssetLoadFailure extends AssetState {
  final String error;

  const AssetLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AssetOperationFailure extends AssetState {
  final String error;

  const AssetOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}