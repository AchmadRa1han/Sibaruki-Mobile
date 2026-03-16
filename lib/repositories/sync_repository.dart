import 'package:sibaruki_mobile/services/api_service.dart';
import 'package:sibaruki_mobile/services/database_helper.dart';

class SyncRepository {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // 1. Pull References (Master Data)
  Future<void> syncMasterData() async {
    try {
      final response = await _apiService.get('/master/referensi');
      if (response.data['status'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        
        // Loop through categories (pekerjaan, pendidikan, etc)
        for (var category in data.keys) {
          final items = data[category] as List;
          for (var item in items) {
            await _dbHelper.insert('referensi', {
              'kategori': category,
              'label': item['label'],
              'value': item['value'],
            });
          }
        }
      }
    } catch (e) {
      // Log or handle error
      rethrow;
    }
  }

  // 2. Fetch Desa based on role
  Future<void> syncDesaList(String roleScope) async {
    try {
      final response = await _apiService.get('/master/desa', queryParameters: {'category': 'rtlh'});
      if (response.data['status'] == true) {
        final items = response.data['data'] as List;
        for (var item in items) {
          await _dbHelper.insert('referensi', {
            'kategori': 'desa',
            'label': item['nama_desa'],
            'value': item['id'].toString(),
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // 3. Incremental Pull RTLH
  Future<void> pullRtlhData(String lastSyncDate, int desaId) async {
    try {
      final response = await _apiService.get('/rtlh', queryParameters: {
        'last_sync': lastSyncDate,
        'desa_id': desaId,
      });
      
      if (response.data['status'] == true) {
        final items = response.data['data'] as List;
        for (var item in items) {
          // Sync to Local SQLite
          await _dbHelper.insert('rtlh_penerima', {
            'nik': item['penerima']['nik'],
            'nama_kepala_keluarga': item['penerima']['nama_kepala_keluarga'],
            'alamat': item['penerima']['alamat'],
            'is_pending': 0, // Mark as synced
            'updated_at': item['updated_at'],
          });
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
