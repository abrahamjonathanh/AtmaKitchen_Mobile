import 'dart:convert';

import 'package:atmakitchen_mobile/domain/pengeluaran_pemasukan.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:atmakitchen_mobile/preview_screen.dart';
import 'package:atmakitchen_mobile/data/report_client.dart';

class PdfViewPemasukanPengeluaran extends StatefulWidget {
  final int year;
  final int month;

  const PdfViewPemasukanPengeluaran({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  State<PdfViewPemasukanPengeluaran> createState() =>
      _PdfViewPemasukanPengeluaranState();
}

class _PdfViewPemasukanPengeluaranState
    extends State<PdfViewPemasukanPengeluaran> {
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

  Future<PengeluaranPemasukan>? pengeluaranPemasukan;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID').then((_) {
      getAllPemasukanPengeluaran();
    });
  }

  void getAllPemasukanPengeluaran() async {
    var response =
        await ReportClient.getPengeluaranPemasukkan(widget.year, widget.month);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      PengeluaranPemasukan pengeluaranPemasukanData =
          PengeluaranPemasukan.fromJson(data);

      setState(() {
        pengeluaranPemasukan = Future.value(pengeluaranPemasukanData);
      });

      createPdf(pengeluaranPemasukanData);
    } else {
      // Handle error
      setState(() {
        pengeluaranPemasukan = Future.error("Failed to load data");
      });
    }
  }

  Future<void> createPdf(PengeluaranPemasukan data) async {
    final formattedDate = formatDateString(DateTime.now());
    final formattedMonth = formatMonthString(widget.month);

    // Merging pemasukan and pengeluaran into a single list of maps
    final List<Map<String, String>> combinedList = [];

    data.pemasukan?.forEach((item) {
      combinedList.add({
        "description": item.keys.first,
        "pemasukan": item.values.first.toString(),
        "pengeluaran": "-"
      });
    });

    data.pengeluaran?.forEach((item) {
      combinedList.add({
        "description": item.keys.first,
        "pemasukan": "-",
        "pengeluaran": item.values.first.toString()
      });
    });

    pdf.addPage(pw.MultiPage(
      build: (pw.Context context) {
        return [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Atma Kitchen", style: pdfTitleStyle),
              pw.Text("Jl. Centralpark No. 10 Yogyakarta",
                  style: pdfContentStyle),
              pw.SizedBox(height: 20.0),
              pw.Text("LAPORAN PEMASUKAN DAN PENGELUARAN",
                  style: pdfTitleStyle),
              pw.Text("Tahun: ${widget.year}", style: pdfContentStyle),
              pw.Text("Bulan: $formattedMonth", style: pdfContentStyle),
              pw.Text("Tanggal cetak: $formattedDate", style: pdfContentStyle),
              pw.SizedBox(height: 20.0),
              pw.TableHelper.fromTextArray(
                headers: ['', 'Pemasukan', 'Pengeluaran'],
                data: [
                  ...combinedList.map((item) => [
                        item['description'],
                        item['pemasukan'],
                        item['pengeluaran'],
                      ]),
                  [
                    'Total',
                    data.totalPemasukan.toString(),
                    data.totalPengeluaran.toString()
                  ],
                ],
              ),
              pw.SizedBox(height: 20.0),
            ],
          ),
        ];
      },
    ));
  }

  String formatDateString(DateTime date) {
    initializeDateFormatting('id_ID');

    final formatter = DateFormat('d MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  String formatMonthString(int month) {
    initializeDateFormatting('id_ID');

    final formatter = DateFormat('MMMM', 'id_ID');
    final date = DateTime(0, month);
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
