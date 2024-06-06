import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController? _controller;
  double _slidePoint = 0;
  bool _isBuffering = false;

  void onTapPickVideo(
      [String url =
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4']) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.1)
      ..addListener(
        () {
          setState(() {
            _slidePoint = _controller!.value.position.inSeconds.toDouble();
          });
        },
      );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
    _controller!.removeListener(
      () {
        setState(() {
          _slidePoint = _controller!.value.position.inSeconds.toDouble();
        });
      },
    );
    setState(() {
      _slidePoint = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_controller?.value);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: _controller != null
                ? GestureDetector(
                    onTap: () {
                      _controller!.pause();

                      setState(() {
                        _slidePoint = 0;
                      });
                      onTapPickVideo(
                        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                      );
                    },
                    child: VideoPlayer(_controller!))
                : IconButton(
                    onPressed: onTapPickVideo, icon: Icon(Icons.play_arrow)),
          ),
          SizedBox(
            height: 24,
          ),
          if (_controller != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (_slidePoint >= 1) {
                        _controller!.pause();
                        _controller!.seekTo(
                          Duration(
                            seconds: _slidePoint.toInt() - 1,
                          ),
                        );
                        setState(() {
                          _slidePoint -= 1;
                        });
                      } else {
                        setState(() {
                          _slidePoint = 0;
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: () {
                      _controller!.play();
                    },
                    icon: Icon(Icons.play_arrow)),
                SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: () {
                      if (_slidePoint + 1 <=
                          _controller!.value.duration.inSeconds) {
                        _controller!.pause();
                        _controller!.seekTo(
                          Duration(
                            seconds: _slidePoint.toInt() + 1,
                          ),
                        );
                        setState(() {
                          _slidePoint += 1;
                        });
                      } else {
                        setState(() {
                          _controller!.value.duration.inSeconds.toDouble();
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_forward)),
              ],
            ),
          if (_controller != null)
            Slider(
              value: _slidePoint,
              onChanged: (value) {
                _controller!.pause();
                setState(() {
                  _slidePoint = value;
                });
                _controller!.seekTo(
                  Duration(
                    seconds: value.toInt(),
                  ),
                );
              },
              max: double.parse(
                _controller!.value.duration.inSeconds.toString(),
              ),
            )
        ],
      ),
    );
  }
}
