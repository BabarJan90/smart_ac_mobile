import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/orchestrator/cubit/orchestrator_cubit.dart';
import 'package:smart_ac/features/orchestrator/view/orchestrator_result_view.dart';

class OrchestratorScreen extends StatefulWidget {
  const OrchestratorScreen({super.key});

  @override
  State<OrchestratorScreen> createState() => _OrchestratorScreenState();
}

class _OrchestratorScreenState extends State<OrchestratorScreen> {
  final _clientController = TextEditingController(text: 'Smith & Associates');

  @override
  void dispose() {
    _clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OrchestratorCubit, OrchestratorState>(
        listener: (context, state) {
          if (state is OrchestratorResetSuccess) {
            Fluttertoast.showToast(
              msg: 'Demo reset! 50 fresh transactions loaded.',
              backgroundColor: Colors.green,
              textColor: AppTheme.textPrimary,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildControls(state),
              const SizedBox(height: 24),
              if (state is OrchestratorRunning) _buildRunningIndicator(),
              if (state is OrchestratorError) _buildError(state.message),
              if (state is OrchestratorLoaded)
                OrchestratorResultView(result: state.result),
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
          color: AppTheme.accent.withAlpha(38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.psychology, color: AppTheme.accent, size: 22),
      ),
      const SizedBox(width: 12),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orchestrator Agent',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Sense → Plan → Act → Report',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sense: reads accounts',
                style: TextStyle(color: AppTheme.textSecond, fontSize: 10),
              ),

              Text(
                'Plan: decides which agents to run',
                style: TextStyle(color: AppTheme.textSecond, fontSize: 10),
              ),

              Text(
                'Act: executes AI agents automatically',
                style: TextStyle(color: AppTheme.textSecond, fontSize: 10),
              ),

              Text(
                'Report: summarises all findings',
                style: TextStyle(color: AppTheme.textSecond, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  Widget _buildInfoCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.accentGlow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.accent.withAlpha(51)),
    ),
    child: const Column(
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.accent, size: 18),
            SizedBox(width: 10),
            Text(
              'How it works',
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Give the Orchestrator a goal and it autonomously '
          'decides which agents to run. It senses the account '
          'state, plans the best course of action, and runs '
          'Junior Assist, Reviewer Assist, and Generative AI '
          'as needed and send Email alert if high risk Detected and generate reports',
          style: TextStyle(
            color: AppTheme.textSecond,
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    ),
  );

  Widget _buildControls(OrchestratorState state) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client name (optional)',
          style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _clientController,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g. Smith & Associates',
            hintStyle: const TextStyle(color: AppTheme.textSecond),
            filled: true,
            fillColor: AppTheme.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.accent),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state is OrchestratorRunning
                ? null
                : () => context.read<OrchestratorCubit>().run(
                    clientName: _clientController.text.trim().isEmpty
                        ? null
                        : _clientController.text.trim(),
                  ),
            icon: state is OrchestratorRunning
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              state is OrchestratorRunning ? 'Running...' : 'Run Orchestrator',
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is OrchestratorRunning
                ? null
                : context.read<OrchestratorCubit>().resetDb,

            child: Text('Reset Demo'),
          ),
        ),
        if (state is OrchestratorRunning) ...[
          const SizedBox(height: 12),
          const Text(
            '⏱ May take 5-15 minutes on first run.',
            style: TextStyle(color: AppTheme.textSecond, fontSize: 12),
          ),
        ],
      ],
    ),
  );

  Widget _buildRunningIndicator() => Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.accent.withAlpha(77)),
    ),
    child: const Column(
      children: [
        LinearProgressIndicator(
          backgroundColor: AppTheme.surfaceLight,
          color: AppTheme.accent,
        ),
        SizedBox(height: 16),
        Text(
          'Agents running - check terminal for live logs',
          style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildError(String message) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.danger.withAlpha(20),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.danger.withAlpha(77)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
