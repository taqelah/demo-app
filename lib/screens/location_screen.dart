import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _permissionDenied = false;
  bool _serviceDisabled = false;
  bool _isTracking = false;
  Position? _currentPosition;
  String? _errorMessage;
  StreamSubscription<Position>? _positionStream;
  final List<_LocationEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      setState(() => _permissionDenied = true);
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _serviceDisabled = true);
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Error getting location: $e');
      }
    }
  }

  void _startTracking() {
    setState(() => _isTracking = true);
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _history.insert(
            0,
            _LocationEntry(
              position: position,
              time: DateTime.now(),
            ),
          );
          if (_history.length > 20) _history.removeLast();
        });
      }
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    setState(() => _isTracking = false);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Location permission denied',
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

    if (_serviceDisabled) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_disabled, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('Location services are disabled',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: const Text('Open Location Settings'),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _currentPosition == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current location card
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.my_location, size: 48, color: Colors.blue.shade700),
                const SizedBox(height: 12),
                Text('Current Location',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700)),
                const SizedBox(height: 12),
                _buildInfoRow(
                    'Latitude', _currentPosition!.latitude.toStringAsFixed(6)),
                _buildInfoRow('Longitude',
                    _currentPosition!.longitude.toStringAsFixed(6)),
                _buildInfoRow(
                    'Altitude', '${_currentPosition!.altitude.toStringAsFixed(1)} m'),
                _buildInfoRow(
                    'Speed', '${_currentPosition!.speed.toStringAsFixed(1)} m/s'),
                _buildInfoRow('Accuracy',
                    '${_currentPosition!.accuracy.toStringAsFixed(1)} m'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _isTracking
                  ? OutlinedButton.icon(
                      onPressed: _stopTracking,
                      icon: const Icon(Icons.stop, color: Colors.red),
                      label: const Text('Stop Tracking'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        foregroundColor: Colors.red,
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: _startTracking,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Tracking'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
            ),
          ],
        ),

        if (_isTracking) ...[
          const SizedBox(height: 8),
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Tracking location updates...',
                      style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ),
        ],

        if (_history.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Location History',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._history.map((entry) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.blue),
                  title: Text(
                    '${entry.position.latitude.toStringAsFixed(4)}, '
                    '${entry.position.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${entry.time.hour.toString().padLeft(2, '0')}:'
                    '${entry.time.minute.toString().padLeft(2, '0')}:'
                    '${entry.time.second.toString().padLeft(2, '0')}',
                  ),
                  trailing: Text(
                    '±${entry.position.accuracy.toStringAsFixed(0)}m',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _LocationEntry {
  final Position position;
  final DateTime time;
  _LocationEntry({required this.position, required this.time});
}
