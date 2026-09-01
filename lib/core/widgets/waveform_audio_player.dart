import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';

class WaveformAudioPlayer extends StatefulWidget {
  final String title;
  final String elderName;
  final String language;
  final String transcript;
  final Duration totalDuration;
  final VoidCallback? onListenCompleted;

  const WaveformAudioPlayer({
    super.key,
    required this.title,
    required this.elderName,
    required this.language,
    required this.transcript,
    this.totalDuration = const Duration(seconds: 45),
    this.onListenCompleted,
  });

  @override
  State<WaveformAudioPlayer> createState() => _WaveformAudioPlayerState();
}

class _WaveformAudioPlayerState extends State<WaveformAudioPlayer> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Timer? _playbackTimer;
  double _playbackSpeed = 1.0;
  late AnimationController _waveAnimController;
  final List<double> _waveformSamples = List.generate(40, (i) => 0.2 + (0.7 * sin(i * 0.45).abs()));

  @override
  void initState() {
    super.initState();
    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _waveAnimController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {
            final advanceMs = (100 * _playbackSpeed).toInt();
            _currentPosition += Duration(milliseconds: advanceMs);
            if (_currentPosition >= widget.totalDuration) {
              _currentPosition = widget.totalDuration;
              _isPlaying = false;
              _playbackTimer?.cancel();
              widget.onListenCompleted?.call();
            }
          });
        });
      } else {
        _playbackTimer?.cancel();
      }
    });
  }

  void _seek(double ratio) {
    setState(() {
      final newMs = (widget.totalDuration.inMilliseconds * ratio).toInt();
      _currentPosition = Duration(milliseconds: newMs);
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final progressRatio = widget.totalDuration.inMilliseconds > 0
        ? (_currentPosition.inMilliseconds / widget.totalDuration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    // Synchronized sentence highlighting
    final sentences = widget.transcript.split('. ');
    final currentSentenceIndex = ((progressRatio * sentences.length).floor()).clamp(0, sentences.length - 1);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1E17).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: EcoColors.mintAccent.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EcoColors.forestDeep,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.graphic_eq_rounded, color: EcoColors.mintAccent, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        'Oral History by ${widget.elderName} • ${widget.language}',
                        style: const TextStyle(fontSize: 11.5, color: EcoColors.savannaGold),
                      ),
                    ],
                  ),
                ],
              ),
              // Speed Dropdown
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<double>(
                    value: _playbackSpeed,
                    dropdownColor: const Color(0xFF0E221B),
                    icon: const Icon(Icons.arrow_drop_down, color: EcoColors.mintAccent, size: 16),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    items: [0.75, 1.0, 1.25, 1.5].map((speed) {
                      return DropdownMenuItem(value: speed, child: Text('${speed}x'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _playbackSpeed = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Animated Audio Waveform Canvas
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localX = details.localPosition.dx.clamp(0.0, box.size.width);
                _seek(localX / box.size.width);
              }
            },
            onTapDown: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) {
                final localX = details.localPosition.dx.clamp(0.0, box.size.width);
                _seek(localX / box.size.width);
              }
            },
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _waveAnimController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _WaveformPainter(
                      samples: _waveformSamples,
                      progressRatio: progressRatio,
                      isPlaying: _isPlaying,
                      animValue: _waveAnimController.value,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Timestamps & Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded, color: Colors.white70, size: 20),
                    onPressed: () => _seek(max(0.0, progressRatio - 0.1)),
                  ),
                  InkWell(
                    onTap: _togglePlayPause,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        gradient: EcoColors.emeraldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: EcoColors.emeraldPrimary, blurRadius: 10),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded, color: Colors.white70, size: 20),
                    onPressed: () => _seek(min(1.0, progressRatio + 0.1)),
                  ),
                ],
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Live Synchronized Transcript Highlighter Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.subtitles_rounded, color: EcoColors.savannaGold, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'LIVE SYNCHRONIZED ORAL TRANSCRIPT',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.savannaGold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5, height: 1.5),
                    children: sentences.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final text = entry.value;
                      final isCurrent = idx == currentSentenceIndex && _isPlaying;
                      final isPast = idx < currentSentenceIndex;

                      return TextSpan(
                        text: '$text. ',
                        style: TextStyle(
                          color: isCurrent
                              ? EcoColors.mintAccent
                              : (isPast ? Colors.white70 : Colors.white30),
                          fontWeight: isCurrent ? FontWeight.w800 : FontWeight.normal,
                          backgroundColor: isCurrent ? EcoColors.forestDeep.withValues(alpha: 0.6) : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> samples;
  final double progressRatio;
  final bool isPlaying;
  final double animValue;

  _WaveformPainter({
    required this.samples,
    required this.progressRatio,
    required this.isPlaying,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = samples.length;
    final totalSpacing = size.width / barCount;
    final barWidth = totalSpacing * 0.65;

    for (int i = 0; i < barCount; i++) {
      final barRatio = i / barCount;
      final isPlayed = barRatio <= progressRatio;

      double sampleHeight = samples[i] * size.height;
      if (isPlaying && (barRatio - progressRatio).abs() < 0.2) {
        sampleHeight += sin(animValue * pi * 2 + i) * 8.0;
      }
      sampleHeight = sampleHeight.clamp(6.0, size.height);

      final left = i * totalSpacing;
      final top = (size.height - sampleHeight) / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, sampleHeight),
        const Radius.circular(3),
      );

      final paint = Paint()
        ..color = isPlayed
            ? EcoColors.mintAccent
            : (barRatio <= progressRatio + 0.05
                ? EcoColors.savannaGold
                : Colors.white.withValues(alpha: 0.25));

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progressRatio != progressRatio ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.animValue != animValue;
  }
}
