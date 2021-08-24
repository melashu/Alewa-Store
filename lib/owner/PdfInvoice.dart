import 'dart:io';
import 'dart:typed_data';
import 'package:boticshop/Utility/report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class PdfInvoice {
    // final font = await rootBundle.load("assets/hind.ttf");
   Uint8List fontData = File('asset/op.ttf').readAsBytesSync();
  final ttf = Font.ttf(PdfInvoice().fontData.buffer.asByteData());

  static get style1 => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        font: PdfInvoice().ttf
      );

  static Future<File> generatePDF(
      List data, String date, double expenes, String report) async {
 

    var pdf = Document();
    var total = Report.getDailyExpenessPerMonth() / 30;
    var content = '';
    var totalBuy = 0.0;
    var totalSell = 0.0;
    data.forEach((row) {
      totalBuy = totalBuy +
          (double.parse(row['buyPrices']) * int.parse(row['amount']));
      totalSell = totalSell +
          (double.parse(row['soldPrices']) * int.parse(row['amount']));

      content = content +
          "\n የእቃው ስም፡ " +
          row['brandName'] +
          " : "
              " የተገዛበት ዋጋ፡ " +
          row['buyPrices'] +
          " የተሽጠበት ዋጋ፡ " +
          row['soldPrices'] +
          " ብር ";
    });
// pdf.addPage(Page(build: build))

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => Text("Pdf Report"),
        footer: (context) => Text("BY Meshu"),
        build: (context) {
          return [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: PdfColors.deepPurpleAccent)),
                      child: Text(
                        date,
                        style: style1,
                        textAlign: TextAlign.center,
                      )),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    content,
                    style: style1,
                  ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text("አጠቃላይ ሽያጭ: $totalSell ብር", style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    "አጠቃላይ እቃው የተገዛበት: $totalBuy ብር",
                    style: style1,
                  ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    "አጠቃላይ ያልተጣራ ትርፍ: ${totalSell - totalBuy} ብር",
                    style: style1,
                  ),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text('ወርሃዊ ወጭ፡  $total ብር', style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text('ዕለታዊ ወጭ፡  $expenes ብር', style: style1),
                  Divider(
                    thickness: 1,
                    color: PdfColors.deepPurpleAccent,
                  ),
                  Text(
                    'የተጣራ ትርፍ ${(totalSell - totalBuy) - (total + expenes)} ብር',
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
    final file = File('${dir.path}/$report .pdf');
    var lastPdf = await file.writeAsBytes(bytes);
    return lastPdf;
  }
}
