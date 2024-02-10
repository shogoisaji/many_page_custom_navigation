import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:many_page_custom_navigation/initial_page.dart';
import 'package:many_page_custom_navigation/navigation_items.dart';
import 'package:many_page_custom_navigation/pinball_page.dart';

final GoRouter router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      return const InitialPage();
    },
  ),

  /// bottomNavigationBar Route
  ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      /// tap callback & navigation
      void handleOnTap(tappedIndex) {
        for (NavigationItems item in NavigationItems.values) {
          if (tappedIndex == item.index) {
            context.go(item.route);
          }
        }
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: const Text('Custom NavBar Demo'),
        ),
        body: Stack(
          children: [child, PinballPage()],
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('home'),
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('Go To Top Page'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
      GoRoute(
        path: '/list',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('list'));
        },
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('account'));
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return const Center(child: Text('settings'));
        },
      ),
    ],
  ),
]);
