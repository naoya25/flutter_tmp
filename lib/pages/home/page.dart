import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/api.dart';
import '../../router/app_router.dart';
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
      body: state.samples.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          error: error,
          onRetry: () => ref.read(homeNotifierProvider.notifier).reload(),
        ),
        data: (samples) => _SampleList(samples: samples),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushRoute(
          AppRoute.second,
          queryParameters: {'message': 'ホームから渡したメッセージ'},
        ),
        child: const Icon(Icons.arrow_forward),
      ),
    );
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
      ApiHttpException(:final statusCode) when statusCode == 401 =>
        'ログインしてください',
      ApiHttpException(:final statusCode) when statusCode == 404 =>
        'データが見つかりませんでした',
      ApiHttpException() => 'サーバーエラーが発生しました',
      ApiNetworkException() => 'ネットワークに接続できません',
      ApiTimeoutException() => 'タイムアウトしました',
      _ => 'エラーが発生しました',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('再読み込み')),
        ],
      ),
    );
  }
}
