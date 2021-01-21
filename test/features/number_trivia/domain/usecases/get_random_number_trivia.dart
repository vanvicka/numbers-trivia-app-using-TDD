import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/usecases/usecase.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';



class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{}
void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;


  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });


  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the repository',
          () async{
        //arrange
        when(mockNumberTriviaRepository.getRandomNumberTrivia())
            .thenAnswer((realInvocation) async => Right(tNumberTrivia));

        //act
        final result = await useCase(NoParams());

        //assert
        expect(result, Right(tNumberTrivia));
        verify(mockNumberTriviaRepository.getRandomNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRepository);

      });
}
