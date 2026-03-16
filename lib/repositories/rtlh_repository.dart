import 'package:sibaruki_mobile/services/database_helper.dart';

class RtlhRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Ambil semua data penerima dari lokal
  Future<List<Map<String, dynamic>>> getAllPenerima({String? query}) async {
    final db = await _dbHelper.database;
    if (query != null && query.isNotEmpty) {
      return await db.query(
        'rtlh_penerima',
        where: 'nama_kepala_keluarga LIKE ? OR nik LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'nama_kepala_keluarga ASC',
      );
    }
    return await db.query('rtlh_penerima', orderBy: 'nama_kepala_keluarga ASC');
  }

  // Ambil detail survei berdasarkan NIK
  Future<Map<String, dynamic>?> getSurveiByNik(String nik) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'rtlh_survei',
      where: 'nik_penerima = ?',
      whereArgs: [nik],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Ambil data dropdown berdasarkan kategori
  Future<List<Map<String, dynamic>>> getReferensiByCategory(String kategori) async {
    final db = await _dbHelper.database;
    return await db.query(
      'referensi',
      where: 'kategori = ?',
      whereArgs: [kategori],
      orderBy: 'label ASC',
    );
  }

  // Simpan atau Update data survei (Offline)
  Future<void> saveSurvei(Map<String, dynamic> data) async {
    // Sanitasi NIK (Mandat GEMINI.md)
    if (data['nik_penerima'] != null) {
      data['nik_penerima'] = data['nik_penerima'].toString().replaceAll(RegExp(r'[^0-9]'), '');
    }
    
    data['is_pending'] = 1; // Tandai untuk disinkronkan nanti
    data['updated_at'] = DateTime.now().toString().substring(0, 19);

    await _dbHelper.insert('rtlh_survei', data);
    
    // Log Aktivitas (Audit Trail)
    await _dbHelper.insert('sys_logs_mobile', {
      'action': 'SAVE_RTLH',
      'nik_terkait': data['nik_penerima'],
      'timestamp': data['updated_at'],
      'details': 'Surveyor mengupdate data rumah secara offline',
    });
  }
}
