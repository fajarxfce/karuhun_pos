import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:karuhun_pos/core/error/failures.dart';
import '../repositories/product_registration_repository.dart';

class UploadImage {
  final ProductRegistrationRepository repository;

  UploadImage(this.repository);

  Future<Either<Failure, String>> call(File imageFile) async {
    return await repository.uploadImage(imageFile);
  }
}
