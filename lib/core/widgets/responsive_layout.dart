import 'package:flutter/material.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget child;

  const ResponsiveLayout({
    super.key,
    required this.sidebar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeCubit cubit) => cubit.state.isDarkMode);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return Container(
            color: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
            child: Row(
              children: [
                sidebar,
                Expanded(child: child),
              ],
            ),
          );
        } else {
          return Container(
            color: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
            child: Scaffold(
              backgroundColor: isDarkMode ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
              appBar: AppBar(
                backgroundColor: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: isDarkMode ? Colors.white : const Color(0xFF111827), // This sets hamburger icon color
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              drawer: Drawer(
                backgroundColor: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
                child: sidebar,
              ),
              body: child,
            ),
          );
        }
      },
    );
  }
}