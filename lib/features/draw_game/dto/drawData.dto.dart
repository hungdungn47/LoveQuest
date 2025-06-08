import 'dart:convert';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:love_quest/extensions/freestyleDrawable.extension.dart';

class DrawDataDto {
  final FreeStyleDrawable data;
  final String roomId;

  DrawDataDto({required this.data, required this.roomId});

  Map<String, String> toMap() {
    return {
      "data": jsonEncode(data.toJson()),
      "roomId": roomId
    };
  }
}

