import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/sample.dart';
import '../../repositories/sample_repository.dart';

@immutable
class HomeState {
  const HomeState({
    this.headline = 'トップ画面',
    this.samples = const AsyncLoading(),
  });

  final String headline;
  final AsyncValue<List<Sample>> samples;

  HomeState copyWith({String? headline, AsyncValue<List<Sample>>? samples}) {
    return HomeState(
      headline: headline ?? this.headline,
      samples: samples ?? this.samples,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    _fetchSamples();
    return const HomeState();
  }

  Future<void> _fetchSamples() async {
    state = state.copyWith(samples: const AsyncLoading());
    state = state.copyWith(
      samples: await AsyncValue.guard(
        () => ref.read(sampleRepositoryProvider).fetchAll(),
      ),
    );
  }

  Future<void> reload() => _fetchSamples();

  void updateHeadline(String headline) {
    state = state.copyWith(headline: headline);
  }
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
