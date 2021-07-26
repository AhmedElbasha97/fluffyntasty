import 'dart:async';

import 'package:fbTrade/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}
    VideoPlayerController _controller;

class _IntroPageState extends State<IntroPage> {
  Timer _timer;
  @override
  void initState() {
    super.initState();
        super.initState();
    _controller = VideoPlayerController.asset("assets/photos/intro.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
            _timer = Timer(Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ));
    });
      });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body:  Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),));
  }
}
