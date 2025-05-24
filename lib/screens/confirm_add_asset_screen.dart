import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asset_tracker_app/blocs/asset/asset_bloc.dart';
import 'package:asset_tracker_app/models/asset.dart';

class ConfirmAddAssetScreen extends StatefulWidget {
  final Map<String, dynamic> scannedData;

  const ConfirmAddAssetScreen({super.key, required this.scannedData});

  @override
  State<ConfirmAddAssetScreen> createState() => _ConfirmAddAssetScreenState();
}

class _ConfirmAddAssetScreenState extends State<ConfirmAddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _serialController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  DateTime? _purchaseDate;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with scanned data if available
    _nameController.text = widget.scannedData['name'] ?? '';
    _serialController.text = widget.scannedData['serialNumber'] ?? '';
    _descController.text = widget.scannedData['description'] ?? '';
    _costController.text = widget.scannedData['purchaseCost']?.toString() ?? '';
    if (widget.scannedData['purchaseDate'] != null) {
      _purchaseDate = DateTime.tryParse(widget.scannedData['purchaseDate']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
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
      appBar: AppBar(title: const Text('Confirm New Asset')),
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
                    context.read<AssetBloc>().add(AddAsset(asset));
                    Navigator.pop(context); // Go back to HomeScreen
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