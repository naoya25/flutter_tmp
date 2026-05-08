import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/page.dart';
import '../pages/second/page.dart';

enum AppRoute {
  home('/'),
  second('/second');

  const AppRoute(this.location);

  final String location;

  Widget build(BuildContext context, GoRouterState state) {
    switch (this) {
      case AppRoute.home:
        return const HomePage();
      case AppRoute.second:
        return SecondPage(queryParams: state.uri.queryParameters);
    }
  }

  String uri({Map<String, String>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) return location;
    return Uri.parse(
      location,
    ).replace(queryParameters: queryParameters).toString();
  }
}

extension AppRouteNavigation on BuildContext {
  Future<T?> pushRoute<T extends Object?>(
    AppRoute route, {
    Map<String, String>? queryParameters,
  }) => push<T>(route.uri(queryParameters: queryParameters));

  void goRoute(AppRoute route, {Map<String, String>? queryParameters}) =>
      go(route.uri(queryParameters: queryParameters));
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoute.home.location,
  routes: [
    for (final route in AppRoute.values)
      GoRoute(
        path: route.location,
        builder: (context, state) => route.build(context, state),
      ),
  ],
);
