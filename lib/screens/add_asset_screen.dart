// lib/screens/add_asset_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asset_tracker_app/blocs/asset/asset_bloc.dart';
import 'package:asset_tracker_app/models/asset.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serialController = TextEditingController();
  final _descController = TextEditingController();
  final _costController = TextEditingController();
  DateTime? _purchaseDate;

  @override
  void dispose() {
    _nameController.dispose();
    _serialController.dispose();
    _descController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Asset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Asset Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter asset name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serialController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter serial number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(labelText: 'Purchase Cost'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _purchaseDate == null
                        ? 'No date selected'
                        : 'Date: ${_purchaseDate!.toLocal()}'.split(' ')[0],
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Purchase Date'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final asset = Asset(
                      name: _nameController.text,
                      serialNumber: _serialController.text,
                      description: _descController.text,
                      purchaseCost: double.tryParse(_costController.text),
                      purchaseDate: _purchaseDate,
                      createdAt: DateTime.now(),
                    );

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Add asset
                    context.read<AssetBloc>().add(AddAsset(asset));

                    // Close dialogs and return
                    Navigator.pop(context); // Close loading
                    Navigator.pop(context); // Return to home
                  }
                },
                child: const Text('Save Asset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}