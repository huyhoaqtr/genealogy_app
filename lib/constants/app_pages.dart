import 'package:get/route_manager.dart';
import 'package:getx_app/views/change-password/change-password.binding.dart';
import 'package:getx_app/views/change-password/change-password.screen.dart';
import '../views/archive/archive.binding.dart';
import '../views/archive/archive.screen.dart';
import '../views/compass/compass.binding.dart';
import '../views/compass/compass.screen.dart';
import '../views/my-post/my-post.binding.dart';
import '../views/my-post/my-post.screen.dart';
import '../views/user-info/user-info.binding.dart';
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
import '../views/user-info/user-info.screen.dart';
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
      page: () => PedigreeScreen(),
    ),
    GetPage(
      binding: FeedBinding(),
      name: AppRoutes.feed,
      page: () => FeedScreen(),
    ),
    GetPage(
      binding: FeedDetailBinding(),
      name: AppRoutes.feedDetail,
      page: () => FeedDetailScreen(),
    ),
    GetPage(
      binding: FundBinding(),
      name: AppRoutes.fund,
      page: () => FundScreen(),
    ),
    GetPage(
      binding: FundDetailBinding(),
      name: AppRoutes.fundDetail,
      page: () => FundDetailScreen(),
    ),
    GetPage(
      binding: VoteBinding(),
      name: AppRoutes.vote,
      page: () => VoteScreen(),
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
      page: () => EventScreen(),
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
      page: () => GenealogyScreen(),
    ),
    GetPage(
      binding: GenealogySettingBinding(),
      name: AppRoutes.genealogySetting,
      page: () => GenealogySettingScreen(),
    ),
    GetPage(
      binding: UserInfoBinding(),
      name: AppRoutes.userInfo,
      page: () => const UserInfoScreen(),
    ),
    GetPage(
      binding: ChangePasswordBinding(),
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      binding: MyPostBinding(),
      name: AppRoutes.myPost,
      page: () => const MyPostScreen(),
    ),
    GetPage(
      binding: ArchiveBinding(),
      name: AppRoutes.archive,
      page: () => const ArchiveScreen(),
    ),
    GetPage(
      binding: CompassBinding(),
      name: AppRoutes.compass,
      page: () => const CompassScreen(),
    ),
  ];
}
