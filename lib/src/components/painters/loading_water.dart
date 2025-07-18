import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/painters/progress_painter.dart';
import 'package:tridentpro/src/components/painters/wave_painter.dart';

class LoadingWater extends StatelessWidget {
  const LoadingWater({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white60,
      child: Center(
        child: SizedBox(
          width: size.width / 2,
          height: size.width / 2,
          child: CircularWaveProgress()),
      ),
    );
  }
}


class CircularWaveProgress extends StatefulWidget {
  const CircularWaveProgress({super.key});

  @override
  State<StatefulWidget> createState() => _CircularWaveProgressState();
}

class _CircularWaveProgressState extends State<CircularWaveProgress> with TickerProviderStateMixin {
  late final Animation<double> _progressAnimation;
  late final AnimationController _progressController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _progressAnimation = Tween(begin: 0.0, end: 100.0).animate(_progressController);
    _progressController.addListener(_progressListener);
    _waveController.repeat();
    _runAnimation();
  }

  void _progressListener() {
    if (_progressController.isCompleted) setState(() {});
  }

  @override
  void dispose() {
    _progressController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _runAnimation() {
    _progressController.forward();
    setState(() {});
  }

  void _refreshAnimation() {
    _progressController.reset();
    setState(() {});
  }

  void _stopAnimation() {
    _progressController.stop();
    setState(() {});
  }

  IconData get icon {
    if (_progressController.isAnimating) return Icons.stop_rounded;
    if (_progressController.isCompleted) return Icons.refresh_rounded;
    return Icons.play_arrow_rounded;
  }

  VoidCallback get callback {
    if (_progressController.isAnimating) return _stopAnimation;
    if (_progressController.isCompleted) return _refreshAnimation;
    return _runAnimation;
  }

  Color get buttonColor {
    if (_progressController.isAnimating) return const Color(0xFFF44336);
    if (_progressController.isCompleted) return const Color(0xFF2196F3);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) => Center(
                child: SphericalWaterRippleProgressBar(
                  progress: _progressAnimation,
                  waveAnimation: _waveController,
                  sphereRadius: constraints.biggest.shortestSide / 2,
                ),
              ),
            ),
          ),
          // const SizedBox(height: 30),
          // IconButton(
          //   iconSize: 77,
          //   onPressed: _callback,
          //   icon: Icon(_icon, color: _buttonColor),
          // ),
        ],
      ),
    );
  }
}

class SphericalWaterRippleProgressBar extends StatelessWidget {
  const SphericalWaterRippleProgressBar({
    super.key,
    required Animation<double> progress,
    required Animation<double> waveAnimation,
    required this.sphereRadius,
  })  : _progress = progress,
        _waveAnimation = waveAnimation;

  final Animation<double> _progress;
  final Animation<double> _waveAnimation;
  final double sphereRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(
        progress: _progress,
        waveAnimation: _waveAnimation,
        circleRadius: sphereRadius,
      ),
      foregroundPainter: ProgressPainter(
        progress: _progress,
        circleRadius: sphereRadius,
      ),
    );
  }
}