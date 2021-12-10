import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:tes_database/app/data/api/pdf_invoice_api.dart';
import 'package:tes_database/app/data/model/invoice.dart';

const examples = <Example>[
  Example('DOCUMENT', 'document.dart', generateDocument),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
  PdfPageFormat pageFormat,
  Invoice invoice,
);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
