import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/resources/models/genealogy.model.dart';
import 'package:getx_app/resources/models/tribe.model.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/archive/archive.detail.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../../utils/widgets/dialog/dialog.helper.dart'; // For using Isolate

class GenealogyController extends GetxController {
  Rx<GenealogyModel> genealogyData = Rx<GenealogyModel>(GenealogyModel());
  Rx<Uint8List> pdfData = Rx<Uint8List>(Uint8List(0));
  RxList<Map<String, dynamic>> tableOfContents =
      RxList<Map<String, dynamic>>([]);
  RxBool isPdfGenerating = false.obs;
  RxInt currentPage = 0.obs;
  RxBool isUploading = false.obs;

  final DashboardController dashboardController = Get.find();
  final LoadingController loadingController = Get.find();

  @override
  void onReady() {
    super.onReady();
    getGenealogyData();
  }

  Future<void> getGenealogyData() async {
    isPdfGenerating.value = true;

    final response = await TribeAPi().getGenealogyData();
    if (response.statusCode == 200) {
      genealogyData.value = response.data!;
      await _generateAndShowPdf(response.data!);
    }
    isPdfGenerating.value = false;
  }

  Future<void> rerenderPdf() async {
    tableOfContents.value = [];
    await _generateAndShowPdf(genealogyData.value);
  }

