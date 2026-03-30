import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterapp/features/agendamentos/pages/agendamentos_page.dart';
import 'package:flutterapp/features/login/pages/login_page.dart';
import 'package:flutterapp/features/notificacoes/pages/notificacoes_page.dart';
import 'package:flutterapp/features/perfil/pages/perfil_page.dart';
import 'package:flutterapp/core/navigation/main_shell.dart';
import 'package:flutterapp/features/fila/pages/fila_page.dart';
import 'package:flutterapp/core/services/token_storage.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    GoRoute(
      path: '/fila/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return FilaPage(id: id!);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/agendamentos',
              builder: (context, state) {
                final reloadParam = state.uri.queryParameters['reload'];
                final uniqueKey = ValueKey(reloadParam ?? 'default');
                return AgendamentosPage(key: uniqueKey);
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notificacoes',
              builder: (context, state) => const NotificacoesPage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfil',
              builder: (context, state) => const PerfilPage(),
            ),
          ],
        ),
      ],
    ),
  ],

  redirect: (context, state) async {
    final loggedIn = await TokenStorage.getAccessToken() != null;
    final isLogin = state.matchedLocation == '/login';

    if (!loggedIn && !isLogin) return '/login';
    if (loggedIn && isLogin) return '/agendamentos';

    return null;
  },
);
