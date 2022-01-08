import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tes_database/app/data/api/dataDiriExample.dart';
import 'package:tes_database/app/data/model/dataDiri.dart';

class MyBioData extends StatefulWidget {
  final DataDiri dataDiri;
  const MyBioData({Key? key, required this.dataDiri}) : super(key: key);

  @override
  MyBioDataState createState() {
    return MyBioDataState();
  }
}

class MyBioDataState extends State<MyBioData>
    with SingleTickerProviderStateMixin {
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
        backgroundColor: Colors.yellow[600],
        centerTitle: true,
        title: Text('${widget.dataDiri.jawaban[0]} BIODATA'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => examples[_tab].builder(format, widget.dataDiri),
        // actions: actions,
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        pageFormats: defaultPageFormats,
        pdfFileName: '${widget.dataDiri.jawaban[0]} BIODATA.pdf',
      ),
    );
  }
}
