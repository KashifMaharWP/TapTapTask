import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taptap_task_kashif/features/presentation/cubits/auth_cubit.dart';
import 'package:taptap_task_kashif/features/presentation/pages/login_page.dart';
import 'package:taptap_task_kashif/features/presentation/pages/product_detail_page.dart';
import 'package:taptap_task_kashif/features/presentation/pages/product_list_page.dart';

class NavigationService {
  // Public getter that provides access to the router
  static GoRouter get router => _router;
  
  // Lazy initialization - router is created when first accessed
  static late final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
    ],
    redirect: (context, state) {
      // Important: Use context.read() inside redirect function
      // This runs when the route is being evaluated
      final authCubit = context.read<AuthCubit>();
      final isAuthenticated = authCubit.state.isAuthenticated;
      final isLoggingIn = state.uri.toString() == '/login';
       final isLoggingOut = state.extra == 'logout'; 
       if (isLoggingOut) {
        return '/login';
      }
      
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/products';
      }

      return null;
    },
  );
}