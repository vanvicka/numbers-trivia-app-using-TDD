import 'package:equatable/equatable.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params>{
  Future <Either<Failures,Type>> call(Params params);
}

class NoParams extends Equatable{}