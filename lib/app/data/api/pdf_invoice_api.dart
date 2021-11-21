import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:tes_database/app/data/api/pdf_api.dart';
import 'package:tes_database/app/data/model/invoice.dart';

class PdfInvoiceApi {
  static final cellAligens = {
    0: IntrinsicColumnWidth(flex: 2),
    1: IntrinsicColumnWidth(flex: 11),
    2: IntrinsicColumnWidth(flex: 5),
    3: IntrinsicColumnWidth(flex: 5),
    4: IntrinsicColumnWidth(flex: 3),
    5: IntrinsicColumnWidth(flex: 5),
  };
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    var datFont = await rootBundle.load("assets/trm.ttf");
    var datFontB = await rootBundle.load("assets/trmB.ttf");
    final myFont = pw.Font.ttf(datFont);
    final myFontB = pw.Font.ttf(datFontB);
    var styleFont = pw.TextStyle(
      fontSize: 11,
      font: myFont,
    );
    var styleFontB = pw.TextStyle(
      fontSize: 11,
      font: myFontB,
    );

    final titles2 = <String>[
      'Kelas',
      'Semester',
      'Tahun Pelajaran',
    ];
    final data2 = <String>[
      ": ${invoice.info.kelas}",
      ": ${invoice.info.semester}",
      ": ${invoice.info.tahunPelajaran}",
    ];

    final titles = <String>[
      'Nama',
      'Nomor Induk',
      'Nama Sekolah',
      'Alamat',
    ];
    final data = <String>[
      ": ${invoice.info.nama}",
      ": ${invoice.info.nik}",
      ": ${invoice.info.namaSekolah}",
      ": ${invoice.info.alamat}",
    ];

    pdf.addPage(MultiPage(
      header: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              "RAPOR PESERTA DIDIK",
              style: styleFontB,
            ),
          ),
          SizedBox(height: 5 * PdfPageFormat.mm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: List.generate(
                    titles.length,
                    (index) => pw.Text(
                      titles[index],
                    ),
                  ),
                ),
                SizedBox(width: 8 * PdfPageFormat.mm),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: List.generate(
                    data.length,
                    (index) => pw.Text(
                      data[index],
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
                      titles2[index],
                    ),
                  ),
                ),
                SizedBox(width: 4 * PdfPageFormat.mm),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: List.generate(
                    data2.length,
                    (index) => pw.Text(
                      data2[index],
                    ),
                  ),
                ),
              ]),
            ],
          ),
          // SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      ),
      theme: pw.ThemeData(defaultTextStyle: styleFont),
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        SizedBox(height: 2.5 * PdfPageFormat.mm),
        Text(
          'A. Nilai Akademik',
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        pw.Table.fromTextArray(
          columnWidths: cellAligens,
          cellPadding: pw.EdgeInsets.symmetric(vertical: 2),
          border: pw.TableBorder.all(width: 1),
          data: [
            [
              'No.',
              'Mata Pelajaran',
              'Pengetahuan',
              'Keterampilan',
              'Nilai\nAkhir',
              'Predikat',
            ],
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "A. Nilai Akademik",
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildInvoice(invoice.itemsA, styleFont, styleFontB),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "B. Muatan Kewilayahan",
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildInvoice(invoice.itemsB, styleFont, styleFontB),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "C. Muatan Peminatan Kejuruan",
          style: styleFontB,
        ),
        SizedBox(height: 0.4 * PdfPageFormat.mm),
        pw.Divider(height: 0.5),
        SizedBox(height: 0.4 * PdfPageFormat.mm),
        Text(
          "C1. Dasar Bidang Keahlian",
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildInvoice(invoice.itemsC, styleFont, styleFontB),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Text(
          "C2. Dasar Program Keahlian",
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildInvoice(invoice.itemsD, styleFont, styleFontB),
        SizedBox(height: 4 * PdfPageFormat.mm),
        Text(
          "B. CATATAN AKADEMIK",
          style: styleFontB,
        ),
        SizedBox(height: 1 * PdfPageFormat.mm),
        pw.Container(
          height: 18 * PdfPageFormat.mm,
          width: double.infinity,
          alignment: pw.Alignment.centerLeft,
          padding: pw.EdgeInsets.all(3),
          child: pw.Text(
            invoice.catatanAkademik,
            textAlign: pw.TextAlign.left,
          ),
          decoration: pw.BoxDecoration(
            border: Border.all(
              color: PdfColors.black,
              width: 1,
            ),
          ),
        ),
        SizedBox(height: 4 * PdfPageFormat.mm),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Mengetahui;'),
                    pw.Text('Orang Tua/Wali,'),
                    SizedBox(height: 10 * PdfPageFormat.mm),
                    pw.Text(invoice.namaOrangTua),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('feffd'),
                    pw.Text('Wali Kelas'),
                    SizedBox(height: 10 * PdfPageFormat.mm),
                    pw.Text(invoice.namaWalikelas),
                    pw.Text(invoice.nipWalikelas),
                  ]),
            ]),
        pw.Center(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Mengetahui;'),
                pw.Text('Kepala Sekolah'),
                SizedBox(height: 22 * PdfPageFormat.mm),
                pw.Text(invoice.namaKepalaSekolah),
                pw.Text(invoice.nipKepalaSekolah),
              ]),
        )
      ],
    ));

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData(defaultTextStyle: styleFont),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "RAPOR PESERTA DIDIK",
                  style: styleFontB,
                ),
              ),
              SizedBox(height: 5 * PdfPageFormat.mm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: List.generate(
                        titles.length,
                        (index) => pw.Text(
                          titles[index],
                        ),
                      ),
                    ),
                    SizedBox(width: 8 * PdfPageFormat.mm),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: List.generate(
                        data.length,
                        (index) => pw.Text(
                          data[index],
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
                          titles2[index],
                        ),
                      ),
                    ),
                    SizedBox(width: 4 * PdfPageFormat.mm),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: List.generate(
                        data2.length,
                        (index) => pw.Text(
                          data2[index],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              // SizedBox(height: 1 * PdfPageFormat.cm),
            ],
          );
        },
      ),
    );
    return PdfApi.saveDocument(
      name: 'my_invoice.pdf',
      pdf: pdf,
    );
  }

  static Widget buildInvoice(
      List<InvoiceItem> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      final total = (item.pengetahuan + item.keterampilan) / 2;

      return [
        item.no,
        '${item.mP}',
        '${item.pengetahuan}',
        '${item.keterampilan}',
        '${total.toStringAsFixed(1)}',
        '${item.predikat}',
      ];
    }).toList();

    return Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headerAlignment: pw.Alignment.center,
      columnWidths: cellAligens,
      cellPadding: pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
      },
    );
  }
}
