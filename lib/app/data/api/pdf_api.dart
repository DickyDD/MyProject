import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tes_database/app/data/model/invoice.dart';
import 'examples.dart';

class MyPDF extends StatefulWidget {
  final Invoice raport;
  const MyPDF({Key? key, required this.raport}) : super(key: key);

  @override
  MyPDFState createState() {
    return MyPDFState();
  }
}

class MyPDFState extends State<MyPDF> with SingleTickerProviderStateMixin {
  int _tab = 0;
  TabController? _tabController;

  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _tabController = TabController(
      vsync: this,
      length: examples.length,
      initialIndex: _tab,
    );
    _tabController!.addListener(() {
      if (_tab != _tabController!.index) {
        setState(() {
          _tab = _tabController!.index;
        });
      }
    });

    setState(() {
      printingInfo = info;
    });
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    const defaultPageFormats = <String, PdfPageFormat>{
      'A3': PdfPageFormat.a3,
      'A4': PdfPageFormat.a4,
      'A5': PdfPageFormat.a5,
      'A6': PdfPageFormat.a6,
      'Legal': PdfPageFormat.legal,
      'Letter': PdfPageFormat.letter,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Demo'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => examples[_tab].builder(format, widget.raport),
        // actions: actions,
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        pageFormats: defaultPageFormats,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
        pdfFileName: 'Dicky.pdf',
      ),
    );
  }
}
