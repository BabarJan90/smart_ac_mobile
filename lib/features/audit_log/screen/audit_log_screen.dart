import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/features/audit_log/cubit/audit_log_cubit.dart';
import 'package:smart_ac/features/audit_log/view/audit_entry_view.dart';
import 'package:smart_ac/widgets.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuditLogCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildGdprBanner(),
          Expanded(
            child: BlocBuilder<AuditLogCubit, AuditLogState>(
              builder: (context, state) {
                return switch (state) {
                  AuditLogInitial() => const SizedBox.shrink(),
                  AuditLogLoading() => _buildLoading(),
                  AuditLogLoaded() => _buildList(state),
                  AuditLogError() => _buildError(state.message),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGdprBanner() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    color: AppTheme.success.withAlpha(20),
    child: const Row(
      children: [
        Icon(Icons.verified_user, color: AppTheme.success, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'GDPR Compliant - every AI decision is logged '
            'with full justification',
            style: TextStyle(color: AppTheme.success, fontSize: 12),
          ),
        ),
      ],
    ),
  );

  Widget _buildLoading() => ListView(
    padding: const EdgeInsets.all(16),
    children: List.generate(
      5,
      (_) => const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: LoadingCard(height: 80),
      ),
    ),
  );

  Widget _buildError(String message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: AppTheme.textSecond),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => context.read<AuditLogCubit>().load(),
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
        ),
      ],
    ),
  );

  Widget _buildList(AuditLogLoaded state) {
    if (state.entries.items.isEmpty) {
      return const EmptyState(
        icon: Icons.history,
        title: 'No audit entries yet',
        subtitle: 'AI decisions will appear here\nonce you run the agents',
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<AuditLogCubit>().load(),
      color: AppTheme.accent,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.entries.items.length,
        itemBuilder: (ctx, i) => AuditEntryView(entry: state.entries.items[i]),
      ),
    );
  }
}
