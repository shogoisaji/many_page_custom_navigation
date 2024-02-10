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
        backgroundColor: Colors.red[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
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
          return const Center(
            child: Text('home', style: TextStyle(fontSize: 60.0, color: Colors.white, fontWeight: FontWeight.bold)),
          );
        },
      ),
      GoRoute(
        path: '/list',
        builder: (BuildContext context, GoRouterState state) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.green[100],
              child: const Center(
                  child: Text(
                'list',
                style: TextStyle(fontSize: 60.0, color: Colors.white, fontWeight: FontWeight.bold),
              )));
        },
      ),
      GoRoute(
        path: '/account',
        builder: (BuildContext context, GoRouterState state) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.yellow[100],
              child: const Center(
                  child: Text('account',
                      style: TextStyle(fontSize: 60.0, color: Colors.white, fontWeight: FontWeight.bold))));
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.blue[100],
              child: const Center(
                  child: Text('settings',
                      style: TextStyle(fontSize: 60.0, color: Colors.white, fontWeight: FontWeight.bold))));
        },
      ),
    ],
  ),
]);
