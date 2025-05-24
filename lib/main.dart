import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asset_tracker_app/blocs/asset/asset_bloc.dart';
import 'package:asset_tracker_app/database/database_helper.dart';
import 'package:asset_tracker_app/repositories/asset_repository.dart';
import 'package:asset_tracker_app/screens/home_screen.dart';
import 'package:asset_tracker_app/screens/add_asset_screen.dart';
import 'package:asset_tracker_app/screens/scan_screen.dart';
import 'package:asset_tracker_app/screens/asset_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  final assetRepository = AssetRepository(dbHelper: dbHelper);

  runApp(MyApp(assetRepository: assetRepository));
}

class MyApp extends StatelessWidget {
  final AssetRepository assetRepository;

  const MyApp({super.key, required this.assetRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssetBloc(assetRepository: assetRepository)
        ..add(LoadAssets()),
      child: MaterialApp(
        title: 'Asset Tracking',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        routes: {
          '/add-asset': (context) => BlocProvider.value(
            value: BlocProvider.of<AssetBloc>(context),
            child: const AddAssetScreen(),
          ),
          '/scan': (context) => BlocProvider.value(
            value: BlocProvider.of<AssetBloc>(context),
            child: const ScanScreen(),
          ),
          '/asset-details': (context) => BlocProvider.value(
            value: BlocProvider.of<AssetBloc>(context),
            child: AssetDetailsScreen(
              assetId: ModalRoute.of(context)!.settings.arguments as int,
            ),
          ),
        },
      ),
    );
  }
}