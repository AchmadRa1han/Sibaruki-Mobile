import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibaruki_mobile/core/app_constants.dart';
import 'package:sibaruki_mobile/repositories/sync_repository.dart';

class SyncProvider extends ChangeNotifier {
  final SyncRepository _repository = SyncRepository();
  
  bool _isSyncing = false;
  double _progress = 0;
  String? _lastSync;

  bool get isSyncing => _isSyncing;
  double get progress => _progress;
  String? get lastSync => _lastSync;

  SyncProvider() {
    _loadLastSync();
  }

  Future<void> _loadLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSync = prefs.getString(AppConstants.lastSyncKey);
    notifyListeners();
  }

  Future<void> syncAll(String roleScope) async {
    _isSyncing = true;
    _progress = 0.1;
    notifyListeners();

    try {
      // 1. Sync Master Data (References)
      await _repository.syncMasterData();
      _progress = 0.4;
      notifyListeners();

      // 2. Sync Desa List
      await _repository.syncDesaList(roleScope);
      _progress = 0.6;
      notifyListeners();

      // 3. Update Last Sync Date
      final now = DateTime.now().toString().substring(0, 19);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.lastSyncKey, now);
      _lastSync = now;
      
      _progress = 1.0;
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _isSyncing = false;
      notifyListeners();
      rethrow;
    }
  }
}
