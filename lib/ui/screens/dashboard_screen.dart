import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibaruki_mobile/core/app_theme.dart';
import 'package:sibaruki_mobile/providers/auth_provider.dart';
import 'package:sibaruki_mobile/providers/sync_provider.dart';
import 'package:sibaruki_mobile/ui/screens/rtlh_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final syncProvider = context.watch<SyncProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIBARUKI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.secondaryBlue,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.username ?? 'Surveyor',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryNavy,
                          ),
                        ),
                        Text(
                          user?.roleName ?? 'Staff',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Sync Status Card
            Card(
              color: AppTheme.primaryNavy,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SINKRONISASI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (syncProvider.isSyncing)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          const Icon(Icons.cloud_done, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: syncProvider.progress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last Sync: ${syncProvider.lastSync ?? 'Belum pernah'}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        TextButton(
                          onPressed: syncProvider.isSyncing 
                            ? null 
                            : () => syncProvider.syncAll(user?.roleScope ?? 'local'),
                          child: const Text('TARIK DATA', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'MENU UTAMA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryNavy,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            
            // Menu Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  title: 'RTLH',
                  subtitle: 'Rumah Tidak Layak Huni',
                  icon: Icons.home_work_rounded,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RtlhListScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'INFRASTRUKTUR',
                  subtitle: 'Aset & Bangunan',
                  icon: Icons.foundation,
                  color: Colors.green,
                  onTap: () {
                    // TODO: Navigate to Infrastruktur
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'WILAYAH KUMUH',
                  subtitle: 'Pemetaan GIS',
                  icon: Icons.map_rounded,
                  color: Colors.purple,
                  onTap: () {
                    // TODO: Navigate to Kumuh
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'SINKRONKAN',
                  subtitle: 'Upload Offline Data',
                  icon: Icons.sync_rounded,
                  color: Colors.blue,
                  onTap: () {
                    // TODO: Navigate to Sync Screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryNavy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
