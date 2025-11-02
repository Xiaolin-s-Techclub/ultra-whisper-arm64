import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_service.dart';
import 'floating_overlay.dart';
import 'settings_window.dart';

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppService>(
      builder: (context, appService, child) {
        final state = appService.state;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Show either the floating overlay or settings window
              if (state.isSettingsWindowOpen)
                // Settings view with full screen background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1A1A1A),
                        const Color(0xFF2D2D2D).withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Title bar area for settings
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Text(
                              'UltraWhisper Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                appService.closeSettingsWindow();
                              },
                            ),
                          ],
                        ),
                      ),
                      // Settings content
                      const Expanded(
                        child: SettingsWindow(),
                      ),
                    ],
                  ),
                )
              else
                // Regular floating overlay
                const FloatingOverlay(),
            ],
          ),
        );
      },
    );
  }
}