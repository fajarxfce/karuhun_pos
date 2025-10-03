import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProductRegistrationEvent extends Equatable {
  const ProductRegistrationEvent();

  @override
  List<Object?> get props => [];
}

// Form field events
class NameChanged extends ProductRegistrationEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends ProductRegistrationEvent {
  final String description;

  const DescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
}

class BarcodeChanged extends ProductRegistrationEvent {
  final String barcode;

  const BarcodeChanged(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class PriceChanged extends ProductRegistrationEvent {
  final String price;

  const PriceChanged(this.price);

  @override
  List<Object> get props => [price];
}

class WeightChanged extends ProductRegistrationEvent {
  final String weight;

  const WeightChanged(this.weight);

  @override
  List<Object> get props => [weight];
}

class UnitChanged extends ProductRegistrationEvent {
  final String unit;

  const UnitChanged(this.unit);

  @override
  List<Object> get props => [unit];
}

class ExpiryDateChanged extends ProductRegistrationEvent {
  final DateTime? expiryDate;

  const ExpiryDateChanged(this.expiryDate);

  @override
  List<Object?> get props => [expiryDate];
}

// Dropdown events with reactive behavior
class LoadCategories extends ProductRegistrationEvent {
  const LoadCategories();
}

class CategorySelected extends ProductRegistrationEvent {
  final String categoryId;

  const CategorySelected(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class LoadSuppliers extends ProductRegistrationEvent {
  final String categoryId;

  const LoadSuppliers(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SupplierSelected extends ProductRegistrationEvent {
  final String supplierId;

  const SupplierSelected(this.supplierId);

  @override
  List<Object> get props => [supplierId];
}

// Image upload events
class ImageSelected extends ProductRegistrationEvent {
  final File imageFile;

  const ImageSelected(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class ImageRemoved extends ProductRegistrationEvent {
  final int index;

  const ImageRemoved(this.index);

  @override
  List<Object> get props => [index];
}

class ImageUploaded extends ProductRegistrationEvent {
  final String imageUrl;

  const ImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

// Form validation and submission
class ValidateForm extends ProductRegistrationEvent {
  const ValidateForm();
}

class SubmitForm extends ProductRegistrationEvent {
  const SubmitForm();
}

class ResetForm extends ProductRegistrationEvent {
  const ResetForm();
}
