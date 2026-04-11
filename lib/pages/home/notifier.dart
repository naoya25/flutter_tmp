import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class HomeState {
  const HomeState({this.headline = 'トップ画面'});

  final String headline;
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState();
}

final homeNotifierProvider =
    NotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);
