import 'package:get/get.dart';
import 'package:getx_app/views/genealogy/genealogy.controller.dart';

import '../../resources/api/tribe.api.dart';
import '../../utils/widgets/loading/loading.controller.dart';

class GenealogySettingController extends GetxController {
  final GenealogyController genealogyController = Get.find();
  final LoadingController loadingController = Get.find();

  Future<void> deletePdfPage(String pageDataId) async {
    loadingController.show();
    await Future.delayed(const Duration(milliseconds: 200));
    final response = await TribeAPi().deletePageDataToGenealogy(
      genealogyId: genealogyController.genealogyData.value.sId ?? "",
      pageDataId: pageDataId,
    );
    if (response.statusCode == 200) {
      final dataList = genealogyController.genealogyData.value.data!;
      final index = dataList.indexWhere((item) => item.sId == pageDataId);

      if (index != -1) {
        dataList.removeAt(index);
      }
      genealogyController.genealogyData.refresh();
      await genealogyController.rerenderPdf();
      genealogyController.pdfData.refresh();
    }

    loadingController.hide();
  }
}
