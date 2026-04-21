import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/speech_screen/cubit/speech_cubit.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _transcribedText = '';
  bool _requestSent = false;

  @override
  void initState() {
    super.initState();
    _speech.initialize();
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
      _transcribedText = '';
      _requestSent = false;
    });
    context.read<SpeechCubit>().reset();

    await _speech.listen(
      onResult: (result) {
        setState(() => _transcribedText = result.recognizedWords);
        if (result.finalResult) _stopListening();
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 5),
      localeId: 'en_GB',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_transcribedText.isNotEmpty) {
      context.read<SpeechCubit>().getRecommendation(text: _transcribedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SpeechCubit, SpeechState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildMicButton(),
              const SizedBox(height: 24),
              if (_transcribedText.isNotEmpty) _buildTranscribedText(),
              const SizedBox(height: 24),
              switch (state) {
                SpeechInitial() => const SizedBox.shrink(),
                SpeechLoading() => const Center(
                  child: CircularProgressIndicator(color: AppTheme.accent),
                ),
                SpeechLoaded() => _buildResult(state),
                SpeechError() => _buildError(state.message),
              },
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.accentGlow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.mic, color: AppTheme.accent, size: 22),
      ),
      const SizedBox(width: 12),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SmartAC Assistant',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Ask me about your accounts',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
          ),
        ],
      ),
    ],
  );

  Widget _buildMicButton() => Column(
    children: [
      Center(
        child: GestureDetector(
          onTap: _isListening ? _stopListening : _startListening,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening
                  ? AppTheme.danger.withAlpha(26)
                  : AppTheme.accentGlow,
              border: Border.all(
                color: _isListening ? AppTheme.danger : AppTheme.accent,
                width: 2,
              ),
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic,
              size: 42,
              color: _isListening ? AppTheme.danger : AppTheme.accent,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        _isListening
            ? 'Listening... (auto stops after 5s pause)'
            : 'Tap to speak - max 15 seconds',
        style: const TextStyle(color: AppTheme.textSecond, fontSize: 12),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),

      if (_isListening)
        ElevatedButton.icon(
          onPressed: _stopListening,
          icon: const Icon(Icons.send, size: 16),
          label: const Text('Ready - Send'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
          ),
        ),
    ],
  );

  Widget _buildTranscribedText() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.accent.withAlpha(51)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You said:',
          style: TextStyle(color: AppTheme.textSecond, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          '"$_transcribedText"',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );

  Widget _buildResult(SpeechLoaded state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Recommendation
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.accentGlow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accent.withAlpha(77)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.accent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'AI Recommendation',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              state.recommendation.recommendation,
              style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Recommended Services
      const Text(
        'Recommended Services',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      ...state.recommendation.services.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
              const SizedBox(width: 10),
              Text(s, style: const TextStyle(color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ),

      const SizedBox(height: 20),

      // Next Steps
      const Text(
        'Next Steps',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      ...state.recommendation.nextSteps.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_forward, color: AppTheme.accent, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s,
                  style: const TextStyle(color: AppTheme.textSecond),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 24),

      // Ask Again button
      SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            setState(() => _transcribedText = '');
            context.read<SpeechCubit>().reset();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Ask Again'),
        ),
      ),
    ],
  );

  Widget _buildError(String message) => Center(
    child: Column(
      children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: AppTheme.textSecond),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
