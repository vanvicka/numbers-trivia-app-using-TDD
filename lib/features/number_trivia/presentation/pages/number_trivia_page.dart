import 'package:fisrtflutterapp/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:fisrtflutterapp/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:fisrtflutterapp/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:fisrtflutterapp/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:fisrtflutterapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [Colors.pink,Colors.purple] )

          ),
        ),
        title: Text("Number Trivia"),),
      body: SingleChildScrollView(
        child: BlocProvider(
          builder: (_) => sl<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                      builder: (context, state) {
                        if (state is Empty) {
                          return MessageDisplay(message: 'Start Searching!',);
                        }
                        else if (state is Loading) {
                          return LoadingWidget();
                        } else if (state is Loaded) {
                          return TriviaDisplay(numberTrivia: state.trivia,);
                        }
                        else if (state is Error) {
                          return MessageDisplay(message: state.message,);
                        }
                        return LoadingWidget();
                      }
                      ),

                  SizedBox(height: 20,),

                  TriviaControls(),

                ],),
            ),
          ),
        ),
      ),
    );
  }
}




class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final textController = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        controller: textController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Input a Number',
            border:  OutlineInputBorder()),
        onChanged: (val){
        inputStr = val;
      },),
      SizedBox(height: 10,),
      Row(children: [
        Expanded(child: RaisedButton(
           child: Text('Search'),
            color: Theme.of(context).primaryColor,
            textTheme: ButtonTextTheme.primary,
            onPressed: dispatchConcrete
            )
        ),
        SizedBox(width: 10,),
        Expanded(child: RaisedButton(
            child: Text('Get Random Trivia'),
            color: Theme.of(context).primaryColor,
            textTheme: ButtonTextTheme.primary,

            onPressed: dispatchRandom
        )),
      ],)

    ],);
  }
  void dispatchConcrete(){
    textController.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom(){
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForRandomNumber());
  }
}










