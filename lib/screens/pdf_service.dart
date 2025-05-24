import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:asset_tracker_app/models/asset.dart';

class PdfService {
  static Future<void> generateAssetReport(List<Asset> assets) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, text: 'Asset Tracking Report'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['ID', 'Name', 'Serial', 'Status', 'Barcode'],
                  ...assets.map((asset) => [
                    asset.id.toString(),
                    asset.name,
                    asset.serialNumber,
                    asset.status,
                    asset.barcode ?? '',
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}