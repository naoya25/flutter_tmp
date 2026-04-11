// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/app_router.dart';
import 'components/error_view.dart';
import 'components/loading_view.dart';
import 'notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(state.headline),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(homeNotifierProvider.notifier).reload(),
          ),
        ],
      ),
      body: _body(state, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushRoute(
          AppRoute.second,
          queryParameters: {'message': 'ホームから渡したメッセージ'},
        ),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _body(HomeState state, WidgetRef ref) {
    if (state.isLoading) return const LoadingView();
    if (state.isError) {
      return ErrorView(
        onRetry: () => ref.read(homeNotifierProvider.notifier).reload(),
      );
    }
    return _SampleList(samples: state.samples);
  }
}

class _SampleList extends StatelessWidget {
  const _SampleList({required this.samples});

  final List<dynamic> samples;

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return const Center(child: Text('データがありません'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: samples.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final sample = samples[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${sample.id}')),
          title: Text(sample.title),
        );
      },
    );
  }
}
