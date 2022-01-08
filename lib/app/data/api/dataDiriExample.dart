import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:tes_database/app/data/api/document.dart';
import 'package:tes_database/app/data/model/dataDiri.dart';

const examples = <Example>[
  Example('DOCUMENT', 'document.dart', generateDocumentBiodata),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
  PdfPageFormat pageFormat,
  DataDiri dataDiri,
);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
