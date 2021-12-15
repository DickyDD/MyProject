import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tes_database/app/data/model/invoice.dart';

Future<Uint8List> generateDocument(
  PdfPageFormat format,
  Invoice invoice,
) async {
  // final datFont = h.File('assets/trm.ttf');
  // final datFontB = h.File('assets/trmB.ttf');
  // final datFontB = await rootBundle.load('assets/trmB.ttf');

  // final myFont = pw.Font.ttf(datFont.buffer.asByteData());
  // final myFontB = pw.Font.ttf(datFontB.buffer.asByteData());
  final myFont = await PdfGoogleFonts.pTSerifRegular();
  final myFontB = await PdfGoogleFonts.pTSerifBold();

  final doc = pw.Document(
    pageMode: PdfPageMode.outlines,
  );
  final profileImage = pw.MemoryImage(
    (await rootBundle.load('assets/watermark.jpg')).buffer.asUint8List(),
  );

  const styleFont = pw.TextStyle(
    fontSize: 11,
    // font: myFont,
  );
  final styleFontB = pw.TextStyle(
    fontSize: 11,
    fontWeight: pw.FontWeight.bold,
  );
  final buildBackground = pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 70),
    child: pw.Center(
      child: pw.Image(profileImage),
    ),
  );

  pw.Widget buildHal1(
      List<InvoiceItem> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      final total = (item.pengetahuan + item.keterampilan) / 2;
      var predikat = '';
      if (total >= 95) {
        predikat = 'A +';
      } else if (total >= 90) {
        predikat = 'A';
      } else if (total >= 85) {
        predikat = 'A -';
      } else if (total >= 80) {
        predikat = 'B +';
      } else if (total >= 75) {
        predikat = 'B';
      } else if (total >= 70) {
        predikat = 'B -';
      } else if (total >= 60) {
        predikat = 'C';
      } else {
        predikat = 'D';
      }
      return [
        item.no,
        item.mP,
        item.pengetahuan,
        item.keterampilan,
        total.toStringAsFixed(1),
        predikat,
      ];
    }).toList();

    return pw.Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headerStyle: style,
      cellStyle: style,
      headerAlignment: pw.Alignment.center,
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(flex: 2),
        1: pw.IntrinsicColumnWidth(flex: 11),
        2: pw.IntrinsicColumnWidth(flex: 5),
        3: pw.IntrinsicColumnWidth(flex: 5),
        4: pw.IntrinsicColumnWidth(flex: 3),
        5: pw.IntrinsicColumnWidth(flex: 5),
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
    );
  }

  final titles2 = <String>[
    'Kelas',
    'Semester',
    'Tahun Pelajaran',
  ];
  final data2 = <String>[
    ': ${invoice.info.kelas}',
    ': ${invoice.info.semester}',
    ': ${invoice.info.tahunPelajaran}',
  ];

  final titles = <String>[
    'Nama',
    'Nomor Induk',
    'Nama Sekolah',
    'Alamat',
  ];
  final data = <String>[
    ': ${invoice.info.nama}',
    ': ${invoice.info.nik}',
    ': ${invoice.info.namaSekolah}',
    ': ${invoice.info.alamat}',
  ];

  pw.Widget buildHalPKl(
      List<InvoiceItemPKL> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        item.no,
        item.lokasi,
        item.lama,
        item.keterangan,
      ];
    }).toList();

    final heading = [
      'No.',
      'Mitra DU/DI',
      'Lokasi',
      'Lamanya\n  (bulan)',
      'Keterangan',
    ];

    return pw.Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: heading,
      headerAlignment: pw.Alignment.center,
      headerStyle: style,
      cellStyle: style,
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(flex: 2),
        1: pw.IntrinsicColumnWidth(flex: 7),
        2: pw.IntrinsicColumnWidth(flex: 5),
        3: pw.IntrinsicColumnWidth(flex: 5),
        4: pw.IntrinsicColumnWidth(flex: 14),
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
    );
  }

  pw.Widget buildHalDPK(
    List<InvoiceItemKehadiran> items,
    pw.TextStyle style,
  ) {
    var no = 1;

    final data = items.map((item) {
      return [
        no++,
        item.nama,
        item.nilai,
      ];
    }).toList();

    final heading = [
      'No.',
      'Karakter yang\n   dibangun',
      'Deskripsi',
    ];

    return pw.Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: heading,
      
      headerAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
      },
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(flex: 1),
        1: pw.IntrinsicColumnWidth(flex: 4),
        2: pw.IntrinsicColumnWidth(flex: 14),
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2.5),
      headerStyle: style,
      cellStyle: style,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
      },
    );
  }

  pw.Widget buildHalExtra(
      List<InvoiceItemExtra> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        item.no,
        (item.nama),
        (item.nilai),
        (item.keterangan),
      ];
    }).toList();

    final heading = [
      'No.',
      'Kegiatan Ekstrakurikuler',
      'Nilai',
      'Keterangan',
    ];

    return pw.Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: heading,
      headerStyle: style,
      // headerStyle: style,
      cellStyle: style,
      headerAlignment: pw.Alignment.center,
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(flex: 2),
        1: pw.IntrinsicColumnWidth(flex: 10),
        2: pw.IntrinsicColumnWidth(flex: 4),
        3: pw.IntrinsicColumnWidth(flex: 18),
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        // 4: Alignment.center,
        // 5: Alignment.center,
      },
    );
  }

  pw.Widget buildHalKehadiran(List<InvoiceItemKehadiran> items,
      pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        (item.nama),
        (item.nilai),
        ' hari',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headerStyle: style,
      cellStyle: style,
      columnWidths: const {
        0: pw.IntrinsicColumnWidth(flex: 13),
        1: pw.IntrinsicColumnWidth(flex: 4),
        2: pw.IntrinsicColumnWidth(flex: 6),
      },
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2.5),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerLeft,
      },
    );
  }

  const dataHeading = [
    'No.',
    'Mata Pelajaran',
    'Pengetahuan',
    'Keterampilan',
    'Nilai\nAkhir',
    'Predikat',
  ];

  pw.Widget headings(pw.TextStyle style, pw.TextStyle styleB) {
    return pw.Column(
      children: [
        pw.Center(
          child: pw.Text(
            'RAPOR PESERTA DIDIK',
            style: styleFontB,
          ),
        ),
        pw.SizedBox(height: 5 * PdfPageFormat.mm),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: List.generate(
                  titles.length,
                  (index) => pw.Text(
                    titles[index],
                    style: styleFont
                  ),
                ),
              ),
              pw.SizedBox(width: 8 * PdfPageFormat.mm),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: List.generate(
                  data.length,
                  (index) => pw.Text(
                    data[index],
                    style: styleFont
                  ),
                ),
              ),
            ]),
            pw.Row(children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: List.generate(
                  titles2.length,
                  (index) => pw.Text(
                    titles2[index],style: styleFont
                  ),
                ),
              ),
              pw.SizedBox(width: 4 * PdfPageFormat.mm),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: List.generate(
                  data2.length,
                  (index) => pw.Text(
                    data2[index],style: styleFont
                  ),
                ),
              ),
            ]),
          ],
        ),
        pw.SizedBox(height: 3 * PdfPageFormat.mm),
      ],
    );
  }

  pw.Widget footer(pw.TextStyle style, pw.TextStyle styleB) {
    return pw.Column(
      children: [
        pw.SizedBox(height: 4 * PdfPageFormat.mm),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Mengetahui;',style: style),
                    pw.Text('Orang Tua/Wali,',style: style),
                    pw.SizedBox(height: 10 * PdfPageFormat.mm),
                    pw.Text(invoice.namaOrangTua,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline,
                        )),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    //Tanggal Makkasar
                    pw.Text(invoice.tanggal,style: style),
                    pw.Text('Wali Kelas',style: style),
                    pw.SizedBox(height: 10 * PdfPageFormat.mm),
                    pw.Text(invoice.namaWalikelas,
                        style: styleFontB,),
                    pw.Text('NIP. ' + invoice.nipWalikelas,style: style),
                  ]),
            ]),
        pw.Center(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Mengetahui',style: style),
                pw.Text('Kepala Sekolah',style: style),
                pw.SizedBox(height: 18 * PdfPageFormat.mm),
                pw.Text(invoice.namaKepalaSekolah,
                    style: styleFontB),
                pw.Text('NIP. ' + invoice.nipKepalaSekolah,style: style),
              ]),
        ),
      ],
    );
  }

  doc.addPage(
    pw.Page(
      // margin:
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.portrait,
        buildBackground: (context) => buildBackground,
        margin: pw.EdgeInsets.fromLTRB(
            20 * PdfPageFormat.mm,
            20 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm),
        theme: pw.ThemeData.withFont(
          base: myFont,
          bold: myFontB,
        ),
        // margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      build: (context) =>
          // buildBackground,
          pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        // mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          headings(styleFont, styleFontB),
          pw.Text(
            'A. Nilai Akademik',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Table.fromTextArray(
            columnWidths: const {
              0: pw.IntrinsicColumnWidth(flex: 2),
              1: pw.IntrinsicColumnWidth(flex: 11),
              2: pw.IntrinsicColumnWidth(flex: 5),
              3: pw.IntrinsicColumnWidth(flex: 5),
              4: pw.IntrinsicColumnWidth(flex: 3),
              5: pw.IntrinsicColumnWidth(flex: 5),
            },
            cellPadding: const pw.EdgeInsets.symmetric(vertical: 2),
            border: pw.TableBorder.all(width: 1),
            headerStyle: styleFont,
            cellStyle: styleFont,
            data: [dataHeading],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(
            'A. Muatan Nasional',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildHal1(invoice.itemsA, styleFont, styleFontB),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(
            'B. Muatan Kewilayahan',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildHal1(invoice.itemsB, styleFont, styleFontB),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(
            'C. Muatan Peminatan Kejuruan',
            style: styleFontB,
          ),
          pw.SizedBox(height: 0.4 * PdfPageFormat.mm),
          pw.Divider(height: 0.5),
          pw.SizedBox(height: 0.4 * PdfPageFormat.mm),
          pw.Text(
            'C1. Dasar Bidang Keahlian',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildHal1(invoice.itemsC, styleFont, styleFontB),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(
            'C2. Dasar Program Keahlian',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildHal1(invoice.itemsD, styleFont, styleFontB),
          pw.SizedBox(height: 4 * PdfPageFormat.mm),
          pw.Text(
            'B. CATATAN AKADEMIK',
            style: styleFontB,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Container(
            height: 18 * PdfPageFormat.mm,
            width: double.infinity,
            // alignment: pw.Alignment.to,
            padding: const pw.EdgeInsets.all(3),
            child: pw.Text(
              invoice.catatanAkademik,
              textAlign: pw.TextAlign.left,
            ),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
                width: 1,
              ),
            ),
          ),
          footer(styleFont, styleFontB),
        ],
      ),
    ),
  );

  doc.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.portrait,
        buildBackground: (context) => buildBackground,
        margin: pw.EdgeInsets.fromLTRB(
            20 * PdfPageFormat.mm,
            20 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm,),
        theme: pw.ThemeData.withFont(
          base: myFont,
          bold: myFontB,
        ),
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headings(styleFont, styleFontB),
            pw.Text(
              'C. Praktik Kerja Lapangan',
              style: styleFontB,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            buildHalPKl(
              invoice.itemsPkl,
              styleFont,
              styleFontB,
            ),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              'D. EKSTRAKURIKULER',
              style: styleFontB,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            buildHalExtra(
              invoice.itemsExtra,
              styleFont,
              styleFontB,
            ),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              'E. KETIDAKHADIRAN',
              style: styleFontB,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Row(children: [
              pw.Expanded(
                flex: 7,
                child: buildHalKehadiran(
                  invoice.itemsKehadiran,
                  styleFont,
                  styleFontB,
                ),
              ),
              pw.Expanded(flex: 4, child: pw.SizedBox()),
            ]),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              'F. KENAIKAN KELAS',
              style: styleFontB,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Container(
              height: 18 * PdfPageFormat.mm,
              width: double.infinity,
              // alignment: pw.Alignment.to,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                invoice.kenaikanKelas,
                textAlign: pw.TextAlign.left,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 1,
                ),
              ),
            ),
            footer(styleFont, styleFontB),
          ],
        );
      },
    ),
  );

  doc.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.portrait,
        buildBackground: (context) => buildBackground,
        margin: pw.EdgeInsets.fromLTRB(
            20 * PdfPageFormat.mm,
            20 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm,
            15 * PdfPageFormat.mm,),
        theme: pw.ThemeData.withFont(
          base: myFont,
          bold: myFontB,
        ),
      ),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headings(styleFont, styleFontB),
            pw.Text(
              'G. DESKRIPSI PERKEMBANGAN KARAKTER',
              style: styleFontB,
            ),
            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            buildHalDPK(
              invoice.itemsDPK,
              styleFont
            ),

            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            // pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Text(
              'H. CATATAN PERKEMBANGAN KARAKTER',
              style: styleFontB,
            ),

            pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Container(
              height: 18 * PdfPageFormat.mm,
              width: double.infinity,
              // alignment: pw.Alignment.to,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text(
                invoice.dpk,
                textAlign: pw.TextAlign.left,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 1,
                ),
              ),
            ),
            footer(styleFont, styleFontB),
          ],
        );
      },
    ),
  );

  return await doc.save();
}
