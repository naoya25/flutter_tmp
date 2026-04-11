import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/app_router.dart';
import 'notifier.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new, const []);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ホーム'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.headline),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.pushRoute(
                AppRoute.second,
                queryParameters: {'message': 'ホームから渡したメッセージ'},
              ),
              child: const Text('2画面目へ'),
            ),
          ],
        ),
      ),
    );
  }
}
