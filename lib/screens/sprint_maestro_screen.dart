import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'home_screen.dart';
import 'bodysync_screen.dart';
import 'opening_screen.dart';

class SprintMaestroScreen extends StatefulWidget {
  const SprintMaestroScreen({super.key});

  @override
  State<SprintMaestroScreen> createState() => _SprintMaestroScreenState();
}

class _SprintMaestroScreenState extends State<SprintMaestroScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  double _calculatedDistance = 14.8; // this value is not real this is for display only
  int _estimatedMinutes = 80;// this value is not real and is only for display

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    // adding haptics
    HapticFeedback.mediumImpact();
    
    if (_isRunning && !_isPaused) {
      // Stop timer
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = false;
      });
      // User feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timer stopped at ${_formatTime(_seconds)}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      
      _isRunning = true;
      _isPaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isPaused ? 'Timer resumed' : 'Timer started'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _pauseTimer() {
    if (_isRunning && !_isPaused) {
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      _timer?.cancel();
      setState(() {
        _isPaused = true;
      });
      // User feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer paused'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _restartTimer() {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart Timer?'),
        content: Text('Reset timer to 00:00? Current time: ${_formatTime(_seconds)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _timer?.cancel();
              setState(() {
                _seconds = 0;
                _isRunning = false;
                _isPaused = false;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Timer reset'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000), // Dark red background
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      const Text(
                        'Sprint Maestro',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'powered by Cardio Comrade',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Region Selection Section
                    const Text(
                      'Select a region for outdoor running.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Map placeholder with graphics
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomPaint(
                          painter: MapMockupPainter(),
                          child: Stack(
                            children: [
                              
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        size: 14,
                                        color: Colors.grey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Map View',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Timer
                    Center(
                      child: Column(
                        children: [
                          Semantics(
                            label: 'Timer',
                            value: _formatTime(_seconds),
                            child: Text(
                              _formatTime(_seconds),
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Start/Stop button
                          Semantics(
                            label: _isRunning && !_isPaused ? 'Stop timer' : _isPaused ? 'Resume timer' : 'Start timer',
                            hint: _isRunning && !_isPaused ? 'Stop the running timer' : _isPaused ? 'Resume the paused timer' : 'Start the running timer',
                            button: true,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _startTimer,
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 16,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 88,
                                    minHeight: 48,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B0000),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    _isRunning && !_isPaused ? 'stop' : _isPaused ? 'resume' : 'start',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Pause and Restart buttons 
                          if (_isRunning || _isPaused) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Pause button
                                if (!_isPaused)
                                  Semantics(
                                    label: 'Pause timer',
                                    hint: 'Pause the running timer',
                                    button: true,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _pauseTimer,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 48,
                                            minHeight: 48,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                'pause',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (!_isPaused) const SizedBox(width: 12),
                                // Restart button
                                Semantics(
                                  label: 'Restart timer',
                                  hint: 'Reset the timer to zero',
                                  button: true,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _restartTimer,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 12,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 48,
                                          minHeight: 48,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'restart',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Information Boxes
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2B48C), 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'total calculated distance: ${_calculatedDistance.toStringAsFixed(1)} km.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2B48C), 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'estimated time: ~$_estimatedMinutes minutes.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Positioned(
              top: 70,
              right: 16,
              child: Semantics(
                label: 'Refresh',
                hint: 'Return to opening screen',
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Haptic feedback
                      HapticFeedback.lightImpact();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OpeningScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            _buildNavItem(
              icon: Icons.home,
              isActive: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            // Running Person - Active
            _buildNavItem(
              icon: Icons.directions_run,
              isActive: true,
              onTap: () {
                // Already on this screen
              },
            ),
            // Settings/Filters
            _buildNavItem(
              icon: Icons.tune,
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BodySyncScreen(),
                  ),
                );
              },
            ),
            // Profile
            _buildNavItem(
              icon: Icons.person_outline,
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    if (isActive) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800), // Orange
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}

// Custom painter for map mockup graphics
class MapMockupPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background - light green (grass/parks)
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw roads/paths
    final roadPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );

    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );

    // Diagonal path
    final pathPaint = Paint()
      ..color = Colors.grey[500]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    final diagonalPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.9, size.height * 0.3);
    canvas.drawPath(diagonalPath, pathPaint);

    // Running route path (orange/red)
    final routePaint = Paint()
      ..color = const Color(0xFFFF6347) // Tomato/red-orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final routePath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.2,
        size.width * 0.85,
        size.height * 0.3,
      );
    canvas.drawPath(routePath, routePaint);

    // Draw buildings/structures
    final buildingPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    // Building 1
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.1, size.width * 0.15, size.height * 0.2),
      buildingPaint,
    );

    // Building 2
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.5, size.width * 0.2, size.height * 0.25),
      buildingPaint,
    );

    // Building 3
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.75, size.height * 0.65, size.width * 0.15, size.height * 0.2),
      buildingPaint,
    );

    // Draw start marker
    final startMarkerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      8,
      startMarkerPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw end marker
    final endMarkerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      8,
      endMarkerPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.3),
      8,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw some trees/parks (green circles)
    final treePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.7), 12, treePaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.15), 10, treePaint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.5), 8, treePaint);
  }

  @override
  bool shouldRepaint(MapMockupPainter oldDelegate) => false;
}
