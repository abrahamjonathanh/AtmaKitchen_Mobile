import 'dart:convert';

import 'package:atmakitchen_mobile/domain/bahanbaku.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:atmakitchen_mobile/preview_screen.dart';
import 'package:atmakitchen_mobile/data/bahan_baku_client.dart';

class PdfView extends StatefulWidget {
  const PdfView({
    super.key,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final pdf = pw.Document();

  final pw.TextStyle pdfTitleStyle = pw.TextStyle(
    fontSize: 18,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.black,
  );

  final pw.TextStyle pdfContentStyle = const pw.TextStyle(
    fontSize: 14,
    color: PdfColors.black,
  );

  Future<List<BahanBaku>>? bahanBaku;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID').then((_) {
      getAllBahanBaku();
    });
  }

  void getAllBahanBaku() async {
    var response = await BahanBakuClient.getAllBahanBaku();

    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<BahanBaku> bahanBakuData = (data['data'] as List)
          .map((item) => BahanBaku.fromJson(item))
          .toList();

      setState(() {
        bahanBaku = Future.value(bahanBakuData);
      });

      createPdf(bahanBakuData);
    }
  }

  Future<void> createPdf(List<BahanBaku> bahanBakuData) async {
    final formattedDate = formatDateString(DateTime.now());
    const itemsPerPage = 15;

    final List<List<BahanBaku>> dividedBahanBaku = List.generate(
      (bahanBakuData.length / itemsPerPage).ceil(),
      (index) => bahanBakuData.sublist(
        index * itemsPerPage,
        (index + 1) * itemsPerPage,
      ),
    );

    for (int i = 0; i < dividedBahanBaku.length; i++) {
      pdf.addPage(pw.MultiPage(
        build: (pw.Context context) {
          final List<pw.Widget> pageContent = [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (i == 0) pw.Text("Atma Kitchen", style: pdfTitleStyle),
                if (i == 0)
                  pw.Text("Jl. Centralpark No. 10 Yogyakarta",
                      style: pdfContentStyle),
                if (i == 0) pw.SizedBox(height: 20.0),
                if (i == 0)
                  pw.Text("LAPORAN Stok Bahan Baku", style: pdfTitleStyle),
                if (i == 0)
                  pw.Text("Tanggal cetak: $formattedDate",
                      style: pdfContentStyle),
                pw.SizedBox(height: 20.0),
                pw.TableHelper.fromTextArray(
                  headers: ['Nama Bahan', 'Satuan', 'Stok'],
                  data: dividedBahanBaku[i]
                      .map(
                        (bahan) => [
                          bahan.nama,
                          bahan.satuan,
                          bahan.stok.toString(),
                        ],
                      )
                      .toList(),
                ),
              ],
            )
          ];

          return pageContent;
        },
      ));
    }
  }

  String formatDateString(DateTime date) {
    initializeDateFormatting('id_ID');

    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tampil Laporan'),
      ),
      body: Center(
        child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(doc: pdf),
                ));
          },
          child: const Text('Tampilkan Laporan',
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
