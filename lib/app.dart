import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/connection/connection_screen.dart';
import 'features/controls/controls_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'state/flowit_controller.dart';

/// Main FlowIt Application
class FlowItApp extends ConsumerStatefulWidget {
  const FlowItApp({super.key});

  @override
  ConsumerState<FlowItApp> createState() => _FlowItAppState();
}

class _FlowItAppState extends ConsumerState<FlowItApp> {
  int _selectedIndex = 0;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late final ProviderSubscription<String?> _errorSubscription;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _setupErrorListener();
  }

  /// Setup error listener to show snackbar when errors occur
  void _setupErrorListener() {
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
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.space12),
                  Expanded(child: Text(next)),
                ],
              ),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {
                  _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
                },
              ),
            ),
          );
        } catch (_) {
          // Ignore if ScaffoldMessenger isn't fully ready
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
    return MaterialApp(
      title: 'FlowIt',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: _FlowItHome(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

/// Main home screen with navigation
class _FlowItHome extends StatelessWidget {
  const _FlowItHome({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  static const List<Widget> _screens = [
    DashboardScreen(),
    ControlsScreen(),
    AnalyticsScreen(),
    ConnectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFBFC), // Very light grey-blue
              Color(0xFFFFFFFF), // White
              Color(0xFFF8FAFB), // Light grey
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: _ModernNavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onIndexChanged,
      ),
    );
  }
}

/// Modern navigation bar with custom styling
class _ModernNavigationBar extends StatelessWidget {
  const _ModernNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: AppConstants.navigationBarHeight,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
              tooltip: 'Dashboard Overview',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune),
              label: 'Controls',
              tooltip: 'Device Controls',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Analytics',
              tooltip: 'Usage Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.wifi_tethering_outlined),
              selectedIcon: Icon(Icons.wifi_tethering),
              label: 'Connection',
              tooltip: 'Device Connection',
            ),
          ],
        ),
      ),
    );
  }
}
