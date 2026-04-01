import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'home_screen.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with TickerProviderStateMixin {
  late AnimationController _lineAnimationController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
    
    
    _lineAnimationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _lineAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    
    _lineAnimationController.forward();
  }

  @override
  void dispose() {
    _lineAnimationController.dispose();
    super.dispose();
  }

  
  List<Offset> _getPathwayPoints(Size size) {
    return [
      Offset(size.width * 0.1, size.height * 0.9), // 
      Offset(size.width * 0.1, size.height * 0.75), // Up
      Offset(size.width * 0.4, size.height * 0.75), // Right 
      Offset(size.width * 0.4, size.height * 0.6), // Up
      Offset(size.width * 0.1, size.height * 0.6), // 
      Offset(size.width * 0.1, size.height * 0.45), // Up
      Offset(size.width * 0.35, size.height * 0.45), // Right 
      Offset(size.width * 0.35, size.height * 0.3), // Up
      Offset(size.width * 0.1, size.height * 0.3), // Left 
      Offset(size.width * 0.1, size.height * 0.15), // Up 
    ];
  }

 
  Offset _getCurrentPosition(Size size) {
    final points = _getPathwayPoints(size);
    final totalLength = _calculateTotalPathLength(points);
    final currentLength = totalLength * _lineAnimation.value;

    return _getPointAtDistance(points, currentLength);
  }

  // Calculate total path length
  double _calculateTotalPathLength(List<Offset> points) {
    double length = 0;
    for (int i = 0; i < points.length - 1; i++) {
      length += (points[i + 1] - points[i]).distance;
    }
    return length;
  }

  // Get point at specific distance along path
  Offset _getPointAtDistance(List<Offset> points, double distance) {
    double currentDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final segmentLength = (points[i + 1] - points[i]).distance;
      if (currentDistance + segmentLength >= distance) {
        final t = (distance - currentDistance) / segmentLength;
        return Offset.lerp(points[i], points[i + 1], t)!;
      }
      currentDistance += segmentLength;
    }
    return points.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Light yellow background
      body: AnimatedBuilder(
        animation: _lineAnimation,
        builder: (context, child) {
          final screenSize = MediaQuery.of(context).size;
          return Stack(
            children: [
              
              ExcludeSemantics(
                child: IgnorePointer(
                  ignoring: true,
                  child: CustomPaint(
                    painter: PathwayPainter(
                      currentPosition: _getCurrentPosition(screenSize),
                      animationValue: _lineAnimation.value,
                    ),
                    size: screenSize,
                  ),
                ),
              ),
              
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800), // Light orange
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'CARDIO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D4037), // Dark brown
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'COMRADE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              // Motivational text - positioned to avoid pathway lines
              Positioned(
                left: screenSize.width * 0.45,
                top: screenSize.height * 0.5,
                child: Column(
                  children: [
                    const Text(
                      'chase progress',
                      style: TextStyle(
                        color: Color(0xFF5D4037),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'not perfection',
                      style: TextStyle(
                        color: Color(0xFF5D4037),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              
              Positioned(
                left: screenSize.width * 0.2,
                bottom: screenSize.height * 0.1,
                child: SizedBox(
                  width: screenSize.width * 0.6,
                  child:                 Semantics(
                  label: 'Start',
                  hint: 'Navigate to home screen',
                  button: true,
                  child: ElevatedButton(
                    onPressed: () {
                      // Haptic feedback for better UX
                      HapticFeedback.mediumImpact();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F), // Red
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      minimumSize: const Size(88, 48), // Minimum touch target
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(8),
                          bottomLeft: const Radius.circular(8),
                          topRight: const Radius.circular(25),
                          bottomRight: const Radius.circular(25),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'START',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class PathwayPainter extends CustomPainter {
  final Offset currentPosition;
  final double animationValue;

  PathwayPainter({
    required this.currentPosition,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define pathway points - staircase style like the photo
    final points = [
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.45),
      Offset(size.width * 0.35, size.height * 0.45),
      Offset(size.width * 0.35, size.height * 0.3),
      Offset(size.width * 0.1, size.height * 0.3),
      Offset(size.width * 0.1, size.height * 0.15),
    ];

    
    final totalLength = _calculateTotalPathLength(points);
    final targetDistance = totalLength * animationValue;

    
    _drawParallelLine(canvas, points, 0, 0, totalLength, 
        const Color(0xFFFFC107), 10); 

    
    _drawParallelLine(canvas, points, 0, 0, targetDistance, 
        const Color(0xFFFF9800), 10); 

    
    _drawParallelLine(canvas, points, -8, 0, targetDistance, 
        const Color(0xFFD32F2F), 10); 
  }

  void _drawParallelLine(Canvas canvas, List<Offset> points, 
      double offsetDistance, double startDistance, double endDistance, 
      Color color, double strokeWidth) {
    final path = Path();
    double currentDistance = 0;
    bool pathStarted = false;

    for (int i = 0; i < points.length - 1; i++) {
      final segmentLength = (points[i + 1] - points[i]).distance;
      final segmentStart = currentDistance;
      final segmentEnd = currentDistance + segmentLength;

      
      if (segmentEnd >= startDistance && segmentStart <= endDistance) {
        final drawStart = math.max(startDistance, segmentStart);
        final drawEnd = math.min(endDistance, segmentEnd);
        
        if (drawStart < drawEnd) {
          final t1 = (drawStart - segmentStart) / segmentLength;
          final t2 = (drawEnd - segmentStart) / segmentLength;
          
          final p1 = Offset.lerp(points[i], points[i + 1], t1)!;
          final p2 = Offset.lerp(points[i], points[i + 1], t2)!;
          
          // Apply perpendicular offset for parallel lines
          final offset1 = _getPerpendicularOffset(points[i], points[i + 1], offsetDistance);
          final offset2 = _getPerpendicularOffset(points[i], points[i + 1], offsetDistance);
          
          final startPoint = Offset(p1.dx + offset1.dx, p1.dy + offset1.dy);
          final endPoint = Offset(p2.dx + offset2.dx, p2.dy + offset2.dy);
          
          if (!pathStarted) {
            path.moveTo(startPoint.dx, startPoint.dy);
            pathStarted = true;
          }
          path.lineTo(endPoint.dx, endPoint.dy);
        }
      }
      
      currentDistance += segmentLength;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  double _calculateTotalPathLength(List<Offset> points) {
    double length = 0;
    for (int i = 0; i < points.length - 1; i++) {
      length += (points[i + 1] - points[i]).distance;
    }
    return length;
  }

  Offset _getPerpendicularOffset(Offset p1, Offset p2, double distance) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final length = math.sqrt(dx * dx + dy * dy);
    if (length == 0) return Offset.zero;
    // Perpendicular vector: (-dy, dx) normalized and scaled
    return Offset(-dy * distance / length, dx * distance / length);
  }

  @override
  bool shouldRepaint(PathwayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.currentPosition != currentPosition;
  }
}

