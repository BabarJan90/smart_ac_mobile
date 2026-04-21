import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_ac/app_theme.dart';
import 'package:smart_ac/di/injector.dart';

import 'features/audit_log/cubit/audit_log_cubit.dart';
import 'features/audit_log/screen/audit_log_screen.dart';
import 'features/dashboard/cubit/dashboard_cubit.dart';
import 'features/dashboard/screen/dashboard_screen.dart';
import 'features/documents/cubit/documents_cubit.dart';
import 'features/documents/screen/documents_screen.dart';
import 'features/orchestrator/cubit/orchestrator_cubit.dart';
import 'features/orchestrator/screen/orchestrator_screen.dart';
import 'features/speech_screen/cubit/speech_cubit.dart';
import 'features/speech_screen/speech_screen.dart';
import 'features/transactions/cubit/transactions_cubit.dart';
import 'features/transactions/screen/transactions_screen.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();

  runApp(const SmartACApp());
}

class SmartACApp extends StatelessWidget {
  const SmartACApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SmartAC',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: const AppShell(),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final _destinations = const [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Transactions',
    ),
    NavigationItem(
      icon: Icons.psychology_outlined,
      selectedIcon: Icons.psychology,
      label: 'Orchestrator',
    ),
    NavigationItem(
      icon: Icons.description_outlined,
      selectedIcon: Icons.description,
      label: 'Documents',
    ),
    NavigationItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'Audit Log',
    ),
    if (!kIsWeb)
      NavigationItem(
        icon: Icons.mic_none,
        selectedIcon: Icons.mic,
        label: 'Assistant',
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DashboardCubit>()),
        BlocProvider(create: (_) => getIt<TransactionsCubit>()),
        BlocProvider(create: (_) => getIt<OrchestratorCubit>()),
        BlocProvider(create: (_) => getIt<DocumentsCubit>()),
        BlocProvider(create: (_) => getIt<AuditLogCubit>()),
        if (!kIsWeb) BlocProvider(create: (_) => getIt<SpeechCubit>()),
      ],
      child: isWide ? _buildWideLayout() : _buildMobileLayout(),
    );
  }

  Widget _currentScreen() => switch (_selectedIndex) {
    0 => const DashboardScreen(),
    1 => const TransactionsScreen(),
    2 => const OrchestratorScreen(),
    3 => const DocumentsScreen(),
    4 => const AuditLogScreen(),
    5 => const SpeechScreen(),

    _ => const DashboardScreen(),
  };

  Widget _buildWideLayout() => Scaffold(
    body: Row(
      children: [
        Container(
          color: AppTheme.surface,
          child: NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            extended: MediaQuery.of(context).size.width > 1000,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGlow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: AppTheme.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (MediaQuery.of(context).size.width > 1000)
                    const Text(
                      'SmartAC',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            destinations: _destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _buildScreenWithHeader()),
      ],
    ),
  );

  Widget _buildMobileLayout() => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.accentGlow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance,
              color: AppTheme.accent,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _destinations[_selectedIndex].label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    body: _currentScreen(),
    bottomNavigationBar: NavigationBar(
      labelTextStyle: WidgetStateProperty.all(TextStyle(fontSize: 8)),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      backgroundColor: AppTheme.surface,
      indicatorColor: AppTheme.accentGlow,
      destinations: _destinations
          .map(
            (d) => NavigationDestination(
              icon: Icon(d.icon, color: AppTheme.textSecond),
              selectedIcon: Icon(d.selectedIcon, color: AppTheme.accent),
              label: d.label,
            ),
          )
          .toList(),
    ),
  );

  Widget _buildScreenWithHeader() => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border)),
        ),
        child: Row(
          children: [
            Text(
              _destinations[_selectedIndex].label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.success.withAlpha(77)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Backend connected',
                    style: TextStyle(
                      color: AppTheme.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Expanded(child: _currentScreen()),
    ],
  );
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
