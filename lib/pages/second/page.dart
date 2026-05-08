import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class SecondPage extends HookWidget {
  const SecondPage({super.key, this.queryParams = const {}});

  final Map<String, String> queryParams;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new, const []);
    final count = useState(0);

    final label = queryParams['message'] ?? 'カウント';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('2画面目')),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(label),
            const SizedBox(height: 16),
            Text(
              '${count.value}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: .center,
              children: [
                IconButton.outlined(
                  onPressed: () => count.value--,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 24),
                IconButton.outlined(
                  onPressed: () => count.value++,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
