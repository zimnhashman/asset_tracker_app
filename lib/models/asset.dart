import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String serialNumber;
  final String? barcode;
  final DateTime? purchaseDate;
  final double? purchaseCost;
  final String status;
  final DateTime createdAt;

  const Asset({
    this.id,
    required this.name,
    this.description,
    required this.serialNumber,
    this.barcode,
    this.purchaseDate,
    this.purchaseCost,
    this.status = 'available',
    required this.createdAt,
  });

  // Add this copyWith method
  Asset copyWith({
    int? id,
    String? name,
    String? description,
    String? serialNumber,
    String? barcode,
    DateTime? purchaseDate,
    double? purchaseCost,
    String? status,
    DateTime? createdAt,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      serialNumber: serialNumber ?? this.serialNumber,
      barcode: barcode ?? this.barcode,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'serialNumber': serialNumber,
      'barcode': barcode,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'purchaseCost': purchaseCost,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      serialNumber: map['serialNumber'],
      barcode: map['barcode'],
      purchaseDate: map['purchaseDate'] != null
          ? DateTime.parse(map['purchaseDate'])
          : null,
      purchaseCost: map['purchaseCost'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    serialNumber,
    barcode,
    purchaseDate,
    purchaseCost,
    status,
    createdAt,
  ];
}