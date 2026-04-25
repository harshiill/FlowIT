import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/connection/connection_screen.dart';
import 'features/controls/controls_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'state/flowit_controller.dart';

class FlowItApp extends ConsumerStatefulWidget {
  const FlowItApp({super.key});

  @override
  ConsumerState<FlowItApp> createState() => _FlowItAppState();
}

class _FlowItAppState extends ConsumerState<FlowItApp> {
  int _index = 0;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late final ProviderSubscription<String?> _errorSubscription;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _errorSubscription = ref.listenManual<String?>(
      flowitControllerProvider.select((value) => value.errorMessage),
      (_, next) {
        if (next == null || next.isEmpty) return;
        if (next == _lastError) return;
        _lastError = next;
        if (!mounted) return;
        try {
          _scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(next),
              duration: const Duration(seconds: 5),
            ),
          );
        } catch (_) {
          // Ignore if ScaffoldMessenger not ready
        }
      },
    );
  }

  @override
  void dispose() {
    _errorSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardScreen(),
      ControlsScreen(),
      AnalyticsScreen(),
      ConnectionScreen(),
    ];

    return MaterialApp(
      title: 'FlowIt',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: _FlowItHome(
        index: _index,
        onIndexChanged: (value) => setState(() => _index = value),
        pages: pages,
      ),
    );
  }
}

class _FlowItHome extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexChanged;
  final List<Widget> pages;

  const _FlowItHome({
    required this.index,
    required this.onIndexChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD8F2FF), Color(0xFFF8FDFF), Color(0xFFEDF7FF)],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(index: index, children: pages),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onIndexChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Controls'),
          NavigationDestination(icon: Icon(Icons.query_stats_outlined), selectedIcon: Icon(Icons.query_stats), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.wifi_tethering_outlined), selectedIcon: Icon(Icons.wifi_tethering), label: 'Connection'),
        ],
      ),
    );
  }
}
