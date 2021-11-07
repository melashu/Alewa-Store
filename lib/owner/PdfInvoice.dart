import 'dart:io';
import 'package:boticshop/Utility/date.dart';
import 'package:boticshop/Utility/report.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:ext_storage/ext_storage.dart';

// import 'package:downloads_path_provider/downloads_path_provider.dart';
class PdfInvoice {
  // final font = await rootBundle.load("assets/hind.ttf");
  // Uint8List fontData = File('asset/op.ttf').readAsBytesSync();
  // final ttf = Font.ttf(PdfInvoice().fontData.buffer.asByteData());

  static get style1 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      );

  static Future<File> generatePDF(
      List data, String date, double expenes, String report) async {
    var pdf = Document();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => Center(
            child: Text("${Hive.box("setting").get('orgName')} Sales Report",
                style: TextStyle(fontSize: 20))),
        footer: (context) =>
            Text("Prepared By @${Hive.box("setting").get('orgName')}"),
        build: (context) {
          return getAllPages(data, date, expenes, report);
        }));

    var lastPdf = await savePdf(pdf, report);
    return lastPdf;
  }

  static Future<File> savePdf(Document pdf, String report) async {
    var bytes = await pdf.save();
    final dir =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final file = File('${dir[0].path}/report .pdf');
    await file.create(recursive: true);
    var lastPdf = await file.writeAsBytes(bytes);
    return lastPdf;
  }

  static List<Widget> getAllPages(
      List data, String date, double expenes, String report) {
    List<Widget> allPages = [
      Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: PdfColors.deepPurpleAccent)),
          child: Center(
              child: Text(
            "Today: ${Dates.today} \n File Path: /Android/data/com.alewa.botic/files'",
            style: style1,
            textAlign: TextAlign.center,
          ))),
    ];
    var total = Report.getDailyExpenessPerMonth() / 30;
    var content = '';
    var totalBuy = 0.0;
    var totalSell = 0.0;
    int index = 0;
    for (var row in data) {
      totalBuy = totalBuy +
          (double.parse(row['buyPrices']) * int.parse(row['amount']));
      totalSell = totalSell +
          (double.parse(row['soldPrices']) * int.parse(row['amount']));
      if (data.length <= 10) {
        index = index + 1;
        content = content +
            "\n Item Name: " +
            row['brandName'] +
            "  "
                " Orginal Prices " +
            row['buyPrices'] +
            " Birr "
                " Retiler Prices " +
            row['soldPrices'] +
            " Birr ";
        if (index == data.length) {
          allPages.add(
            Text(
              content,
              style: style1,
            ),
          );
        }
      } else if (index <= 10) {
        index = index + 1;
        content = content +
            "\n => Item Name: " +
            row['brandName'] +
            "  " +
            "Date :" +
            row['salesDate'] +
            " Orginal Prices" +
            row['buyPrices'] +
            " Birr "
                " Retiler Prices " +
            row['soldPrices'] +
            " Birr ";
        if (index == 10) {
          allPages.add(
            Text(
              content,
              style: style1,
            ),
          );
          index = 1;
          content = '';
        }
      }
    }
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(
      Text("Total Sell $totalSell Birr", style: style1),
    );
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(
      Text(
        "Total Item amount $totalBuy Birr",
        style: style1,
      ),
    );
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(
      Text(
        "Total Profite before ${totalSell - totalBuy} Birr",
        style: style1,
      ),
    );
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(
      Text('Montly Expens  $total Birr', style: style1),
    );
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(
      Text('Daily Expenes  $expenes Birr', style: style1),
    );
    allPages.add(
      Divider(
        thickness: 1,
        color: PdfColors.deepPurpleAccent,
      ),
    );
    allPages.add(Text(
      'Total Profit ${(totalSell - totalBuy) - (total + expenes)} Birr',
      style: style1,
    ));
    return allPages;
    // allPages.add(value)
  }
}
