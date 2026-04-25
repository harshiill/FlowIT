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

  @override
  Widget build(BuildContext context) {
    ref.listen(flowitControllerProvider.select((value) => value.errorMessage), (_, next) {
      if (next == null || next.isEmpty) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next)));
    });

    final pages = const [
      DashboardScreen(),
      ControlsScreen(),
      AnalyticsScreen(),
      ConnectionScreen(),
    ];

    return MaterialApp(
      title: 'FlowIt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFD8F2FF), Color(0xFFF8FDFF), Color(0xFFEDF7FF)],
            ),
          ),
          child: SafeArea(
            child: IndexedStack(index: _index, children: pages),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Controls'),
            NavigationDestination(icon: Icon(Icons.query_stats_outlined), selectedIcon: Icon(Icons.query_stats), label: 'Analytics'),
            NavigationDestination(icon: Icon(Icons.wifi_tethering_outlined), selectedIcon: Icon(Icons.wifi_tethering), label: 'Connection'),
          ],
        ),
      ),
    );
  }
}
