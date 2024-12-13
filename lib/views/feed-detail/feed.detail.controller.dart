import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../resources/api/feed.api.dart';
import '../../resources/models/comment.model.dart';
import '../../resources/models/feed.model.dart';

class FeedDetailController extends GetxController {
  Rx<Feed> feed = Rx<Feed>(Feed());
  RxList<CommentFeed> comments = RxList<CommentFeed>([]);
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPages = 0.obs;
  RxBool isLoadMore = false.obs;
  Rx<CommentFeed?> parentComment = Rx<CommentFeed?>(null);
  Rx<TextEditingController> commentInputController =
      TextEditingController().obs;
  Rx<FocusNode> commentInputFocusNode = FocusNode().obs;
  final ScrollController scrollController = ScrollController();
  final LoadingController loadingController = Get.find();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['feed'] != null) {
      feed.value = Feed.fromJson(Get.arguments['feed']);
    }
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await getMoreCommentFeeds();
      }
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    if (Get.arguments != null && Get.arguments['feedId'] != null) {
      final response = await FeedApi().getFeedById(id: Get.arguments['feedId']);
      feed.value = response.data!;
    }
    await getComments();
  }

  Future<void> getComments() async {
    final response = await FeedApi().getAllFeedComment(
        page: page.value, limit: limit.value, feedId: feed.value.sId!);
    if (response.statusCode == 201) {
      comments.value += response.data?.data ?? [];
      totalPages.value = response.data?.meta?.totalPages ?? 0;
    }
  }

  Future<void> getMoreCommentFeeds() async {
    if (isLoadMore.value || page.value >= totalPages.value) return;
    try {
      page.value++;
      isLoadMore.value = true;
      getComments();
    } finally {
      isLoadMore.value = false;
    }
  }

  String getCommentParentFullName(String? parentId) {
    if (parentId == null) return '';

    // Duyệt qua các comment trong danh sách
    for (var i = 0; i < comments.length; i++) {
      // Nếu tìm thấy parentId, trả về fullName của user
      if (comments[i].sId == parentId) {
        return comments[i].user?.info?.fullName ?? '';
      }
      // Nếu comment có replies, tìm tiếp trong các replies của nó
      else if (comments[i].replies != null && comments[i].replies!.isNotEmpty) {
        // Đệ quy tìm trong các replies của comment
        final replyFullName =
            getCommentParentFullNameInReplies(parentId, comments[i].replies!);
        if (replyFullName.isNotEmpty) {
          return replyFullName; // Nếu tìm thấy, trả về fullName của reply
        }
      }
    }

    return ''; // Nếu không tìm thấy, trả về chuỗi rỗng
  }

// Hàm đệ quy để tìm trong các replies
  String getCommentParentFullNameInReplies(
      String? parentId, List<CommentFeed> replies) {
    for (var reply in replies) {
      if (reply.sId == parentId) {
        return reply.user?.info?.fullName ?? '';
      } else if (reply.replies != null && reply.replies!.isNotEmpty) {
        final replyFullName =
            getCommentParentFullNameInReplies(parentId, reply.replies!);
        if (replyFullName.isNotEmpty) {
          return replyFullName;
        }
      }
    }
    return '';
  }

  void onReplyTap(CommentFeed comment) {
    parentComment.value = comment;
    //focus comment input
    commentInputFocusNode.value.requestFocus();
  }

  void onRemoveReplyTap() {
    parentComment.value = null;
  }

  Future<void> onSendCommentTap() async {
    loadingController.show();
    final response = await FeedApi().createNewComment(
      feedId: feed.value.sId!,
      content: commentInputController.value.text,
      parentCommentId: parentComment.value?.sId,
    );
    if (response.statusCode == 200) {
      commentInputController.value.clear();
      parentComment.value = null;
      if (response.data?.parent != null) {
        for (var i = 0; i < comments.length; i++) {
          if (comments[i].sId == response.data?.parent) {
            comments[i].replies?.insert(0, response.data!);
            break;
          } else if (comments[i].replies != null &&
              comments[i].replies!.isNotEmpty) {
            _addReplyToParent(response.data!, comments[i].replies!);
          }
        }
      } else {
        comments.insert(0, response.data!);
      }
      comments.refresh();
    }
    loadingController.hide();
  }

  void _addReplyToParent(
      CommentFeed responseComment, List<CommentFeed> replies) {
    for (var reply in replies) {
      if (reply.sId == responseComment.parent) {
        reply.replies?.insert(0, responseComment);
        return; // Đã thêm vào thì thoát khỏi hàm
      } else if (reply.replies != null && reply.replies!.isNotEmpty) {
        _addReplyToParent(responseComment, reply.replies!);
      }
    }
  }
}
