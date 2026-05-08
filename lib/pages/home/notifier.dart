import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/sample.dart';
import '../../repositories/sample_repository.dart';

@immutable
class HomeState {
  const HomeState({
    this.headline = 'トップ画面',
    this.samples = const [],
    this.isLoading = true,
    this.isError = false,
  });

  final String headline;
  final List<Sample> samples;
  final bool isLoading;
  final bool isError;

  HomeState copyWith({
    String? headline,
    List<Sample>? samples,
    bool? isLoading,
    bool? isError,
  }) => HomeState(
    headline: headline ?? this.headline,
    samples: samples ?? this.samples,
    isLoading: isLoading ?? this.isLoading,
    isError: isError ?? this.isError,
  );
}

class HomeNotifier extends Notifier<HomeState> {
  late final SampleRepository _repository;

  @override
  HomeState build() {
    _repository = ref.read(sampleRepositoryProvider);
    Future.microtask(_fetchSamples);
    return const HomeState();
  }

  Future<void> _fetchSamples() async {
    state = state.copyWith(isLoading: true, isError: false);
    try {
      final samples = await _repository.fetchAll();
      state = state.copyWith(samples: samples, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }

  Future<void> reload() => _fetchSamples();

  void updateHeadline(String headline) {
    state = state.copyWith(headline: headline);
  }
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
