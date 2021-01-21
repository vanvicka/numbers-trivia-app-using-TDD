import 'package:dartz/dartz.dart';
import 'package:fisrtflutterapp/core/error/failures.dart';
import 'package:fisrtflutterapp/core/usecases/usecase.dart';
import 'package:fisrtflutterapp/core/util/input_converter.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia{}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia{}
class MockInputConverter extends Mock implements InputConverter{}

void main(){
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter inputConverter;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(getConcreteNumberTrivia: mockGetConcreteNumberTrivia, getRandomNumberTrivia: mockGetRandomNumberTrivia, inputConverter: inputConverter);
  });
  
  test( "initial state should be empty",
          () async{
    expect(bloc.initialState, Empty());
          });
  group('GetTriviaForConcreteNumber',
          (){

    final tNumberString = '1';
    final tNumberParsed =  1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void  setUpMockInputConverterSuccess(){
      when(inputConverter.stringToUnsignedInteger(any)).thenAnswer((realInvocation) => Right(tNumberParsed));

    }


    test('should call the input converter to validate and convert the string to an unsigned integer',
            () async{
      setUpMockInputConverterSuccess();

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));

      verify(inputConverter.stringToUnsignedInteger(tNumberString));
            });
    test('should emit [Error] when the input is Invalid',
            () async{
      when(inputConverter.stringToUnsignedInteger(any)).thenAnswer((realInvocation) => Left(InvalidInputFailure()));

      final expected = [Empty(),Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      expectLater(bloc.state, emitsInOrder(expected));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));


            });
    test('should get data from the concrete use case',
            () async{
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));




            });
    test('should emit [Loading, Loaded] when data is gotten successfully',
            () async{
              setUpMockInputConverterSuccess();
              when(mockGetConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => Right(tNumberTrivia));

              final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

            });
    test('should emit [Loading, Error] when getting data fails',
            () async{
              setUpMockInputConverterSuccess();
              when(mockGetConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => Left(ServerFailure()));

              final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE )];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

            });
    test('should emit [Loading, Error] with a proper message for the error when getting data fails',
            () async{
              setUpMockInputConverterSuccess();
              when(mockGetConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => Left(CacheFailure()));

              final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE )];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

            });
          });




  group('GetTriviaForRandomNumber',
          (){


    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);




    test('should get data from the random use case',
            () async{
      when(mockGetRandomNumberTrivia(any)).thenAnswer((realInvocation) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia( any));

      verify(mockGetRandomNumberTrivia( NoParams()));




            });
    test('should emit [Loading, Loaded] when data is gotten successfully',
            () async{
              when(mockGetRandomNumberTrivia(any)).thenAnswer((realInvocation) async => Right(tNumberTrivia));

              final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForRandomNumber());

            });
    test('should emit [Loading, Error] when getting data fails',
            () async{
              when(mockGetRandomNumberTrivia(any)).thenAnswer((realInvocation) async => Left(ServerFailure()));

              final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE )];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForRandomNumber());

            });
    test('should emit [Loading, Error] with a proper message for the error when getting data fails',
            () async{
              when(mockGetRandomNumberTrivia(any)).thenAnswer((realInvocation) async => Left(CacheFailure()));

              final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE )];

              expectLater(bloc.state, emitsInOrder(expected));

              bloc.dispatch(GetTriviaForRandomNumber());

            });
          });
}