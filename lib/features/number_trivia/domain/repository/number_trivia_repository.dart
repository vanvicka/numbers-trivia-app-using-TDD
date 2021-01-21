import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
abstract class NumberTriviaRepository {

 Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
 Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}