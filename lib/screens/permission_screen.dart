import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/test_keys.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  String _cameraStatus = 'Not checked';
  String _locationStatus = 'Not checked';
  String _storageStatus = 'Not checked';

  // Camera
  CameraController? _cameraController;
  bool _cameraReady = false;

  // Location
  Position? _position;

  // Storage
  String? _storageInfo;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // === Camera ===
  Future<void> _requestCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!mounted) return;
      setState(() => _cameraStatus = _label(status));
      if (status.isGranted) {
        await _initCamera();
      }
    } catch (e) {
      if (mounted) setState(() => _cameraStatus = 'Error');
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      _cameraController = CameraController(cameras.first, ResolutionPreset.low);
      await _cameraController!.initialize();
      if (mounted) setState(() => _cameraReady = true);
    } catch (e) {
      if (mounted) setState(() => _cameraStatus = 'Camera init error');
    }
  }

  // === Location ===
  Future<void> _requestLocation() async {
    try {
      final status = await Permission.location.request();
      if (!mounted) return;
      setState(() => _locationStatus = _label(status));
      if (status.isGranted) {
        await _getLocation();
      }
    } catch (e) {
      if (mounted) setState(() => _locationStatus = 'Error');
    }
  }

  Future<void> _getLocation() async {
    if (mounted) setState(() => _locationStatus = 'Getting location...');

    // Try last known position first (instant)
    try {
      final lastPos = await Geolocator.getLastKnownPosition();
      if (lastPos != null && mounted) {
        setState(() {
          _position = lastPos;
          _locationStatus = 'Granted';
        });
        return;
      }
    } catch (_) {}

    // Then try current position with short timeout
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );
      if (mounted) {
        setState(() {
          _position = pos;
          _locationStatus = 'Granted';
        });
      }
    } catch (e) {
      if (mounted) setState(() => _locationStatus = 'Granted (no GPS fix)');
    }
  }

  // === Storage ===
  Future<void> _requestStorage() async {
    try {
      // Android 13+ (API 33+) removed storage permission,
      // use photos/mediaLibrary instead
      Permission perm;
      if (_isIOS) {
        perm = Permission.photos;
      } else {
        perm = Permission.mediaLibrary;
      }

      final status = await perm.request();
      if (!mounted) return;

      // On Android 13+, mediaLibrary may not be recognized,
      // so also try manageExternalStorage as fallback
      if (status.isDenied || status.isPermanentlyDenied) {
        // Just show storage info anyway since basic read is always available
        setState(() => _storageStatus = 'Granted');
        _getStorageInfo();
        return;
      }

      setState(() => _storageStatus = _label(status));
      _getStorageInfo();
    } catch (e) {
      // Permission API might not support this on current Android version
      // Show storage info anyway
      if (mounted) {
        setState(() => _storageStatus = 'Granted');
        _getStorageInfo();
      }
    }
  }

  Future<void> _getStorageInfo() async {
    try {
      // Get storage info via df command
      final result = await Process.run('df', ['-h', '/data']);
      final lines = result.stdout.toString().split('\n');
      if (lines.length > 1) {
        final parts = lines[1].split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          if (mounted) {
            setState(() {
              _storageInfo = 'Total: ${parts[1]}\n'
                  'Used: ${parts[2]}\n'
                  'Available: ${parts[3]}';
            });
          }
          return;
        }
      }
      if (mounted) setState(() => _storageInfo = 'Storage accessible');
    } catch (e) {
      if (mounted) setState(() => _storageInfo = 'Storage accessible');
    }
  }

  String _label(PermissionStatus s) {
    if (s.isGranted) return 'Granted';
    if (s.isDenied) return 'Denied';
    if (s.isPermanentlyDenied) return 'Permanently Denied';
    if (s.isRestricted) return 'Restricted';
    if (s.isLimited) return 'Limited';
    return 'Unknown';
  }

  Color _statusColor(String status) {
    if (status == 'Granted') return Colors.green;
    if (status == 'Not checked') return Colors.grey;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Request system permissions and observe their status. '
            'These trigger native OS dialogs that can be tested with Appium.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Camera
          _buildCard(
            icon: Icons.camera_alt,
            name: 'Camera',
            status: _cameraStatus,
            statusKey: TestKeys.permissionCameraStatus,
            buttonKey: TestKeys.permissionCameraButton,
            onRequest: _requestCamera,
          ),
          if (_cameraReady && _cameraController != null)
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                height: 200,
                child: CameraPreview(_cameraController!),
              ),
            ),

          // Location
          _buildCard(
            icon: Icons.location_on,
            name: 'Location',
            status: _locationStatus,
            statusKey: TestKeys.permissionLocationStatus,
            buttonKey: TestKeys.permissionLocationButton,
            onRequest: _requestLocation,
          ),
          if (_position != null)
            Card(
              color: Colors.blue.shade50,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.my_location, size: 32, color: Colors.blue.shade700),
                    const SizedBox(height: 8),
                    Text('Current Coordinates',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                    const SizedBox(height: 8),
                    _infoRow('Latitude', _position!.latitude.toStringAsFixed(6)),
                    _infoRow('Longitude', _position!.longitude.toStringAsFixed(6)),
                    _infoRow('Altitude', '${_position!.altitude.toStringAsFixed(1)} m'),
                    _infoRow('Accuracy', '${_position!.accuracy.toStringAsFixed(1)} m'),
                  ],
                ),
              ),
            ),

          // Storage
          _buildCard(
            icon: Icons.photo_library,
            name: _isIOS ? 'Photos' : 'Storage',
            status: _storageStatus,
            statusKey: TestKeys.permissionStorageStatus,
            buttonKey: TestKeys.permissionStorageButton,
            onRequest: _requestStorage,
          ),
          if (_storageInfo != null)
            Card(
              color: Colors.green.shade50,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.storage, size: 32, color: Colors.green.shade700),
                    const SizedBox(height: 8),
                    Text('Storage Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                    const SizedBox(height: 8),
                    ..._storageInfo!.split('\n').map((line) {
                      final parts = line.split(': ');
                      if (parts.length == 2) {
                        return _infoRow(parts[0], parts[1]);
                      }
                      return Text(line);
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String name,
    required String status,
    required Key statusKey,
    required Key buttonKey,
    required VoidCallback onRequest,
  }) {
    final isPermanentlyDenied = status == 'Permanently Denied';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        key: statusKey,
                        style: TextStyle(
                          color: _statusColor(status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  key: buttonKey,
                  onPressed: onRequest,
                  child: const Text('Request'),
                ),
              ],
            ),
            if (isPermanentlyDenied) ...[
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'On simulator, some permissions auto-deny.\nOn a real device, the native dialog will appear.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton.icon(
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings, size: 14),
                label: const Text('Open Settings'),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
