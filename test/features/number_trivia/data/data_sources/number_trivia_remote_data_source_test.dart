import 'dart:convert';

import 'package:fisrtflutterapp/core/error/expections.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/models/number_trivia%20_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client{}

void main(){
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  
  setUp((){
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  void setUpMockHttpSuccess200(){
    when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));

  }
  void setUpMockHttpSuccess404(){
    when(mockHttpClient.get(any,headers: anyNamed('headers'))).thenAnswer((realInvocation) async => http.Response('something went wrong', 404));

  }

  group('getConcreteNumberTrivia', (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json'),));
    test('''should perform a GET request on a URL with 
    number being the endpoint with application/json header''',
            () async {
      setUpMockHttpSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {'Content-Type': 'application/json'}));


            });
    test('should return NumberTrivia when response code is 200 (success)',
            () async{
              setUpMockHttpSuccess200();

              final result = await dataSource.getConcreteNumberTrivia(tNumber);
              
              expect(result, tNumberTriviaModel);
            });
    test('should throw a ServerException when the response code is 404 or other',
            (){
              setUpMockHttpSuccess404();

              final call = dataSource.getConcreteNumberTrivia(tNumber);
              
              expect(() => call, throwsA(ServerException));


            });
  });





  group('getRandomNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json'),));
    test('''should perform a GET request on a URL with 
    number being the endpoint with application/json header''',
            () async {
      setUpMockHttpSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get('http://numbersapi.com/random', headers: {'Content-Type': 'application/json'}));
            });

    test('should return NumberTrivia when response code is 200 (success)',
            () async{
              setUpMockHttpSuccess200();

              final result = await dataSource.getRandomNumberTrivia();

              expect(result, tNumberTriviaModel);
            });
    test('should throw a ServerException when the response code is 404 or other',
            (){
              setUpMockHttpSuccess404();

              final call = dataSource.getRandomNumberTrivia();

              expect(() => call, throwsA(ServerException));


            });
  });
}