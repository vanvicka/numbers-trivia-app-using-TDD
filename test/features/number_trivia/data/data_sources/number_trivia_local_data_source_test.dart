import 'dart:convert';

import 'package:fisrtflutterapp/core/error/expections.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/models/number_trivia%20_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}


void main(){
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences:mockSharedPreferences);
  });
  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test('should return cachedTrivia from sharedPreferences if available', () async{
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, tNumberTriviaModel);
    });
    test('should throw cache exception when there is no value', () async{
      when(mockSharedPreferences.getString(any)).thenReturn(null);

       final call =  dataSource.getLastNumberTrivia;

      expect(() => call() ,throwsA(CacheException));
    });
  });
  group('cacheNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call shared sharedPreferences to cache the data',
            () async {
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      
      
      final expectedString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString('CACHED_NUMBER_TRIVIA', expectedString));
            });
  });
}