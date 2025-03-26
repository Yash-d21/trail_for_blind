import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // Initialize the camera controller
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    // Initialize the controller
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndRecognizeText() async {
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Capture the image
      final image = await _controller!.takePicture();

      // Create an InputImage from the captured image
      final inputImage = InputImage.fromFilePath(image.path);

      // Initialize the text recognizer
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // Extract the recognized text
      setState(() {
        _recognizedText = recognizedText.text;
      });

      // Close the text recognizer
      await textRecognizer.close();
    } catch (e) {
      print('Error capturing and recognizing text: $e');
      setState(() {
        _recognizedText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _recognizedText.isEmpty ? 'No text recognized yet' : _recognizedText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: _captureAndRecognizeText,
            child: const Text('Capture and Recognize Text'),
          ),
        ],
      ),
    );
  }
}