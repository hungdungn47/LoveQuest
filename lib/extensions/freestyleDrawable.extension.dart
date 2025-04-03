import 'dart:ui';

import 'package:flutter_painter_v2/flutter_painter.dart';

extension FreeStyleDrawableJson on FreeStyleDrawable {
  Map<String, dynamic> toJson() {
    return {
      "type": "freestyle",
      "color": color.value,
      "strokeWidth": strokeWidth,
      "points": path.map((p) => {"x": p.dx, "y": p.dy}).toList(),
    };
  }

  static FreeStyleDrawable fromJson(Map<String, dynamic> json) {
    return FreeStyleDrawable(
      path: (json["points"] as List).map((p) => Offset(p["x"], p["y"])).toList(),
      color: Color(json["color"]),
      strokeWidth: json["strokeWidth"],
    );
  }
}
