# flutter_tmp

Flutter を気軽に触るための個人用テンプレート。
新しいページを試すたびにルーティングや状態管理をゼロから書かなくて済むようにするのが目的。

---

## 技術スタック

| 役割 | パッケージ |
|---|---|
| 画面遷移 | [go_router](https://pub.dev/packages/go_router) |
| 状態管理 | [hooks_riverpod](https://pub.dev/packages/hooks_riverpod) |
| ローカル状態 / Hooks | [flutter_hooks](https://pub.dev/packages/flutter_hooks) |

**方針**
- `StatefulWidget` は使わない
- ページ単位の状態 → `useState` など Flutter Hooks
- アプリ横断の状態 → `Notifier` + `NotifierProvider`（Riverpod）

---

## ディレクトリ構成

```
lib/
├── main.dart                  # ProviderScope + MaterialApp.router
├── router/
│   └── app_router.dart        # AppRoute enum / GoRouter / BuildContext 拡張
└── pages/
    └── <page_name>/
        ├── page.dart          # HookWidget or HookConsumerWidget
        └── notifier.dart      # Notifier + State + Provider（必要な場合のみ）
```

---

## 新しいページの追加手順

### 1. ファイルを作る

```
lib/pages/my_page/page.dart
lib/pages/my_page/notifier.dart  # 状態が必要な場合のみ
```

`page.dart` の最小テンプレート：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MyPage extends HookWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### 2. `AppRoute` に追加する

`lib/router/app_router.dart` の enum に 1 行追加し、`build` に `return const MyPage();` を足す。
**これだけで `GoRouter` に自動登録される。**

```dart
enum AppRoute {
  home('/'),
  second('/second'),
  myPage('/my-page');  // ← 追加

  Widget build(BuildContext context, GoRouterState state) {
    switch (this) {
      case AppRoute.home:   return const HomePage();
      case AppRoute.second: return const SecondPage();
      case AppRoute.myPage: return const MyPage();  // ← 追加
    }
  }
}
```

### 3. 遷移する

```dart
// 通常遷移
context.pushRoute(AppRoute.myPage);

// query パラメータを渡す
context.pushRoute(
  AppRoute.myPage,
  queryParameters: {'id': '42', 'label': 'hello'},
);

// スタックをリセットしてトップに戻る
context.goRoute(AppRoute.home);
```

受け取り側は `queryParams['id']` で取得できる。

---

## ルール

- `StatefulWidget` は使わない（Hooks で代替）
- パス文字列を直書きしない（`AppRoute` enum 経由で指定）
- ページをまたいで状態を共有する必要が出たら `notifier.dart` に `Notifier` を書く
