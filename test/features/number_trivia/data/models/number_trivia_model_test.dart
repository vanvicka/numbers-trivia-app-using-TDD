import 'dart:convert';
import 'package:fisrtflutterapp/features/number_trivia/data/models/number_trivia%20_model.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';


void main(){
  final tNumberTriviaModel = NumberTriviaModel(text: "test text", number: 1);


  test('should be a subclass of NumberTrivia entity',
          ()async{
    expect(tNumberTriviaModel, isA<NumberTrivia>());
          }
  );

  group('fromJSON', (){
    test('should return  valid model when the JSON is a double',
            () async{
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia_double.json'));


      final result = NumberTriviaModel.fromJson(jsonMap);


      expect(result, tNumberTriviaModel);

            });

  });





  group('toJSON', (){
    test('should return  JSON map containing proper data',
            ()async{


      final result = tNumberTriviaModel.toJson();

     final expectedMap = {
        "text": "test text",
        "number": 1.0,
     };

      expect(result, expectedMap);

    });
  });

}


