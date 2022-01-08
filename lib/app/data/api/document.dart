import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tes_database/app/data/model/dataDiri.dart';
// import 'package:printing/printing.dart';

Future<Uint8List> generateDocumentBiodata(
  PdfPageFormat format,
  DataDiri dataDiri,
) async {
  // final myFont = await PdfGoogleFonts.arial();
  // final myFontB = await PdfGoogleFonts.pTSerifBold();
  const space3 = '    ';
  const space1 = '     ';
  const space2 = '   ';
  final doc = pw.Document(
    pageMode: PdfPageMode.outlines,
  );

  const styleFont = pw.TextStyle(
    fontSize: 11,
    // font: myFont,
  );
  final styleFontB = pw.TextStyle(
    fontSize: 11,
    fontWeight: pw.FontWeight.bold,
  );

  var nis = dataDiri.jawaban[1].split('/').length;

  pw.Widget buildPertanyaan2(
      DatanyaDua pertanyaan, DatanyaDua jawaban, int nomor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 9,
                      child: pw.Text(
                        '$nomor.$space3${pertanyaan.pertanyaan}',
                        style: styleFont,
                      ),
                    ),
                    pw.Expanded(
                      flex: 14,
                      child: pw.Text(
                        ':     ',
                        style: styleFont,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 9,
                      child: pw.Text(
                        '         ${pertanyaan.subPertanyaan1}',
                        style: styleFont,
                      ),
                    ),
                    pw.Expanded(
                      flex: 14,
                      child: pw.Text(
                        ':   ${jawaban.subPertanyaan1}',
                        style: styleFont,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 9,
                      child: pw.Text(
                        '         ${pertanyaan.subPertanyaan2}',
                        style: styleFont,
                      ),
                    ),
                    pw.Expanded(
                      flex: 14,
                      child: pw.Text(
                        ':   ${jawaban.subPertanyaan2}',
                        style: styleFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget buildPertanyaan1(
      DatanyaSatu pertanyaan, DatanyaSatu jawaban, int nomor) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 9,
                      child: pw.Text(
                        '$nomor.$space3${pertanyaan.pertanyaan}',
                        style: styleFont,
                      ),
                    ),
                    pw.Expanded(
                      flex: 14,
                      child: pw.Text(
                        ':   ${jawaban.pertanyaan}',
                        style: styleFont,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 1 * PdfPageFormat.mm),
              pw.SizedBox(
                width: double.infinity,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 9,
                      child: pw.Text(
                        '         ${pertanyaan.subPertanyaan1}',
                        style: styleFont,
                      ),
                    ),
                    pw.Expanded(
                      flex: 14,
                      child: pw.Text(
                        ':   ${jawaban.subPertanyaan1}',
                        style: styleFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  print(nis);

  pw.Widget buildPertanyaanAkhir(String pertanyaan, String jawaban, int nomor) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 9,
          child: pw.Text(
            '$nomor. $space2$pertanyaan',
            style: styleFont,
          ),
        ),
        pw.Expanded(
          flex: 14,
          child: pw.Text(
            ':   $jawaban',
            style: styleFont,
          ),
        ),
      ],
    );
  }

  doc.addPage(
    pw.Page(
      // margin:
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.portrait,
        // buildBackground: (context) => buildBackground,
        theme: pw.ThemeData.withFont(
            // base: myFont,
            // bold: myFontB,
            ),
        // margin: pw.EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      build: (context) =>
          // buildBackground,
          pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        // mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              'KETERANGAN TENTANG DIRI PESERTA DIDIK',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 15 * PdfPageFormat.mm),
          pw.ListView.builder(
            spacing: 1 * PdfPageFormat.mm,
            itemBuilder: (ctx, i) {
              return pw.Row(
                children: [
                  pw.Expanded(
                    flex: 9,
                    child: pw.Text(
                      '${i + 1}. ${i < 9 ? space1 : space2}${i != 1 ? dataDiri.pertanyaan[i] : nis != 1 ? 'NIS/NISN' : dataDiri.pertanyaan[i]}',
                      style: styleFont,
                    ),
                  ),
                  pw.Expanded(
                    flex: 14,
                    child: pw.Text(
                      ':   ${dataDiri.jawaban[i]}',
                      style: i == 0 ? styleFontB : styleFont,
                    ),
                  ),
                ],
              );
            },
            itemCount: 10,
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaan2(dataDiri.pertanyaan1[0], dataDiri.jawaban1[0], 11),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaan2(dataDiri.pertanyaan1[1], dataDiri.jawaban1[1], 12),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaan1(dataDiri.pertanyaan2[0], dataDiri.jawaban2[0], 13),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaan2(dataDiri.pertanyaan1[2], dataDiri.jawaban1[2], 14),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaanAkhir(
              'Nama Wali Peserta Didik', dataDiri.jawaban15, 15),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaan1(dataDiri.pertanyaan2[1], dataDiri.jawaban2[1], 16),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildPertanyaanAkhir(
              'Pekerjaan Wali Peserta Didik', dataDiri.jawaban17, 17),
          pw.SizedBox(height: 18 * PdfPageFormat.mm),
          pw.Row(
            children: [
              pw.SizedBox(
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 4 * PdfPageFormat.cm,
                      width: 3 * PdfPageFormat.cm,
                      // color: PdfColors.amber,
                      margin: const pw.EdgeInsets.only(
                          left: 3.9 * PdfPageFormat.cm),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: 0.3,
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text('Pas Foto\n3 x 4 cm', style: styleFont),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                  padding: const pw.EdgeInsets.only(
                    left: 1.15 * PdfPageFormat.cm,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(dataDiri.tanggal, style: styleFont),
                      pw.Text('Kepala Sekolah,', style: styleFont),
                      pw.SizedBox(height: 8 * PdfPageFormat.mm),
                      pw.Text(dataDiri.namaKepalaSekolah, style: styleFontB),
                      pw.Text('NIP. ${dataDiri.nip}', style: styleFont),
                    ],
                  )),
              // pw.SizedBox(child: ),
            ],
          ),
        ],
      ),
    ),
  );

  return await doc.save();
}
