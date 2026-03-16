import 'package:flutter/material.dart';
import 'package:sibaruki_mobile/repositories/rtlh_repository.dart';

class RtlhProvider extends ChangeNotifier {
  final RtlhRepository _repository = RtlhRepository();

  List<Map<String, dynamic>> _penerimaList = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Map<String, dynamic>> get penerimaList => _penerimaList;
  bool get isLoading => _isLoading;

  Future<void> fetchPenerima({String? query}) async {
    _isLoading = true;
    _searchQuery = query ?? '';
    notifyListeners();

    try {
      _penerimaList = await _repository.getAllPenerima(query: query);
    } catch (e) {
      debugPrint('Error fetch penerima: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ambil detail survei untuk form
  Future<Map<String, dynamic>?> getSurvei(String nik) async {
    return await _repository.getSurveiByNik(nik);
  }

  // Ambil referensi dropdown
  Future<List<Map<String, dynamic>>> getReferensi(String kategori) async {
    return await _repository.getReferensiByCategory(kategori);
  }

  // Simpan Survei
  Future<void> saveSurvei(Map<String, dynamic> data) async {
    await _repository.saveSurvei(data);
    await refresh(); // Refresh list agar status 'pending' muncul
  }

  // Refresh data tanpa parameter query sebelumnya
  Future<void> refresh() async {
    await fetchPenerima(query: _searchQuery);
  }
}
