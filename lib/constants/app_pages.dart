import 'package:get/route_manager.dart';

import '../views/genealogy-setting/genealogy-setting.binding.dart';
import '../views/genealogy-setting/genealogy-setting.screen.dart';
import '../views/genealogy/genealogy.binding.dart';
import '../views/genealogy/genealogy.screen.dart';
import '../views/church/church.binding.dart';
import '../views/church/church.screen.dart';
import '../views/event/event.binding.dart';
import '../views/event/event.screen.dart';
import '../views/introduce/introduce.binding.dart';
import '../views/introduce/introduce.screen.dart';
import '../views/event-detail/event-detail.binding.dart';
import '../views/event-detail/event-detail.screen.dart';
import '../views/family_tree/family-tree.binding.dart';
import '../views/family_tree/family-tree.screen.dart';
import '../views/feed/feed.binding.dart';
import '../views/feed/feed.screen.dart';
import '../views/fund/fund.binding.dart';
import '../views/fund/fund.screen.dart';
import '../views/home/home.binding.dart';
import '../views/message/message.binding.dart';
import '../views/message_detail/message_detail.binding.dart';
import '../views/message_detail/message_detail.screen.dart';
import '../views/notification/notification.binding.dart';
import '../views/pedigree/pedigree.binding.dart';
import '../views/pedigree/pedigree.screen.dart';
import '../views/profile/profile.binding.dart';
import '../views/tree_member/tree-member.binding.dart';
import '../views/tree_member/tree-member.screen.dart';
import '../views/vote/vote.binding.dart';
import '../views/vote/vote.screen.dart';
import '../views/chat-bot/chatbot.binding.dart';
import '../views/chat-bot/chatbot.screen.dart';
import '../views/calendar/calendar.binding.dart';
import '../views/dashboard/dashboard.binding.dart';
import '../views/dashboard/dashboard.screen.dart';
import '../views/feed-detail/feed.detail.binding.dart';
import '../views/feed-detail/feed.detail.screen.dart';
import '../views/fund-detail/fund-detail.binding.dart';
import '../views/fund-detail/fund-detail.screen.dart';
import '../views/login/login.binding.dart';
import '../views/login/login.screen.dart';
import '../views/register/register.binding.dart';
import '../views/register/register.screen.dart';
import '../views/splash/splash.binding.dart';
import '../views/splash/splash.screen.dart';
import '../views/vote-detail/vote-detail.binding.dart';
import '../views/vote-detail/vote-detail.screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static List<GetPage> pages = <GetPage>[
    GetPage(
      binding: SplashBinding(),
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      bindings: [
        DashboardBinding(),
        HomeBinding(),
        CalendarBinding(),
        MessageBinding(),
        NotificationBinding(),
        ProfileBinding()
      ],
      name: AppRoutes.dashBoard,
      page: () => DashboardScreen(),
    ),
    GetPage(
      binding: LoginBinding(),
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      binding: RegisterBinding(),
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      binding: FamilyTreeBinding(),
      name: AppRoutes.familyTree,
      page: () => FamilyTreeScreen(),
    ),
    GetPage(
      binding: TreeMemberBinding(),
      name: AppRoutes.treeMember,
      page: () => const TreeMemberScreen(),
    ),
    GetPage(
      binding: MessageDetailBinding(),
      name: AppRoutes.messageDetail,
      page: () => const MessageDetailScreen(),
    ),
    GetPage(
      binding: PedigreeBinding(),
      name: AppRoutes.pedigree,
      page: () => const PedigreeScreen(),
    ),
    GetPage(
      binding: FeedBinding(),
      name: AppRoutes.feed,
      page: () => const FeedScreen(),
    ),
    GetPage(
      binding: FeedDetailBinding(),
      name: AppRoutes.feedDetail,
      page: () => FeedDetailScreen(),
    ),
    GetPage(
      binding: FundBinding(),
      name: AppRoutes.fund,
      page: () => const FundScreen(),
    ),
    GetPage(
      binding: FundDetailBinding(),
      name: AppRoutes.fundDetail,
      page: () => const FundDetailScreen(),
    ),
    GetPage(
      binding: VoteBinding(),
      name: AppRoutes.vote,
      page: () => const VoteScreen(),
    ),
    GetPage(
      binding: VoteDetailBinding(),
      name: AppRoutes.voteDetail,
      page: () => const VoteDetailScreen(),
    ),
    GetPage(
      binding: ChatBotBinding(),
      name: AppRoutes.chatbot,
      page: () => const ChatBotScreen(),
    ),
    GetPage(
      binding: ChurchBinding(),
      name: AppRoutes.church,
      page: () => const ChurchScreen(),
    ),
    GetPage(
      binding: EventBinding(),
      name: AppRoutes.event,
      page: () => const EventScreen(),
    ),
    GetPage(
      binding: EventDetailBinding(),
      name: AppRoutes.eventDetail,
      page: () => const EventDetailScreen(),
    ),
    GetPage(
      binding: IntroduceBinding(),
      name: AppRoutes.introduce,
      page: () => const IntroduceScreen(),
    ),
    GetPage(
      binding: GenealogyBinding(),
      name: AppRoutes.genealogy,
      page: () => const GenealogyScreen(),
    ),
    GetPage(
      binding: GenealogySettingBinding(),
      name: AppRoutes.genealogySetting,
      page: () => const GenealogySettingScreen(),
    ),
  ];
}
