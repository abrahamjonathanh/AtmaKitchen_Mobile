import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atmakitchen_mobile/data/saldo_client.dart';

class PenarikanSaldoScreen extends StatefulWidget {
  final double totalSaldo;
  final String idAkun;

  const PenarikanSaldoScreen({
    Key? key,
    required this.totalSaldo,
    required this.idAkun,
  }) : super(key: key);

  @override
  State<PenarikanSaldoScreen> createState() => _PenarikanSaldoScreenState();
}

class _PenarikanSaldoScreenState extends State<PenarikanSaldoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _nomorRekeningController = TextEditingController();
  String _selectedBank = 'bca'; // Bank default

  late double _totalSaldo;

  @override
  void initState() {
    super.initState();
    _totalSaldo = widget.totalSaldo; // Menggunakan parameter yang diberikan
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final double jumlahPenarikan =
          double.tryParse(_jumlahController.text) ?? 0;
      if (jumlahPenarikan > _totalSaldo) {
        Get.snackbar(
          'Error',
          'Jumlah penarikan melebihi total saldo',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (jumlahPenarikan <= 0) {
        Get.snackbar(
          'Error',
          'Jumlah penarikan harus lebih dari 0',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Pengiriman data ke server
      final Map<String, dynamic> payload = {
        "id_akun": widget.idAkun,
        "jumlah_penarikan":
            jumlahPenarikan.toString(), // Ubah ke string untuk JSON
        "nama_bank": _selectedBank,
        "nomor_rekening": _nomorRekeningController.text,
        "status": "menunggu",
      };

      try {
        final response = await SaldoClient.withdrawSaldo(payload);
        print('Server response: ${response.statusCode}');
        print('Server response body: ${response.body}');

        if (response.statusCode == 200) {
          Get.dialog(
            AlertDialog(
              title: const Text('Success'),
              content: const Text('Penarikan berhasil'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(); // Close the dialog
                    Get.back(
                        result:
                            true); // Navigasi kembali setelah pengiriman sukses
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            'Gagal menarik saldo. Silakan coba lagi.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal menarik saldo: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penarikan Saldo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _jumlahController,
                decoration:
                    const InputDecoration(labelText: 'Jumlah Penarikan'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah penarikan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Nama Bank'),
                value: _selectedBank,
                onChanged: (newValue) {
                  setState(() {
                    _selectedBank = newValue!;
                  });
                },
                items: <String>['bca', 'mandiri']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nomorRekeningController,
                decoration: const InputDecoration(labelText: 'Nomor Rekening'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor rekening';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
