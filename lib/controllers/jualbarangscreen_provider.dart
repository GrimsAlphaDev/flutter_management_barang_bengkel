import 'package:flutter/material.dart';
import 'package:management_barang_bengkel/helper/db_helper.dart';
import 'package:management_barang_bengkel/models/barang.dart';

class JualBarangScreenProvider extends ChangeNotifier {
  late DBHelper dbHelper;

  List<Barang> _listBarang = [];

  JualBarangScreenProvider(this.dbHelper) {
    fetchBarang();
  }

  List<Barang> get listBarang => _listBarang;

  void fetchBarang() async {
    _listBarang = await dbHelper.getBarang();
    notifyListeners();
  }

  void updateBarang(Barang barang) async {
    await dbHelper.update(barang);
    fetchBarang();
  }

  void searchBarang(String query) async {
    _listBarang = await dbHelper.searchBarang(query);
    notifyListeners();
  }
}