  Future<pw.Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData.buffer.asByteData());
  }

  Future<pw.MemoryImage> loadImageFromAssets(String assetPath) async {
    final imageBytes = await rootBundle.load(assetPath);
    return pw.MemoryImage(imageBytes.buffer.asUint8List());
  }

  Future<void> _generateAndShowPdf(GenealogyModel genealogyData) async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final result = await _generatePdfInBackground(genealogyData);
      updatePdfData(result);
    } catch (e) {
      print("Error generating PDF: $e");
      DialogHelper.showToast("Failed to generate PDF.", ToastType.error);
    }
  }

  Future<Uint8List> _generatePdfInBackground(
    GenealogyModel genealogyData,
  ) async {
    final pdf = pw.Document(
        version: PdfVersion.pdf_1_5, compress: true, title: "Huy Hoang");

    final imageProvider =
        await loadImageFromAssets('./assets/images/img_18.jpeg');
    final childImageProvider =
        await loadImageFromAssets('./assets/images/pdf_bg.png');

    final border_1 = await loadImageFromAssets('./assets/images/border_1.png');
    final border_2 = await loadImageFromAssets('./assets/images/border_2.png');
    final border_3 = await loadImageFromAssets('./assets/images/border_3.png');
    final border_4 = await loadImageFromAssets('./assets/images/border_4.png');

    final davidaBoldFont = await loadFont('./assets/fonts/UTM-Davida.ttf');
    final robotoMediumFont = await loadFont('./assets/fonts/Roboto-Medium.ttf');
    final robotoBoldFont = await loadFont('./assets/fonts/Roboto-Bold.ttf');
    final notoEmojiFont = await loadFont('./assets/fonts/NotoEmoji.ttf');
    final notoColorEmojiFont =
        await loadFont('./assets/fonts/NotoColorEmoji.ttf');

    pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(0),
      build: (pw.Context context) {
        TribeModel? tribe = dashboardController.tribe.value;
        return pw.Container(
          width: double.infinity,
          height: double.infinity,
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: pw.BoxDecoration(
            image: pw.DecorationImage(
              image: imageProvider,
              fit: pw.BoxFit.fill,
            ),
          ),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "GIA PHẢ",
                  style: pw.TextStyle(
                    fontSize: 80,
                    fontWeight: pw.FontWeight.bold,
                    font: davidaBoldFont,
                    color: PdfColor.fromHex("FEA837"),
                  ),
                ),
                pw.Text(
                  ("${tribe?.name}").toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    font: davidaBoldFont,
                    color: PdfColor.fromHex("FEA837"),
                  ),
                ),
                if (tribe?.address != null)
                  pw.Text(
                    "${tribe?.address}",
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: robotoMediumFont,
                      color: PdfColor.fromHex("FEA837"),
                    ),
                  ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Tộc trưởng: ${tribe?.leader?.info?.fullName}",
                  style: pw.TextStyle(
                    fontSize: 18,
                    font: davidaBoldFont,
                    color: PdfColor.fromHex("FEA837"),
                  ),
                ),
              ]),
        );
      },
    ));

    genealogyData.data!.map(
      (data) {
        String text = data.text ?? "";
        List<String> textChunks = [];

        RegExp punctuationRegex = RegExp(r'[.!?]');

        if (text.contains('\n')) {
          textChunks = text.split('\n');
        } else if (text.contains(punctuationRegex)) {
          List<String> sentences = text.split(punctuationRegex);
          String buffer = "";

          for (String sentence in sentences) {
            String trimmedSentence = sentence.trim();

            if (buffer.isNotEmpty && (buffer + trimmedSentence).length > 150) {
              textChunks.add(buffer.trim());
              buffer = trimmedSentence; // Reset buffer
            } else {
              buffer += (buffer.isNotEmpty ? ". " : "") + trimmedSentence;
            }
          }
          if (buffer.isNotEmpty) {
            textChunks.add(buffer.trim()); // Thêm đoạn cuối
          }
        } else if (text.contains(' ')) {
          List<String> words = text.split(' ');
          String buffer = "";

          for (String word in words) {
            if ((buffer + word).length > 150) {
              textChunks.add(buffer.trim());
              buffer = word;
            } else {
              buffer += (buffer.isNotEmpty ? " " : "") + word;
            }
          }
          if (buffer.isNotEmpty) {
            textChunks.add(buffer.trim()); // Thêm đoạn cuối
          }
        } else {
          for (int i = 0; i < text.length; i += 150) {
            int end = (i + 150 < text.length) ? i + 150 : text.length;
            textChunks.add(text.substring(i, end));
          }
        }

        return pdf.addPage(pw.MultiPage(
          maxPages: 10000000,
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.all(0),
            buildBackground: (pw.Context context) => pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  image: pw.DecorationImage(
                    image: childImageProvider,
                    fit: pw.BoxFit.cover,
                  ),
                ),
                child: pw.Stack(
                  children: [
                    pw.Positioned(
                      left: 10,
                      top: 10,
                      child: pw.SizedBox(
                        width: 120,
                        child: pw.Image(
                          border_1,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                    pw.Positioned(
                      right: 10,
                      top: 10,
                      child: pw.SizedBox(
                        width: 120,
                        child: pw.Image(
                          border_2,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                    pw.Positioned(
                      left: 10,
                      bottom: 10,
                      child: pw.SizedBox(
                        width: 120,
                        child: pw.Image(
                          border_3,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                    pw.Positioned(
                      right: 10,
                      bottom: 10,
                      child: pw.SizedBox(
                        width: 120,
                        child: pw.Image(
                          border_4,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          build: (pw.Context context) {
            return [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.only(
                  top: AppSize.kPadding * 3,
                  left: AppSize.kPadding * 3.5,
                  right: AppSize.kPadding * 3.5,
                  bottom: AppSize.kPadding * 1.5,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        "${data.title}",
                        style: pw.TextStyle(
                          fontSize: 28,
                          font: robotoBoldFont,
                          color: PdfColors.black,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: AppSize.kPadding),
                    ...textChunks.map(
                      (text) => pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          bottom: AppSize.kPadding / 2,
                        ),
                        child: pw.Text(
                          text,
                          style: pw.TextStyle(
                            fontSize: 16,
                            font: robotoMediumFont,
                            fontFallback: [
                              robotoMediumFont,
                              notoEmojiFont,
                              notoColorEmojiFont,
                            ],
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          footer: (pw.Context context) {
            if (!tableOfContents.value.any((item) => item['id'] == data.sId)) {
              tableOfContents.value.add({
                'id': data.sId,
                'title': data.title,
                'pageNumber': context.pageNumber,
              });
            }

            return pw.Container(
              alignment: pw.Alignment.center,
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                "Trang ${context.pageNumber} / ${context.pagesCount}",
                style: pw.TextStyle(
                  fontSize: 12,
                  font: robotoMediumFont,
                  color: PdfColors.black,
                ),
              ),
            );
          },
        ));
      },
    ).toList();

    pdf.addPage(
      pw.MultiPage(
        maxPages: 10000000,
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(0),
          buildBackground: (pw.Context context) => pw.Container(
              width: double.infinity,
              decoration: pw.BoxDecoration(
                image: pw.DecorationImage(
                  image: childImageProvider,
                  fit: pw.BoxFit.cover,
                ),
              ),
              child: pw.Stack(
                children: [
                  pw.Positioned(
                    left: 10,
                    top: 10,
                    child: pw.SizedBox(
                      width: 120,
                      child: pw.Image(
                        border_1,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                  pw.Positioned(
                    right: 10,
                    top: 10,
                    child: pw.SizedBox(
                      width: 120,
                      child: pw.Image(
                        border_2,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                  pw.Positioned(
                    left: 10,
                    bottom: 10,
                    child: pw.SizedBox(
                      width: 120,
                      child: pw.Image(
                        border_3,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                  pw.Positioned(
                    right: 10,
                    bottom: 10,
                    child: pw.SizedBox(
                      width: 120,
                      child: pw.Image(
                        border_4,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              )),
        ),
        build: (pw.Context context) {
          return [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.only(
                top: AppSize.kPadding * 3,
                left: AppSize.kPadding * 3.5,
                right: AppSize.kPadding * 3.5,
                bottom: AppSize.kPadding * 3,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      "Mục lục",
                      style: pw.TextStyle(
                        fontSize: 28,
                        font: robotoBoldFont,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: AppSize.kPadding),
                  ...tableOfContents.value.map((item) {
                    return pw.Container(
                        padding: const pw.EdgeInsets.only(
                          bottom: AppSize.kPadding / 2,
                        ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              item['title'],
                              style: pw.TextStyle(
                                fontSize: 16,
                                font: robotoMediumFont,
                              ),
                            ),
                            pw.Spacer(),
                            pw.Text(
                              "${item['pageNumber']}",
                              style: pw.TextStyle(
                                fontSize: 16,
                                font: robotoMediumFont,
                              ),
                            ),
                          ],
                        ));
                  }),
                ],
              ),
            )
          ];
        },
      ),
    );
    return await pdf.save();
  }

  void updatePdfData(Uint8List data) {
    pdfData.value = data;
  }

  Future<void> savePdfToDevice() async {
    loadingController.show();
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted) {
          directory = Directory('/storage/emulated/0/Download');
          if (!directory.existsSync()) {
            directory.createSync(recursive: true);
          }
        } else {
          DialogHelper.showToast("Permission denied.", ToastType.warning);
          return;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final file = File(
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(pdfData.value);
        DialogHelper.showToastDialog("Thông báo", "Tải xuống thành công!");
      } else {
        DialogHelper.showToast(
          "Unable to access directory.",
          ToastType.error,
        );
      }
    } catch (e) {
      print("Error saving PDF: $e");
      DialogHelper.showToast("Failed to save PDF.", ToastType.error);
    } finally {
      loadingController.hide();
    }
  }

  Future<void> uploadToWeb3() async {
    DialogHelper.showToast("Đang tải lên...", ToastType.info);
    isUploading.value = true;
    try {
      final response =
          await TribeAPi().uploadPdfFileToWeb3(file: pdfData.value);
      if (response.statusCode == 200) {
        DialogHelper.showCustomToastDialog(
            "Thông báo",
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Tải lên thành công, xem ngay",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButtonComponent(
                    iconSize: 32,
                    iconPadding: 4,
                    iconPath: "assets/icons/arrow-right-2.svg",
                    onPressed: () => Get.to(
                        ArchiveDetailScreen(transaction: response.data!)),
                  )
                ],
              ),
            ));
      }
    } catch (e) {
      print("Error uploading PDF to Web3: $e");
      DialogHelper.showToast("Failed to upload PDF to Web3.", ToastType.error);
    } finally {
      isUploading.value = false;
    }
  }
}
