import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str){
    
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    }on FormatException {
      return left(InvalidInputFailure());
    }
        
  }
}

class InvalidInputFailure extends Failures{}