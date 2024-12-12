import 'package:get/get.dart';
import 'package:getx_app/resources/models/member.model.dart';
import 'package:getx_app/views/family_tree/family-tree.controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class TreeMemberController extends GetxController {
  late Rx<Member> member;
  late Rx<CroppedFile?> croppedData;

  final FamilyTreeController familyTreeController =
      Get.find<FamilyTreeController>();

  @override
  void onInit() {
    super.onInit();
    member = (Get.arguments['member'] as Member).obs;
    croppedData = Rx<CroppedFile?>(null);
  }

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      cropImage(pickedFile.path);
    }
  }

  void cropImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      croppedData.value = croppedFile;
    }
  }

  // void onUpdate(Member rootMember, int id) {
  //   if (rootMember.id == id) {
  //     final updatedRoot = rootMember.copyWith(name: "Huy Hoang");
  //     familyTreeController.member.value = updatedRoot;
  //     print("SUCCESS");

  //     return Get.back();
  //   }

  //   List<Member> updatedChildren = rootMember.children.map((child) {
  //     onUpdate(child, id);
  //     return familyTreeController.member.value!;
  //   }).toList();

  //   if (updatedChildren != rootMember.children) {
  //     final updatedRoot = rootMember.copyWith(children: updatedChildren);
  //     familyTreeController.member.value = updatedRoot;
  //   }
  // }
}
