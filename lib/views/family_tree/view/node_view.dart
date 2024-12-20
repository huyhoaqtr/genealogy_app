import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';
import 'package:getx_app/utils/string/string.dart';

import '../family-tree.controller.dart';
import 'add_user.bottomsheet.dart';
import 'add_user.controller.dart';

class InteractiveNode extends StatelessWidget {
  final TreeMember block;
  final FamilyTreeController controller;

  const InteractiveNode({
    super.key,
    required this.block,
    required this.controller,
  });

  void _showEditUserBottomSheet(AddUserMode mode, TreeMember selectedBlock) {
    Get.lazyPut(() => AddUserController(
          mode: mode,
          sheetMode: SheetMode.EDIT,
          selectedTreeMember: selectedBlock,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => AddUserBottomSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.delete<AddUserController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    return Positioned(
      left: (block.positionX ?? 0.0) -
          ((controller.calculateSize(block.level!) *
                  (block.couple!.length + 1)) /
              2),
      top: (block.positionY ?? 0.0) -
          (controller.calculateSize(block.level!) / 2 / 2),
      child: GestureDetector(
        onPanUpdate: (details) {
          controller.updatePosition(block.sId!, details.delta);
        },
        onPanEnd: (details) => {controller.generateTree()},
        child: SizedBox(
            width: controller.calculateSize(block.level!) *
                (block.couple!.length + 1),
            height: controller.calculateSize(block.level!) / 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (block.couple != null) ...[
                  for (int i = 0; i < block.couple!.length; i++)
                    if (i < (block.couple!.length / 2).ceil())
                      _buildNodeView(context, block.couple![i]),
                ],
                _buildNodeView(context, block),
                if (block.couple != null) ...[
                  for (int i = (block.couple!.length / 2).ceil();
                      i < block.couple!.length;
                      i++)
                    _buildNodeView(context, block.couple![i]),
                ],
              ],
            )),
      ),
    );
    // });
  }

  Widget _buildNodeView(BuildContext context, TreeMember nodeBlock) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showEditUserBottomSheet(
          nodeBlock.level == 1 ? AddUserMode.ROOT : AddUserMode.CHILD,
          nodeBlock,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0XFFFFFDED),
              image: DecorationImage(
                image: AssetImage(
                  nodeBlock.gender == "MALE"
                      ? 'assets/images/img_13.png'
                      : 'assets/images/img_14.png',
                ),
                fit: BoxFit.fill,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: controller.calculateSize(nodeBlock.level!) / 7.5,
                height: controller.calculateSize(nodeBlock.level!) / 7.5,
                child: CircleAvatar(
                  radius: controller.calculateSize(nodeBlock.level!) / 2,
                  backgroundImage: NetworkImage(
                    nodeBlock.avatar != null
                        ? "${nodeBlock.avatar}"
                        : "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                  ),
                ),
              ),
              SizedBox(
                height: controller.calculateSize(nodeBlock.level!) / 50,
              ),
              SizedBox(
                width: controller.calculateSize(nodeBlock.level!) * 0.8,
                child: Text(
                  "${nodeBlock.fullName}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize:
                            (controller.calculateSize(nodeBlock.level!) * 0.05),
                        letterSpacing:
                            controller.calculateSize(nodeBlock.level!) * 0.005,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: controller.calculateSize(nodeBlock.level!) / 75,
              ),
              if (nodeBlock.title != null)
                SizedBox(
                  width: controller.calculateSize(nodeBlock.level!) * 0.8,
                  child: Text(
                    "(${nodeBlock.title})",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize:
                              (controller.calculateSize(nodeBlock.level!) *
                                  0.04),
                          letterSpacing:
                              controller.calculateSize(nodeBlock.level!) *
                                  0.005,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                width: controller.calculateSize(nodeBlock.level!) * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      nodeBlock.dateOfBirth != null
                          ? formatDateTimeFromString(nodeBlock.dateOfBirth!)
                          : "?/?/?",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize:
                                (controller.calculateSize(nodeBlock.level!) *
                                    0.03),
                            letterSpacing:
                                controller.calculateSize(nodeBlock.level!) *
                                    0.005,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: controller.calculateSize(nodeBlock.level!) / 50,
                    ),
                    Text(
                      "-",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize:
                                (controller.calculateSize(nodeBlock.level!) *
                                    0.03),
                            letterSpacing:
                                controller.calculateSize(nodeBlock.level!) *
                                    0.005,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: controller.calculateSize(nodeBlock.level!) / 50,
                    ),
                    Text(
                      nodeBlock.dateOfDeath != null
                          ? formatDateTimeFromString(nodeBlock.dateOfDeath!)
                          : "?/?/?",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontSize:
                                (controller.calculateSize(nodeBlock.level!) *
                                    0.03),
                            letterSpacing:
                                controller.calculateSize(nodeBlock.level!) *
                                    0.005,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
