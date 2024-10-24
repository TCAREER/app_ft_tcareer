import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/index/index_controller.dart';
import 'package:app_tcareer/src/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/user/usercases/connection_use_case.dart';
import 'package:app_tcareer/src/routes/index_route.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ably_flutter/ably_flutter.dart' as ably;

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends ConsumerState<IndexPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Future.microtask(()async{
    //   final routeState = GoRouterState.of(context);
    //   if(routeState.fullPath?.contains("conversation") == true){
    //     await ref.read(conversationControllerProvider).onInit().then((val) {
    //       print(">>>>>>>>>>running listen");
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appLifecycleNotifier = ref.read(appLifecycleProvider.notifier);
      final routeState = GoRouterState.of(context);
      await appLifecycleNotifier.updateState(state, ref, routeState);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': PhosphorIconsThin.house,
        'activeIcon': PhosphorIconsFill.house,
        'route': 'home',
        "label": "Trang chủ"
      },
      {
        'icon': PhosphorIconsThin.bagSimple,
        'activeIcon': PhosphorIconsFill.bagSimple,
        'route': 'jobs',
        "label": "Công việc"
      },
      {
        'icon': PhosphorIconsThin.plusSquare,
        'activeIcon': PhosphorIconsThin.plusSquare,
        'route': 'posting',
        "label": "Tạo mới"
      },
      {
        'icon': PhosphorIconsThin.chatCircleText,
        'activeIcon': PhosphorIconsFill.chatCircleText,
        'route': 'conversation',
        "label": "Tin nhắn"
      },
      {
        'icon': PhosphorIconsThin.userCircle,
        'activeIcon': PhosphorIconsFill.userCircle,
        'route': 'user',
        "label": "Tài khoản"
      },
    ];
    final state = ref.watch(indexControllerProvider);

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: Visibility(
        visible: state == true,
        child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // selectedItemColor: Colors.black,
            // unselectedItemColor: Colors.grey,
            // unselectedLabelStyle: TextStyle(fontSize: 10),
            // selectedLabelStyle: TextStyle(fontSize: 10),
            onTap: (index) {
              if (index == 5) return;
              if (index != 2) {
                if (index == widget.shell.currentIndex) {
                  final GoRouter router = GoRouter.of(context);
                  String currentRoute =
                      router.routeInformationProvider.value.uri.toString();
                  String route = items[index]['route'];
                  print(">>>>>>>>>>>>>>>>A");
                  context.goNamed(route, extra: "reload");
                } else {
                  widget.shell.goBranch(index);
                }
              } else {
                context.pushNamed("posting");
              }
            },
            currentIndex: widget.shell.currentIndex,
            items: items.asMap().entries.map((entry) {
              final item = entry.value;
              final index = entry.key;
              return BottomNavigationBarItem(
                  icon: PhosphorIcon(item['icon']),
                  activeIcon: PhosphorIcon(item['activeIcon']),
                  label: item['label']);
            }).toList()),
      ),
    );
  }

  Widget notificationIcon(WidgetRef ref, {bool active = false}) {
    final notificationController = ref.watch(notificationControllerProvider);
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: notificationController.unReadNotificationsStream(),
        builder: (context, snapshot) {
          return badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -8),
            showBadge: snapshot.data?.isNotEmpty == true ? true : false,
            ignorePointer: false,
            badgeContent: Text(
              snapshot.data?.length.toString() ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.blue),
            child: Visibility(
              visible: active != true,
              replacement: PhosphorIcon(
                PhosphorIconsFill.bell,
              ),
              child: PhosphorIcon(
                PhosphorIconsThin.bell,
              ),
            ),
          );
        });
  }
}

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState> {
  AppLifecycleNotifier() : super(AppLifecycleState.resumed);

  Future<void> updateState(
      AppLifecycleState state, WidgetRef ref, GoRouterState routeState) async {
    this.state = state; // Cập nhật trạng thái
    final connectionUseCase = ref.read(connectionUseCaseProvider);
    final userUtil = ref.watch(userUtilsProvider);
    bool isAuthenticated = await userUtil.isAuthenticated();
    final chatUseCase = ref.read(chatUseCaseProvider);
    if (!isAuthenticated) return;
    print(">>>>>>>>>>state: $state");
    if (state == AppLifecycleState.paused) {
      // if (isAuthenticated) {
      await connectionUseCase.setUserOfflineStatus();
      // await chatUseCase.disconnect();
      // }
    } else if (state == AppLifecycleState.resumed) {
      // print(">>>>>>>>app is forceground");
      bool isChatRoute =
          routeState.fullPath?.contains("conversation") == true ||
              routeState.fullPath?.startsWith("/conversation/chat") == true;
      print(">>>>>>>>>>isChatRoute: $isChatRoute");
      if (isChatRoute) {
        await connectionUseCase.setUserOnlineStatusInMessage();
        // await ref.read(conversationControllerProvider).listenAblyConnected(
        //     handleChannelStateChange: (connectionState) async {
        //       print(">>>>>>>state: ${connectionState.event}");
        //       if (connectionState.event == ably.ConnectionEvent.closed) {
        //         await ref.read(conversationControllerProvider).initializeAbly();
        //       }
        //       if (connectionState.event == ably.ConnectionEvent.connected) {
        //         await ref
        //             .read(conversationControllerProvider)
        //             .listenAllConversation();
        //       }
        //     });
        // await con

        print(">>>>>>>>>>1");
      } else {
        await connectionUseCase.setUserOnlineStatus();
      }
    } else if (state == AppLifecycleState.inactive) {
      await connectionUseCase.setUserOfflineStatus();
    }
  }
}

final appLifecycleProvider =
    StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>((ref) {
  return AppLifecycleNotifier();
});
