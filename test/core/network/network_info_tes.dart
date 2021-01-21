

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fisrtflutterapp/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker{}

  void main(){
    NetworkInfoImpl networkInfoImpl;
    MockDataConnectionChecker mockDataConnectionChecker;


    setUp((){
      var mockDataConnectionChecker = MockDataConnectionChecker();
      networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
    });
    group('isConnected', (){
      test('should forward the call to dataConnection.hasConnection', () async{

        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker.hasConnection).thenAnswer((realInvocation) => tHasConnectionFuture);

        final result =  networkInfoImpl.isConnected;

        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      });
    });

  }

