import 'dart:convert';

import 'package:atmakitchen_mobile/domain/transaksi_penitip.dart';
import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:atmakitchen_mobile/preview_screen.dart';
import 'package:atmakitchen_mobile/data/report_client.dart';

class PdfViewTransaksiPenitip extends StatefulWidget {
  final int year;
  final int month;

  const PdfViewTransaksiPenitip({
    Key? key,
    required this.year,
    required this.month,
  }) : super(key: key);

  @override
  State<PdfViewTransaksiPenitip> createState() =>
      _PdfViewTransaksiPenitipState();
}

class _PdfViewTransaksiPenitipState extends State<PdfViewTransaksiPenitip> {
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

  Future<List<TransaksiPenitip>>? transaksiPenitipList;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID').then((_) {
      getAllTransaksiPenitip();
    });
  }

  void getAllTransaksiPenitip() async {
    var response =
        await ReportClient.getTransaksiPenitip(widget.year, widget.month);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = jsonDecode(response.body);
      List<TransaksiPenitip> transaksiPenitips =
          data.map((item) => TransaksiPenitip.fromJson(item)).toList();

      setState(() {
        transaksiPenitipList = Future.value(transaksiPenitips);
      });

      createPdf(transaksiPenitips);
    } else {
      // Handle error
      setState(() {
        transaksiPenitipList = Future.error("Failed to load data");
      });
    }
  }

  Future<void> createPdf(List<TransaksiPenitip> transaksiPenitips) async {
    final formattedDate = formatDateString(DateTime.now());
    final formattedMonth = formatMonthString(widget.month);

    for (var transaksiPenitip in transaksiPenitips) {
      pdf.addPage(pw.MultiPage(
        build: (pw.Context context) {
          var totalYangDiterima = 0;
          var transaksiAvailable = transaksiPenitip.transaksi.isNotEmpty;

          if (transaksiAvailable) {
            totalYangDiterima = transaksiPenitip.transaksi
                .map((transaksi) => transaksi.yangDiterima)
                .reduce((value, element) => value + element);
          }

          var tableData = transaksiPenitip.transaksi
              .map((transaksi) => [
                    transaksi.namaProduk,
                    transaksi.qty.toString(),
                    CurrencyFormat.convertToIdr(transaksi.hargaJual, 0),
                    CurrencyFormat.convertToIdr(transaksi.total, 0),
                    CurrencyFormat.convertToIdr(transaksi.komisi, 0),
                    CurrencyFormat.convertToIdr(transaksi.yangDiterima, 0),
                  ])
              .toList();

          if (transaksiAvailable) {
            tableData.add([
              '',
              '',
              '',
              '',
              'Total',
              CurrencyFormat.convertToIdr(totalYangDiterima, 0),
            ]);
          }

          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Atma Kitchen", style: pdfTitleStyle),
                pw.Text("Jl. Centralpark No. 10 Yogyakarta",
                    style: pdfContentStyle),
                pw.SizedBox(height: 20.0),
                pw.Text("LAPORAN TRANSAKSI PENITIP", style: pdfTitleStyle),
                pw.Text("Tahun: ${widget.year}", style: pdfContentStyle),
                pw.Text("Bulan: $formattedMonth", style: pdfContentStyle),
                pw.Text("Tanggal cetak: $formattedDate",
                    style: pdfContentStyle),
                pw.Text("ID Penitip: ${transaksiPenitip.idPenitip}",
                    style: pdfContentStyle),
                pw.Text("Nama Penitip: ${transaksiPenitip.namaPenitip}",
                    style: pdfContentStyle),
                pw.SizedBox(height: 10.0),
                pw.TableHelper.fromTextArray(
                  headers: [
                    'Nama Produk',
                    'Qty',
                    'Harga Jual',
                    'Total',
                    '20% Komisi',
                    'Yang Diterima'
                  ],
                  data: tableData,
                ),
                pw.SizedBox(height: 20.0),
              ],
            ),
          ];
        },
      ));
    }
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
