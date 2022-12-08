import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recorder/home/bloc/home_bloc.dart';
import 'package:recorder/utils/global_function.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height * 0.7,
      //       width: double.infinity,
      //       color: Colors.greenAccent,
      //     ),
      //     Container(
      //       // height: MediaQuery.of(context).size.height * 0.3,
      //       // width: double.infinity,
      //       child: Container(
      //         height: 80,
      //         width: 80,
      //         decoration: BoxDecoration(
      //             color: Colors.green, borderRadius: BorderRadius.circular(100)
      //             //more than 50% of width makes circle
      //             ),
      //       ),
      //     ),
      //   ],
      // ),

      body: Stack(children: [
        Container(
          height: mQueryHeight(context, size: 0.75),
          width: double.infinity,
          color: Colors.greenAccent,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              bool isRecording = state.isRecording;
              return Container(
                height:
                    mQueryHeight(context, size: (isRecording) ? 0.30 : 0.25),
                width: double.infinity,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                        visible: isRecording,
                        child: Column(
                          children: [
                            Text('Recording'),
                            verticalSpace(30),
                          ],
                        )),
                    Container(
                      width: 70,
                      height: 70,
                      child: IconButton(
                        icon: Icon(
                          (isRecording) ? Icons.stop : Icons.mic,
                          size: 30,
                        ),
                        onPressed: () =>
                            context.read<HomeBloc>().add(HomePressRecordBtn()),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
