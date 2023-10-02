import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_barang_bengkel/controllers/jualbarangscreen_provider.dart';
import 'package:management_barang_bengkel/models/barang.dart';
import 'package:provider/provider.dart';

class JualBarangScreen extends StatefulWidget {
  const JualBarangScreen({super.key});

  @override
  State<JualBarangScreen> createState() => _JualBarangScreenState();
}

class _JualBarangScreenState extends State<JualBarangScreen> {
  @override
  void initState() {
    Provider.of<JualBarangScreenProvider>(context, listen: false).fetchBarang();
    super.initState();
  }

  final _formKey2 = GlobalKey<FormState>();
  final _formkey = GlobalKey<FormState>();
  final _kurangiStokController = TextEditingController();
  final _tambahStokController = TextEditingController();
  final _updatedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Tambah & Jual Stok Barang',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                onChanged: (value) {
                  Provider.of<JualBarangScreenProvider>(context, listen: false)
                      .searchBarang(value);
                },
                decoration: const InputDecoration(
                    hintText: 'Search Barang',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<JualBarangScreenProvider>(
                builder: (context, listbarangscreenprovider, _) {
                  if (listbarangscreenprovider.listBarang.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada barang'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: listbarangscreenprovider.listBarang.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // display detail barang
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Detail Barang'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Nama Barang : ${listbarangscreenprovider.listBarang[index].namaBarang}'),
                                      Text(
                                          'Harga Barang : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(listbarangscreenprovider.listBarang[index].hargaBarang)}'),
                                      Text(
                                          'Jumlah Barang : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                      Text(
                                          'Total Harga : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(listbarangscreenprovider.listBarang[index].hargaBarang * listbarangscreenprovider.listBarang[index].jmlBarang)}'),
                                      Text(
                                          'Dibuat pada : ${DateFormat.yMMMMEEEEd().format(listbarangscreenprovider.listBarang[index].createdAt!)}'),
                                      Text(
                                          'Diupdate pada : ${DateFormat.yMMMMEEEEd().format(listbarangscreenprovider.listBarang[index].updatedAt)}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Tutup'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                                title: Row(
                                  // beetwen
                                  children: [
                                    Expanded(
                                      child: Text(
                                          listbarangscreenprovider
                                              .listBarang[index].namaBarang,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                    'Stok : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Tambah Stok'),
                                              content: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Nama Barang : ${listbarangscreenprovider.listBarang[index].namaBarang}',
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                        'Total Stok : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                                    const SizedBox(height: 16),
                                                    Form(
                                                      key: _formKey2,
                                                      child: TextFormField(
                                                        controller:
                                                            _tambahStokController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Tambah Stok'),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Harap Masukkan Jumlah Penambahan Stok';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    if (_formKey2.currentState!
                                                        .validate()) {
                                                      var tambahStok =
                                                          _tambahStokController
                                                              .text;

                                                      Provider.of<JualBarangScreenProvider>(
                                                              context,
                                                              listen: false)
                                                          .updateBarang(
                                                        Barang(
                                                          id: listbarangscreenprovider
                                                              .listBarang[index]
                                                              .id,
                                                          namaBarang:
                                                              listbarangscreenprovider
                                                                  .listBarang[
                                                                      index]
                                                                  .namaBarang,
                                                          hargaBarang:
                                                              listbarangscreenprovider
                                                                  .listBarang[
                                                                      index]
                                                                  .hargaBarang,
                                                          jmlBarang:
                                                              listbarangscreenprovider
                                                                      .listBarang[
                                                                          index]
                                                                      .jmlBarang +
                                                                  int.parse(
                                                                      tambahStok),
                                                          updatedAt: _updatedAt,
                                                        ),
                                                      );

                                                      // clear all the values
                                                      _tambahStokController
                                                          .clear();

                                                      // make notification after adding data
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Stok berhasil ditambahkan'),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Simpan'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Jual Stok'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Nama Barang : ${listbarangscreenprovider.listBarang[index].namaBarang}',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                          'Total Stok : ${listbarangscreenprovider.listBarang[index].jmlBarang}'),
                                                      const SizedBox(
                                                          height: 16),
                                                      Form(
                                                        key: _formkey,
                                                        child: TextFormField(
                                                          controller:
                                                              _kurangiStokController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Jual Stok'),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Harap Masukkan Jumlah Penambahan Stok';
                                                            }
                                                            if (int.parse(
                                                                    value) >
                                                                listbarangscreenprovider
                                                                    .listBarang[
                                                                        index]
                                                                    .jmlBarang) {
                                                              return 'Jumlah stok kurang';
                                                            }

                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (_formkey.currentState!
                                                          .validate()) {
                                                        var kurangiStok =
                                                            _kurangiStokController
                                                                .text;

                                                        Provider.of<JualBarangScreenProvider>(
                                                                context,
                                                                listen: false)
                                                            .updateBarang(
                                                          Barang(
                                                            id: listbarangscreenprovider
                                                                .listBarang[
                                                                    index]
                                                                .id,
                                                            namaBarang:
                                                                listbarangscreenprovider
                                                                    .listBarang[
                                                                        index]
                                                                    .namaBarang,
                                                            hargaBarang:
                                                                listbarangscreenprovider
                                                                    .listBarang[
                                                                        index]
                                                                    .hargaBarang,
                                                            jmlBarang: listbarangscreenprovider
                                                                    .listBarang[
                                                                        index]
                                                                    .jmlBarang -
                                                                int.parse(
                                                                    kurangiStok),
                                                            updatedAt:
                                                                _updatedAt,
                                                          ),
                                                        );

                                                        // clear all the values
                                                        _kurangiStokController
                                                            .clear();

                                                        // make notification after adding data
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Stok berhasil dijual'),
                                                          ),
                                                        );

                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Text('Simpan'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.remove)),
                                  ],
                                )),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
