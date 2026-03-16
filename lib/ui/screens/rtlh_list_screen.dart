import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibaruki_mobile/core/app_theme.dart';
import 'package:sibaruki_mobile/providers/rtlh_provider.dart';
import 'package:sibaruki_mobile/ui/screens/rtlh_form_screen.dart';

class RtlhListScreen extends StatefulWidget {
  const RtlhListScreen({super.key});

  @override
  State<RtlhListScreen> createState() => _RtlhListScreenState();
}

class _RtlhListScreenState extends State<RtlhListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RtlhProvider>().fetchPenerima();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar RTLH'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => context.read<RtlhProvider>().fetchPenerima(query: value),
              decoration: InputDecoration(
                hintText: 'Cari Nama atau NIK...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<RtlhProvider>().fetchPenerima();
                  },
                ),
              ),
            ),
          ),
          
          // List Data
          Expanded(
            child: Consumer<RtlhProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.penerimaList.isEmpty) {
                  return const Center(
                    child: Text('Data tidak ditemukan atau belum ditarik.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.penerimaList.length,
                  itemBuilder: (context, index) {
                    final item = provider.penerimaList[index];
                    return _buildRtlhCard(context, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtlhCard(BuildContext context, Map<String, dynamic> item) {
    final bool isSynced = item['is_pending'] == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RtlhFormScreen(penerima: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusExtrem),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSynced ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isSynced ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                  color: isSynced ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama_kepala_keluarga'] ?? 'Tanpa Nama',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.primaryNavy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIK: ${item['nik']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['alamat'] ?? '-',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
