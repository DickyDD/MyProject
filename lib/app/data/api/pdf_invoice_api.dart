import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    // var dataimage = await rootBundle.load("assets/watermark1.png");
    // var myImage = dataimage.buffer.asUint8List();
    final myFont = pw.Font.ttf(datFont);
    final myFontB = pw.Font.ttf(datFontB);
    // final robotoLight = await PdfGoogleFonts.robotoLight();
    var styleFont = pw.TextStyle(
      fontSize: 11,
      font: myFont,
    );
    var styleFontB = pw.TextStyle(
      fontSize: 11,
      font: myFontB,
    );

    var bulan = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    var day = DateTime.now().day;
    var mounth = bulan[DateTime.now().month];
    var year = DateTime.now().year;

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

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData(defaultTextStyle: styleFont),
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Stack(children: [
          pw.Container(
            // height: Get.height * 0.5,
            margin: pw.EdgeInsets.only(top: 20 * PdfPageFormat.mm),
            width: Get.width,
            // child: pw.Image(
            //   // pw.MemoryImage(myImage),
            //   alignment: pw.Alignment.bottomCenter,
            // ),
          ),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
              // mainAxisAlignment: pw.MainAxisAlignment.start,
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
                SizedBox(height: 3 * PdfPageFormat.mm),
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
                  "A. Muatan Nasional",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildHal1(invoice.itemsA, styleFont, styleFontB),
                SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "B. Muatan Kewilayahan",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildHal1(invoice.itemsB, styleFont, styleFontB),
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
                buildHal1(invoice.itemsC, styleFont, styleFontB),
                SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "C2. Dasar Program Keahlian",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildHal1(invoice.itemsD, styleFont, styleFontB),
                SizedBox(height: 4 * PdfPageFormat.mm),
                Text(
                  "B. CATATAN AKADEMIK",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                pw.Container(
                  height: 18 * PdfPageFormat.mm,
                  width: double.infinity,
                  // alignment: pw.Alignment.to,
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
                            pw.Text(invoice.namaOrangTua,
                                style: pw.TextStyle(
                                  font: myFontB,
                                  decoration: TextDecoration.underline,
                                )),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //Tanggal Makkasar
                            pw.Text('Makassar, $day $mounth $year'),
                            pw.Text('Wali Kelas'),
                            SizedBox(height: 10 * PdfPageFormat.mm),
                            pw.Text(invoice.namaWalikelas,
                                style: pw.TextStyle(
                                  font: myFontB,
                                )),
                            pw.Text("NIP. " + invoice.nipWalikelas),
                          ]),
                    ]),
                pw.Center(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Mengetahui'),
                        pw.Text('Kepala Sekolah'),
                        SizedBox(height: 18 * PdfPageFormat.mm),
                        pw.Text(invoice.namaKepalaSekolah,
                            style: pw.TextStyle(
                              font: myFontB,
                            )),
                        pw.Text("NIP. " + invoice.nipKepalaSekolah),
                      ]),
                )
              ])
        ]),
      ),
    );

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData(defaultTextStyle: styleFont),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(children: [
            pw.Container(
              // height: Get.height * 0.5,
              margin: pw.EdgeInsets.only(top: 20 * PdfPageFormat.mm),
              width: Get.width,
              // child: pw.Image(
              //   pw.MemoryImage(myImage),
              //   alignment: pw.Alignment.bottomCenter,
              // ),
            ),
            Column(
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
                SizedBox(height: 3 * PdfPageFormat.mm),
                // SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "C. Praktik Kerja Lapangan",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
                buildHalPKl(
                  invoice.itemsPkl,
                  styleFont,
                  styleFontB,
                ),
                SizedBox(height: 10 * PdfPageFormat.mm),
                // SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "D. EKSTRAKURIKULER",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),

                buildHalExtra(
                  invoice.itemsExtra,
                  styleFont,
                  styleFontB,
                ),
                SizedBox(height: 10 * PdfPageFormat.mm),
                // SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "E. KETIDAKHADIRAN",
                  style: styleFontB,
                ),
                SizedBox(height: 1 * PdfPageFormat.mm),
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
                SizedBox(height: 10 * PdfPageFormat.mm),
                // SizedBox(height: 1 * PdfPageFormat.mm),
                Text(
                  "F. KENAIKAN KELAS",
                  style: styleFontB,
                ),

                SizedBox(height: 1 * PdfPageFormat.mm),
                pw.Container(
                  height: 18 * PdfPageFormat.mm,
                  width: double.infinity,
                  // alignment: pw.Alignment.to,
                  padding: pw.EdgeInsets.all(3),
                  child: pw.Text(
                    invoice.kenaikanKelas,
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
                            pw.Text(invoice.namaOrangTua,
                                style: pw.TextStyle(
                                  font: myFontB,
                                  decoration: TextDecoration.underline,
                                )),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //Tanggal Makkasar
                            pw.Text('Makassar, $day $mounth $year'),
                            pw.Text('Wali Kelas'),
                            SizedBox(height: 10 * PdfPageFormat.mm),
                            pw.Text(invoice.namaWalikelas,
                                style: pw.TextStyle(
                                  font: myFontB,
                                )),
                            pw.Text("NIP. " + invoice.nipWalikelas),
                          ]),
                    ]),
                pw.Center(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Mengetahui'),
                        pw.Text('Kepala Sekolah'),
                        SizedBox(height: 18 * PdfPageFormat.mm),
                        pw.Text(invoice.namaKepalaSekolah,
                            style: pw.TextStyle(
                              font: myFontB,
                            )),
                        pw.Text("NIP. " + invoice.nipKepalaSekolah),
                      ]),
                )
              ],
            ),
          ]);
        },
      ),
    );
    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData(defaultTextStyle: styleFont),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return
              // pw.Container(
              //   height: Get.height,
              //   width: Get.width,
              //   child: pw.Image(
              //     pw.MemoryImage(myImage),

              //   ),
              // ),
              Column(
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
              SizedBox(height: 3 * PdfPageFormat.mm),
              // SizedBox(height: 1 * PdfPageFormat.mm),
              Text(
                "G. DESKRIPSI PERKEMBANGAN KARAKTER",
                style: styleFontB,
              ),
              SizedBox(height: 1 * PdfPageFormat.mm),
              buildHalDPK(
                invoice.itemsDPK,
              ),

              SizedBox(height: 10 * PdfPageFormat.mm),
              // SizedBox(height: 1 * PdfPageFormat.mm),
              Text(
                "H. CATATAN PERKEMBANGAN KARAKTER",
                style: styleFontB,
              ),

              SizedBox(height: 1 * PdfPageFormat.mm),
              pw.Container(
                height: 18 * PdfPageFormat.mm,
                width: double.infinity,
                // alignment: pw.Alignment.to,
                padding: pw.EdgeInsets.all(3),
                child: pw.Text(
                  invoice.dpk,
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
                          pw.Text(invoice.namaOrangTua,
                              style: pw.TextStyle(
                                font: myFontB,
                                decoration: TextDecoration.underline,
                              )),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          //Tanggal Makkasar
                          pw.Text('Makassar, $day $mounth $year'),
                          pw.Text('Wali Kelas'),
                          SizedBox(height: 10 * PdfPageFormat.mm),
                          pw.Text(invoice.namaWalikelas,
                              style: pw.TextStyle(
                                font: myFontB,
                              )),
                          pw.Text("NIP. " + invoice.nipWalikelas),
                        ]),
                  ]),
              pw.Center(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Mengetahui'),
                      pw.Text('Kepala Sekolah'),
                      SizedBox(height: 18 * PdfPageFormat.mm),
                      pw.Text(invoice.namaKepalaSekolah,
                          style: pw.TextStyle(
                            font: myFontB,
                          )),
                      pw.Text("NIP. " + invoice.nipKepalaSekolah),
                    ]),
              )
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

  static Widget buildHal1(
      List<InvoiceItem> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      final total = (item.pengetahuan + item.keterampilan) / 2;
      var predikat = "";
      if (total >= 95) {
        predikat = "A +";
      } else if (total >= 90) {
        predikat = "A";
      } else if (total >= 85) {
        predikat = "A -";
      } else if (total >= 80) {
        predikat = "B +";
      } else if (total >= 75) {
        predikat = "B";
      } else if (total >= 70) {
        predikat = "B -";
      } else if (total >= 60) {
        predikat = "C";
      } else {
        predikat = "D";
      }
      return [
        item.no,
        '${item.mP}',
        '${item.pengetahuan}',
        '${item.keterampilan}',
        '${total.toStringAsFixed(1)}',
        '$predikat',
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

  static Widget buildHalPKl(
      List<InvoiceItemPKL> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        item.no,
        '${item.lokasi}',
        '${item.lama}',
        '${item.keterangan}',
      ];
    }).toList();

    return Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: [
        "No.",
        "Mitra DU/DI",
        "Lokasi",
        "Lamanya\n  (bulan)",
        "Keterangan",
      ],
      headerAlignment: pw.Alignment.center,
      columnWidths: {
        0: IntrinsicColumnWidth(flex: 2),
        1: IntrinsicColumnWidth(flex: 7),
        2: IntrinsicColumnWidth(flex: 5),
        3: IntrinsicColumnWidth(flex: 5),
        4: IntrinsicColumnWidth(flex: 14),
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
      },
    );
  }

  static Widget buildHalExtra(
      List<InvoiceItemExtra> items, pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        item.no,
        '${item.nama}',
        '${item.nilai}',
        '${item.keterangan}',
      ];
    }).toList();

    return Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: [
        "No.",
        "Kegiatan Ekstrakurikuler",
        "Nilai",
        "Keterangan",
      ],
      headerAlignment: pw.Alignment.center,
      columnWidths: {
        0: IntrinsicColumnWidth(flex: 2),
        1: IntrinsicColumnWidth(flex: 9),
        2: IntrinsicColumnWidth(flex: 4),
        3: IntrinsicColumnWidth(flex: 18),
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 2),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        // 4: Alignment.center,
        // 5: Alignment.center,
      },
    );
  }

  static Widget buildHalKehadiran(List<InvoiceItemKehadiran> items,
      pw.TextStyle style, pw.TextStyle styleB) {
    final data = items.map((item) {
      return [
        '${item.nama}',
        '${item.nilai}',
        'hari',
      ];
    }).toList();

    return Table.fromTextArray(
      data: data,
      cellHeight: 0,
      columnWidths: {
        0: IntrinsicColumnWidth(flex: 11),
        1: IntrinsicColumnWidth(flex: 4),
        2: IntrinsicColumnWidth(flex: 6),
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2.5),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.centerLeft,
      },
    );
  }

  static Widget buildHalDPK(
    List<InvoiceItemKehadiran> items,
  ) {
    var no = 1;

    final data = items.map((item) {
      return [
        "${no++}",
        '${item.nama}',
        '${item.nilai}',
      ];
    }).toList();

    return Table.fromTextArray(
      data: data,
      cellHeight: 0,
      headers: [
        "No.",
        "Karakter yang\n   dibangun",
        "Deskripsi",
      ],
      headerAlignment: pw.Alignment.center,
      columnWidths: {
        0: IntrinsicColumnWidth(flex: 1),
        1: IntrinsicColumnWidth(flex: 4),
        2: IntrinsicColumnWidth(flex: 14),
      },
      cellPadding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2.5),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
      },
    );
  }
}
// =IF(M14="";"";IF(M14>=95;"A +";IF(M14>=90;"A";IF(M14>=85;"A -";IF(M14>=80;"B +";IF(M14>=75;"B";IF(M14>=70;"B -";IF(M14>=60;"C";"D"))))))))