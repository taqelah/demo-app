import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _permissionDenied = false;
  String? _errorMessage;
  int _currentCameraIndex = 0;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _permissionDenied = true);
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMessage = 'No cameras found on this device');
        return;
      }
      await _startCamera(_currentCameraIndex);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to initialize camera: $e');
    }
  }

  Future<void> _startCamera(int cameraIndex) async {
    _controller?.dispose();
    final camera = _cameras[cameraIndex];
    _controller = CameraController(camera, ResolutionPreset.medium);

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _currentCameraIndex = cameraIndex;
          _capturedImagePath = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Camera error: $e');
    }
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    final nextIndex = (_currentCameraIndex + 1) % _cameras.length;
    _startCamera(nextIndex);
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      setState(() => _capturedImagePath = image.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo saved: ${image.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Camera permission denied',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: _capturedImagePath != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Photo Captured!',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : CameraPreview(_controller!),
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_capturedImagePath != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                  onPressed: () {
                    setState(() => _capturedImagePath = null);
                  },
                )
              else
                const SizedBox(width: 48),
              GestureDetector(
                onTap: _capturedImagePath != null ? null : _takePicture,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: _capturedImagePath != null
                        ? Colors.grey
                        : Colors.white24,
                  ),
                  child: const Icon(Icons.camera, color: Colors.white, size: 36),
                ),
              ),
              if (_cameras.length > 1)
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios,
                      color: Colors.white, size: 32),
                  onPressed: _switchCamera,
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ],
    );
  }
}
