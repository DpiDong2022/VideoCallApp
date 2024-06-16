import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:videocall/models/user.dart';

class VideoCallPage extends StatefulWidget {
  final User user;

  const VideoCallPage({Key? key, required this.user}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;

  // Variables to manage draggable camera preview
  late double _previewLeft;
  late double _previewTop;
  late double _dragStartX;
  late double _dragStartY;

  @override
  void initState() {
    super.initState();
    _previewLeft = 20; // Initial left position
    _previewTop = 40; // Initial top position
    _initializeCamera();
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

  // Method to toggle microphone on/off
  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  // Method to toggle camera on/off
  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
      if (_isCameraOn) {
        _cameraController.initialize();
      } else {
        _cameraController.dispose();
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Method to handle drag gesture start
  void _onDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx - _previewLeft;
    _dragStartY = details.globalPosition.dy - _previewTop;
  }

  // Method to handle drag gesture update
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
                // Fake video call full screen
                Container(
                  color: Color.fromARGB(255, 81, 197, 83),
                  child: Center(
                    child: Text(
                      'Fake Video Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
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
                // End call button at the bottom center
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
                        SizedBox(width: 24),
                        // Toggle camera button
                        IconButton(
                          onPressed: _toggleCamera,
                          icon: Icon(
                            _isCameraOn ? Icons.videocam : Icons.videocam_off,
                            color: _isCameraOn ? Colors.white : Colors.red,
                          ),
                        ),
                        SizedBox(width: 24),
                        // End call button
                        FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.call_end),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
