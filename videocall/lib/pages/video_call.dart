import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videocall/models/user.dart';

class VideoCallPage extends StatefulWidget {
  final User user;

  const VideoCallPage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  late VideoPlayerController _videoController;

  late double _previewLeft;
  late double _previewTop;
  late double _dragStartX;
  late double _dragStartY;

  @override
  void initState() {
    super.initState();
    _previewLeft = 20;
    _previewTop = 40;
    _initializeCamera();

    // Initialize video controller with asset
    _videoController = VideoPlayerController.asset(
      'assets/videos/fake_video_call.mp4',
    );

    _initializeVideoPlayer();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      _initializeControllerFuture = _cameraController.initialize();

      await _initializeControllerFuture;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _initializeVideoPlayer() async {
    await _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.play();
    setState(() {});
  }

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
      if (_isCameraOn) {
        _cameraController.initialize();
      } else {}
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx - _previewLeft;
    _dragStartY = details.globalPosition.dy - _previewTop;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _previewLeft = details.globalPosition.dx - _dragStartX;
      _previewTop = details.globalPosition.dy - _dragStartY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _videoController.value.isInitialized
                        ? Positioned(
                            child: AspectRatio(
                              aspectRatio: _videoController.value.aspectRatio,
                              child: VideoPlayer(_videoController),
                            ),
                          )
                        : Container(),
                  ],
                ),
                // Camera preview draggable
                Positioned(
                  left: _previewLeft,
                  top: _previewTop,
                  width: 120,
                  height: 160,
                  child: GestureDetector(
                    onPanStart: _onDragStart,
                    onPanUpdate: _onDragUpdate,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _cameraController.value.previewSize!.height,
                          height: _cameraController.value.previewSize!.width,
                          child: AspectRatio(
                            aspectRatio: _cameraController.value.aspectRatio,
                            child: _isCameraOn
                                ? CameraPreview(_cameraController)
                                : Container(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Toggle mic button
                        IconButton(
                          onPressed: _toggleMic,
                          icon: Icon(
                            _isMicOn ? Icons.mic : Icons.mic_off,
                            color: _isMicOn ? Colors.white : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Toggle camera button
                        IconButton(
                          onPressed: _toggleCamera,
                          icon: Icon(
                            _isCameraOn ? Icons.videocam : Icons.videocam_off,
                            color: _isCameraOn ? Colors.white : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // End call button
                        FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
