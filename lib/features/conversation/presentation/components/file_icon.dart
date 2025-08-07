import 'package:flutter/material.dart';

Image getFileIconAsset(String format, {String? fileName}) {
  var lowerFormat = format.toLowerCase();

  if (lowerFormat == "unknown") {
    lowerFormat = fileName!.split(".").last;
  }

  // Common file types
  return Image.asset(switch (lowerFormat) {
    'pdf' => 'assets/images/file_icon/pdf.png',
    'doc' || 'docx' => 'assets/images/file_icon/word.png',
    'xls' || 'xlsx' => 'assets/images/file_icon/excel.png',
    'ppt' || 'pptx' => 'assets/images/file_icon/presentation.png',
    'zip' => 'assets/images/file_icon/zip.png',
    'rar' => 'assets/images/file_icon/rar.png',
    _ => 'assets/images/file_icon/attach.png',
  }, height: 40);
}
