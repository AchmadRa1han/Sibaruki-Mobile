import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibaruki_mobile/core/app_theme.dart';
import 'package:sibaruki_mobile/providers/rtlh_provider.dart';

class RtlhFormScreen extends StatefulWidget {
  final Map<String, dynamic> penerima;
  const RtlhFormScreen({super.key, required this.penerima});

  @override
  State<RtlhFormScreen> createState() => _RtlhFormScreenState();
}

class _RtlhFormScreenState extends State<RtlhFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for numeric fields
  final _luasBangunanController = TextEditingController();
  final _jumlahPenghuniController = TextEditingController();
  
  // Dropdown values
  String? _stAtap;
  String? _stLantai;
  String? _stDinding;
  String? _stPondasi;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final provider = context.read<RtlhProvider>();
    final existingData = await provider.getSurvei(widget.penerima['nik']);
    
    if (existingData != null) {
      setState(() {
        _luasBangunanController.text = existingData['luas_bangunan']?.toString() ?? '';
        _jumlahPenghuniController.text = existingData['jumlah_penghuni']?.toString() ?? '';
        _stAtap = existingData['st_atap'];
        _stLantai = existingData['st_lantai'];
        _stDinding = existingData['st_dinding'];
        _stPondasi = existingData['st_pondasi'];
      });
    }
    
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _luasBangunanController.dispose();
    _jumlahPenghuniController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nik_penerima': widget.penerima['nik'],
        'luas_bangunan': double.tryParse(_luasBangunanController.text),
        'jumlah_penghuni': int.tryParse(_jumlahPenghuniController.text),
        'st_atap': _stAtap,
        'st_lantai': _stLantai,
        'st_dinding': _stDinding,
        'st_pondasi': _stPondasi,
      };

      await context.read<RtlhProvider>().saveSurvei(data);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan secara lokal')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Update Data RTLH')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card (Penerima)
              _buildSectionTitle('DATA PENERIMA'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.penerima['nama_kepala_keluarga'] ?? 'Tanpa Nama', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryNavy)),
                      const SizedBox(height: 4),
                      Text('NIK: ${widget.penerima['nik']}', style: const TextStyle(color: Colors.grey)),
                      const Divider(height: 24),
                      Text(widget.penerima['alamat'] ?? 'Alamat belum tersedia', style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Conditions
              _buildSectionTitle('KONDISI FISIK RUMAH'),
              _buildFormCard([
                _buildNumberField('Luas Bangunan (m2)', _luasBangunanController),
                const SizedBox(height: 16),
                _buildNumberField('Jumlah Penghuni', _jumlahPenghuniController),
                const SizedBox(height: 16),
                _buildDropdownField('Kondisi Atap', _stAtap, ['Baik', 'Rusak Ringan', 'Rusak Berat'], (val) => setState(() => _stAtap = val)),
                const SizedBox(height: 16),
                _buildDropdownField('Kondisi Lantai', _stLantai, ['Semen', 'Tanah', 'Keramik'], (val) => setState(() => _stLantai = val)),
                const SizedBox(height: 16),
                _buildDropdownField('Kondisi Dinding', _stDinding, ['Bata', 'Kayu/Bambu', 'Lainnya'], (val) => setState(() => _stDinding = val)),
              ]),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('SIMPAN SURVEI'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1, color: AppTheme.primaryNavy, fontSize: 12)),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, hintText: '0'),
      validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Pilih salah satu' : null,
    );
  }
}
