import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/error/expections.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:fisrtflutterapp/core/network/network_info.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/models/number_trivia%20_model.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/repository_impl/number_trivia_repository_impl.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}

void main(){
  NumberTriviaRepositoryImpl repositoryImpl;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource:mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo:mockNetworkInfo
    );
  });

  void runTestOnline(Function body){
    group('device is online', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);
      });
      body();
    });
  }
  void runTestOffline(Function body){
    group('device is offline', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => false);
      });
      body();
    });
  }


  group('getConcreteNumberTrivia', (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test text", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online" , () async{
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);

      repositoryImpl.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline((){
      test('should return remote data when the call to remote data is sucsseful', ()async{
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => tNumberTriviaModel);

       final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

       verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
       expect(result, Right(tNumberTrivia));
      });

      test('should cache the  data locally when the call to remote data is successful', ()async{
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => tNumberTriviaModel);

       await repositoryImpl.getConcreteNumberTrivia(tNumber);

       verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
       verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });


      test('should return server failure when the call to remote data source is unsuccessful', ()async{
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestOffline((){
      test('should return last locally cached data when the cached data is present', () async{
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });


      test('should return CacheFailure when there is no cached data present', () async{
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });

      });





  group('getRandomNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(text: "test text", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if device is online" , () async{
      when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async => true);

      repositoryImpl.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline((){
      test('should return remote data when the call to remote data is successful', ()async{
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('should cache the  data locally when the call to remote data is successful', ()async{
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer ((realInvocation) async => tNumberTriviaModel);

        await repositoryImpl.getRandomNumberTrivia();

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });


      test('should return server failure when the call to remote data source is unsuccessful', ()async{
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestOffline((){
      test('should return last locally cached data when the cached data is present', () async{
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async => tNumberTriviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });


      test('should return CacheFailure when there is no cached data present', () async{
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });

  });

   
}
