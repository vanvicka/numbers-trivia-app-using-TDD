import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:fisrtflutterapp/core/usecases/usecase.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/repository/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  Future <Either<Failures,NumberTrivia>> call(NoParams params) async{
    return await repository.getRandomNumberTrivia();
  }
}

