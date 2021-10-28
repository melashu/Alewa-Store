import 'dart:io';
import 'package:boticshop/Utility/report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class PdfInvoice {
  // final font = await rootBundle.load("assets/hind.ttf");
  // Uint8List fontData = File('asset/op.ttf').readAsBytesSync();
  // final ttf = Font.ttf(PdfInvoice().fontData.buffer.asByteData());

  static get style1 => TextStyle(
        fontSize: 15, fontWeight: FontWeight.bold,

        // font: PdfInvoice().ttf
      );

  static Future<File> generatePDF(
      List data, String date, double expenes, String report) async {
    var pdf = Document();
    var total = Report.getDailyExpenessPerMonth() / 30;
    var content = '${data.length}';
    var totalBuy = 0.0;
    var totalSell = 0.0;
    for(var row in data) {
      totalBuy = totalBuy +
          (double.parse(row['buyPrices']) * int.parse(row['amount']));
      totalSell = totalSell +
          (double.parse(row['soldPrices']) * int.parse(row['amount']));
      content = content +
          "\n Item Name " +
          row['brandName'] +
          " \n "+
              " Buy Prices " +
          row['buyPrices'] +
          " Sold Prices " +
          row['soldPrices'] +
          " Birr ";
    }
/**
 * content = content +
          "\n የእቃው ስም፡ " +
          row['brandName'] +
          " : "
              " የተገዛበት ዋጋ፡ " +
          row['buyPrices'] +
          " የተሽጠበት ዋጋ፡ " +
          row['soldPrices'] +
          " ብር ";
    });
 */

    pdf.addPage(
      
      MultiPage(

        pageFormat: PdfPageFormat.a4,
        header: (context) => Text("Pdf Report"),
        // maxPages: 10,
        footer: (context) => Text("BY Meshu"),
        build: (context) {
          return [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: PdfColors.deepPurpleAccent)),
                      child: Text(
                        "Today",
                        style: style1,
                        textAlign: TextAlign.center,
                      )),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  // Text(
                  //   // '${data.length}',
                  //   content,
                  //   style: style1,
                  // ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text("Total Sell $totalSell Birr", style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    "Total Item amount $totalBuy Birr",
                    style: style1,
                  ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    "Total Profite before ${totalSell - totalBuy} Birr",
                    style: style1,
                  ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text('Montly Expens  $total Birr', style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text('Daily Expenes  $expenes Birr', style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    'Total Profit ${(totalSell - totalBuy) - (total + expenes)} Birr',
                    style: style1,
                  ),
                ],
              ),
            )
          ];
        }));

    var lastPdf = await savePdf(pdf, report);
    return lastPdf;
  }

  static Future<File> savePdf(Document pdf, String report) async {
    var bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/report .pdf');
    var lastPdf = await file.writeAsBytes(bytes);
    return lastPdf;
  }
}
