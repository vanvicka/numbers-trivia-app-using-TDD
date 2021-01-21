import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/error/expections.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:fisrtflutterapp/core/network/network_info.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/repository/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({this.localDataSource, this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number) async{
      return await _getTrivia(() =>  remoteDataSource.getConcreteNumberTrivia(number));

  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async{
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());

  }

  Future<Either<Failures, NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser getConcreteOrRandom) async{
    if(await networkInfo.isConnected ) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }else{
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}