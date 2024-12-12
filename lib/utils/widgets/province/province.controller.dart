import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/family_tree/view/add_user.controller.dart';

import '../../../resources/models/province.dart';
import '../../debounce/debounce.dart';
import '../../diacritic/diacritic.dart';
import '../../types/type.dart';

class ProvincePickerController extends GetxController {
  final ProvinceLevel level;
  ProvincePickerController(this.level);

  final Rx<TextEditingController> searchController =
      TextEditingController().obs;
  late RxList<Province?> provinces;
  late RxList<Province?> filteredProvinces;
  late RxList<Districts?> districts;
  late RxList<Districts?> filteredDistricts;
  late RxList<Wards?> wards;
  late RxList<Wards?> filteredWards;
  final _debouncer = Debouncer(milliseconds: 200);
  final AddUserController addUserController = Get.find<AddUserController>();

  @override
  void onInit() {
    super.onInit();
    provinces = RxList<Province?>([]);
    filteredProvinces = RxList<Province?>([]);
    districts = RxList<Districts?>([]);
    filteredDistricts = RxList<Districts?>([]);
    wards = RxList<Wards?>([]);
    filteredWards = RxList<Wards?>([]);
    _loadJsonData();

    searchController.value.addListener(() {
      if (level == ProvinceLevel.PROVINCE) {
        _debouncer.run(
            () => _filterData(searchController.value.text, _filterProvinces));
      }
      if (level == ProvinceLevel.DISTRICT) {
        _debouncer.run(
            () => _filterData(searchController.value.text, _filterDistricts));
      }
      if (level == ProvinceLevel.WARD) {
        _debouncer
            .run(() => _filterData(searchController.value.text, _filterWards));
      }
    });
  }

  Future<void> _loadJsonData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/province.json');
      final List<dynamic> parsedJson = json.decode(response);
      provinces.value = parsedJson.map((e) => Province.fromJson(e)).toList();
      _updateFilteredData();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void _updateFilteredData() {
    if (level == ProvinceLevel.PROVINCE) {
      filteredProvinces.value = provinces;
    }
    if (level == ProvinceLevel.DISTRICT) {
      _updateDistricts();
    }
    if (level == ProvinceLevel.WARD) {
      _updateWards();
    }
  }

  void _updateDistricts() {
    final selectedProvince = addUserController.selectedProvince.value;
    districts.value = provinces
        .firstWhere(
          (province) => province!.code == selectedProvince.code,
          orElse: () => null,
        )!
        .districts!;
    filteredDistricts.value = districts;
  }

  void _updateWards() {
    final selectedProvince = addUserController.selectedProvince.value;
    final selectedDistrict = addUserController.selectedDistrict.value;
    wards.value = provinces
        .firstWhere(
          (province) => province!.code == selectedProvince.code,
          orElse: () => null,
        )!
        .districts!
        .firstWhere(
          (district) => district.code == selectedDistrict.code,
        )
        .wards!;
    filteredWards.value = wards;
  }

  // Generalized method to handle filtering
  void _filterData(String query, Function filterMethod) {
    if (query.isEmpty) {
      filterMethod('');
    } else {
      final normalizedQuery = removeDiacritics(query.toLowerCase());
      filterMethod(normalizedQuery);
    }
  }

  void _filterProvinces(String query) {
    filteredProvinces.value = provinces
        .where((province) =>
            province!.name != null &&
            removeDiacritics(province.name!.toLowerCase()).contains(query))
        .toList();
  }

  void _filterDistricts(String query) {
    filteredDistricts.value = districts
        .where((district) =>
            district!.name != null &&
            removeDiacritics(district.name!.toLowerCase()).contains(query))
        .toList();
  }

  void _filterWards(String query) {
    filteredWards.value = wards
        .where((ward) =>
            ward!.name != null &&
            removeDiacritics(ward.name!.toLowerCase()).contains(query))
        .toList();
  }

  void handleChooseProvince(Province? province) {
    addUserController.selectedProvince.value = province!;
    addUserController.selectedDistrict.value = Districts();
    addUserController.selectedWards.value = Wards();
  }

  void handleChooseDistrict(Districts? district) {
    addUserController.selectedDistrict.value = district!;
    addUserController.selectedWards.value = Wards();
  }

  void handleChooseWard(Wards? ward) {
    addUserController.selectedWards.value = ward!;
  }

  @override
  void onClose() {
    searchController.close();
    super.onClose();
  }
}
