import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taptap_task_kashif/core/services/navigation_service.dart';
import 'package:taptap_task_kashif/core/theme/app_theme.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/auth_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/product_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/theme_cubit.dart';

class ProductDashboardApp extends StatelessWidget {
  const ProductDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ProductCubit()..loadProducts()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: MaterialApp.router(
        title: 'Product Dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: NavigationService.router,
      ),
    );
  }
}