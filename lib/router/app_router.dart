import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/page.dart';
import '../pages/second/page.dart';

/// 画面ルート。新規ページはここに列挙子を追加し、[build] にウィジェットを返す。
enum AppRoute {
  home('/'),
  second('/second');

  const AppRoute(this.location);

  /// フルパス。query なしの遷移や [initialLocation] に使う。
  final String location;

  /// query パラメータを付けた URI 文字列を返す。
  /// [push] / [go] に渡す文字列はここで組み立てる。
  String uri({Map<String, String>? queryParameters}) {
    if (queryParameters == null || queryParameters.isEmpty) return location;
    return Uri.parse(
      location,
    ).replace(queryParameters: queryParameters).toString();
  }

  Widget build(BuildContext context, GoRouterState state) {
    switch (this) {
      case AppRoute.home:
        return const HomePage();
      case AppRoute.second:
        return SecondPage(queryParams: state.uri.queryParameters);
    }
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
