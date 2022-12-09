import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recorder/home/bloc/home_bloc.dart';
import 'package:recorder/utils/custom_colors.dart';
import 'package:recorder/utils/global_function.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(const HomeInitPlayer());
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<HomeBloc>(context).add(const HomeDisposePlayer());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          bool isRecording = state.isRecording;
          bool isPlaying = state.isPlaying;
          bool isRecordingAvailable = state.isRecordingAvailable;
          bool isAudioPermissionGranted = state.isAudioPermissionGranted;
          return Stack(children: [
            Container(
              height: mQueryHeight(context, size: 0.75),
              width: double.infinity,
              color: Colors.greenAccent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        color:
                            isRecordingAvailable ? BTN_AVAILABLE : BTN_DISABLE,
                        size: 30,
                      ),
                      onPressed: isRecording || !isRecordingAvailable
                          ? () {}
                          : () =>
                              context.read<HomeBloc>().add(HomePressPlayBtn()),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color:
                            isRecordingAvailable ? BTN_AVAILABLE : BTN_DISABLE,
                        style: BorderStyle.solid,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
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
                            color: isAudioPermissionGranted
                                ? BTN_AVAILABLE
                                : BTN_DISABLE,
                            size: 30,
                          ),
                          onPressed: isPlaying
                              ? () {}
                              : () => context
                                  .read<HomeBloc>()
                                  .add(HomePressRecordBtn()),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: isAudioPermissionGranted
                                ? BTN_AVAILABLE
                                : BTN_DISABLE,
                            style: BorderStyle.solid,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ))
          ]);
        },
      ),
    );
  }
}
