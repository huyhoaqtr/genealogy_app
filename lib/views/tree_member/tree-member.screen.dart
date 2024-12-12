import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';

import 'tree-member.controller.dart';

class TreeMemberScreen extends GetView<TreeMemberController> {
  const TreeMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.member.value.name))),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildMemberImage(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.getFromGallery,
                        child: Container(
                          height: 28.w,
                          width: 28.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 16.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40.h,
        margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        child: CustomButton(
          text: "Xong",
          onPressed: () {
            Stopwatch stopwatch = Stopwatch()..start();
            // controller.onUpdate(
            //   controller.familyTreeController.member.value!,
            //   controller.member.value.id,
            // );
            stopwatch.stop();
            print("onUpdate took: ${stopwatch.elapsedMilliseconds}ms");
          },
        ),
      ),
    );
  }

  Widget _buildMemberImage() {
    return Container(
        width: 100.w,
        height: 100.w,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          border: Border.all(color: AppColors.primaryColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Obx(() {
            final file = controller.croppedData.value;
            final imageUrl = controller.member.value.img;

            if (file != null) {
              return Image.file(
                File(file.path),
                fit: BoxFit.cover,
              );
            } else if (imageUrl.isNotEmpty) {
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              );
            } else {
              return const Icon(Icons.person, size: 150);
            }
          }),
        ));
  }
}
