import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/auth_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/states/auth_state.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _hoveredIndex = -1;
  bool _isQuickLinkHovered = false;
  bool _isLogoutHovered = false;
  bool _isThemeHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((ThemeCubit cubit) => cubit.state.themeMode);
    final isDarkMode = themeMode == ThemeMode.dark;
    
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF1F1F1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? const Color(0xFF374151) : const Color(0xFFF1F1F1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'TT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'TapTap Dashboard',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
            child: Text(
              'MENU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),

          
          _buildMenuItem(
            index: 0,
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            isSelected: false,
            isDarkMode: isDarkMode,
            onTap: () => {},
          ),
          _buildMenuItem(
            index: 1,
            icon: Icons.shopping_cart_outlined,
            label: 'Orders',
            isSelected: false,
            isDarkMode: isDarkMode,
            onTap: () {},
          ),
          _buildMenuItem(
            index: 2,
            icon: Icons.inventory_2_outlined,
            label: 'Products',
            isSelected: true, // Products is selected
            isDarkMode: isDarkMode,
            onTap: () => context.go('/products'),
          ),
          _buildMenuItem(
            index: 3,
            icon: Icons.attach_money_outlined,
            label: 'Earnings',
            isSelected: false,
            isDarkMode: isDarkMode,
            onTap: () {},
          ),
         

          const SizedBox(height: 32),

          
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 12),
            child: Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Theme Toggle Switch
          _buildThemeToggleItem(isDarkMode),

          const Spacer(),

          // Logout button with hover
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildLogoutButton(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    final isHovered = _hoveredIndex == index;
    
    // Colors for dark/light modes
    final selectedBgColor = isDarkMode ? const Color(0xFF374151) : const Color(0xFFEEF2FF);
    final hoverBgColor = isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFF5F5F5);
    final selectedTextColor = isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF4F46E5);
    final hoverTextColor = isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF4F46E5);
    final normalTextColor = isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final normalIconColor = isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final borderColor = isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected 
                ? selectedBgColor 
                : (isHovered ? hoverBgColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: isHovered && !isSelected
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: Icon(
              icon,
              size: 20,
              color: isSelected 
                  ? selectedTextColor 
                  : (isHovered ? hoverTextColor : normalIconColor),
            ),
            title: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? selectedTextColor 
                    : (isHovered ? hoverTextColor : normalTextColor),
              ),
            ),
            trailing: isSelected
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectedTextColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : (isHovered
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: hoverTextColor.withOpacity(0.7),
                      )
                    : null),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggleItem(bool isDarkMode) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isThemeHovered = true),
      onExit: (_) => setState(() => _isThemeHovered = false),
      child: GestureDetector(
        onTap: () {
          context.read<ThemeCubit>().toggleTheme();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            color: _isThemeHovered 
                ? (isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFF5F5F5))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: _isThemeHovered
                ? Border.all(
                    color: isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB),
                    width: 1,
                  )
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 20,
              color: _isThemeHovered 
                  ? (isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF4F46E5))
                  : (isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
            ),
            title: Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _isThemeHovered 
                    ? (isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF4F46E5))
                    : (isDarkMode ? const Color(0xFFD1D5DB) : const Color(0xFF374151)),
              ),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) {
                context.read<ThemeCubit>().toggleTheme();
              },
              activeColor: const Color(0xFF60A5FA),
              activeTrackColor: const Color(0xFF1E40AF),
              inactiveThumbColor: const Color(0xFF9CA3AF),
              inactiveTrackColor: const Color(0xFFE5E7EB),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isDarkMode) {
    final logoutBgColor = isDarkMode ? const Color(0xFF7F1D1D) : const Color(0xFFFEF2F2);
    final logoutHoverBgColor = isDarkMode ? const Color(0xFF991B1B) : const Color(0xFFFEE2E2);
    final logoutBorderColor = isDarkMode ? const Color(0xFFFCA5A5) : const Color(0xFFFCA5A5);
    final logoutTextColor = isDarkMode ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626);
    final logoutHoverTextColor = isDarkMode ? const Color(0xFFFECACA) : const Color(0xFFB91C1C);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isLogoutHovered = true),
      onExit: (_) => setState(() => _isLogoutHovered = false),
      child: GestureDetector(
        onTap: () {
          // Logout
          context.read<AuthCubit>().logout();
          
          // Navigate to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go('/login?logout=true');
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _isLogoutHovered ? logoutHoverBgColor : logoutBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: logoutBorderColor,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_outlined,
                  size: 18,
                  color: _isLogoutHovered ? logoutHoverTextColor : logoutTextColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _isLogoutHovered ? logoutHoverTextColor : logoutTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}