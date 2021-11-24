// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:path/path.dart' as path;
// import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir =
        kIsWeb ? path.current : await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.toString(), name));
    var url =
        "https://firebasestorage.googleapis.com/v0/b/sistem-informasi-raport.appspot.com/o/pdf%2Fmy_invoice.pdf?alt=media&amp;token=b9ac3d2e-7bfe-4dec-a362-b5b04712eca7";
    if (kIsWeb)
      _saveDocumentWeb(bytes, name, url);
    else
      await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  static _saveDocumentWeb(Uint8List data, String filename, String url) {
    try {
      final ref = FirebaseStorage.instance.ref("pdf/$filename");

      ref
          .putData(
            data,
            SettableMetadata(contentType: 'file/pdf'),
          )
          .whenComplete(
            () => _launchInBrowser(url),
          );
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
    // String url =
    //     html.Url.createObjectUrlFromBlob(html.Blob(
    //   [data],
    //   'application/pdf',
    // ));

    // html.AnchorElement element =
    //     html.document.createElement(
    //   'a',
    // ) as html.AnchorElement
    //       ..href = url
    //       ..style.display = 'none'
    //       ..download = filename;

    // print(url);
    // print(filename);
    // html.document.body!.children
    //   ..add(element..click())
    //   ..remove(element);

    // html.Url.revokeObjectUrl(url);
  }
}
