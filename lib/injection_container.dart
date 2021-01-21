

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fisrtflutterapp/core/network/network_info.dart';
import 'package:fisrtflutterapp/core/util/input_converter.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:fisrtflutterapp/features/number_trivia/data/repository_impl/number_trivia_repository_impl.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:fisrtflutterapp/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:fisrtflutterapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';

final sl  = GetIt.instance;

Future<void> init() async{
// FEATURES- NUMBER TRIVIA
  //Bloc
  sl.registerFactory(() => NumberTriviaBloc(getConcreteNumberTrivia:  sl(), getRandomNumberTrivia: sl(), inputConverter: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(localDataSource: sl(),networkInfo: sl(), remoteDataSource: sl()));
  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

// CORE
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
// EXTERNAL
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}
