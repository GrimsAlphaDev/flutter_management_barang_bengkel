import 'package:flutter/material.dart';
import 'package:management_barang_bengkel/controllers/belibarangscreen_provider.dart';
import 'package:management_barang_bengkel/controllers/listbarangscreen_provider.dart';
import 'package:management_barang_bengkel/models/barang.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BeliBarangScreen extends StatefulWidget {
  const BeliBarangScreen({super.key});

  @override
  State<BeliBarangScreen> createState() => _BeliBarangScreenState();
}

class _BeliBarangScreenState extends State<BeliBarangScreen> {
  @override
  void initState() {
    Provider.of<BeliBarangScreenProvider>(context, listen: false)
        .getListBarang();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _hargaBarangController = TextEditingController();
  final _jumlahBarangController = TextEditingController();
  final _createdAt = DateTime.now();
  final _updatedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24),
              const Text(
                'Beli Barang Baru',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _namaBarangController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap Masukkan Nama Barang';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaBarangController,
                decoration: const InputDecoration(labelText: 'Harga Barang'),
                // accept only numbers
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap Masukkan Harga Barang';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jumlahBarangController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap Masukkan Jumlah Barang';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 34),
              ElevatedButton(
                // make the button bigger
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var namaBarang = _namaBarangController.text;
                    var hargaBarang = _hargaBarangController.text;
                    var jumlahBarang = _jumlahBarangController.text;

                    // if namaBarang alredy exist in the database then show error
                    var isExist = Provider.of<ListBarangScreenProvider>(context,
                            listen: false)
                        .listBarang
                        .any((element) =>
                            element.namaBarang.toLowerCase() ==
                            namaBarang.toLowerCase());

                    if (isExist) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Barang sudah ada di list'),
                        ),
                      );
                      return;
                    }

                    Provider.of<ListBarangScreenProvider>(context,
                            listen: false)
                        .addBarang(
                      Barang(
                        id: uuid.v4(),
                        namaBarang: namaBarang,
                        hargaBarang: int.parse(hargaBarang),
                        jmlBarang: int.parse(jumlahBarang),
                        createdAt: _createdAt,
                        updatedAt: _updatedAt,
                      ),
                    );

                    // clear all the values
                    _namaBarangController.clear();
                    _hargaBarangController.clear();
                    _jumlahBarangController.clear();

                    // make notification after adding data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil ditambahkan'),
                      ),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
