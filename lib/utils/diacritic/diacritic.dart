import 'replacement_map.dart';

String removeDiacritics(String text) =>
    String.fromCharCodes(replaceCodeUnits(text.codeUnits));
