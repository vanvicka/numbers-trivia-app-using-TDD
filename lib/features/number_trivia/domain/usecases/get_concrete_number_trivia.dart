import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:fisrtflutterapp/core/usecases/usecase.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  Future <Either<Failures,NumberTrivia>> call(Params params) async{
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;
  Params({this .number}):super([number]);
}