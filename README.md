# SIBARUKI Mobile

Aplikasi mobile berbasis **Flutter** untuk platform **Single Data Portal (SIBARUKI)**. Aplikasi ini dirancang khusus untuk membantu surveyor melakukan survei lapangan secara mandiri (offline) dan mensinkronisasikan data ke server pusat (online).

## 🚀 Fitur Utama
- **API-Driven Interface:** Terhubung langsung ke API SIBARUKI v1.
- **Offline First:** Pengisian data survei dan pengambilan foto tetap dapat dilakukan tanpa koneksi internet menggunakan **SQLite**.
- **Batch Synchronization:** Unggah hasil survei massal dari lokal ke server secara efisien.
- **GIS Integration:** Mendukung visualisasi dan pengambilan titik koordinat (WKT) menggunakan **OpenStreetMap (Satellite View)**.
- **Audit Trail:** Pencatatan log aktivitas surveyor untuk keamanan data.

## 🛠️ Tech Stack
- **Framework:** Flutter (Android & iOS)
- **State Management:** Provider
- **Local Database:** sqflite (SQLite)
- **HTTP Client:** Dio
- **Maps:** Flutter Map (OpenStreetMap)
- **Asset Storage:** Local Filesystem (for offline images)

## 🏗️ Arsitektur (Repository Pattern)
Aplikasi ini mengikuti pola arsitektur yang memisahkan logika data dari antarmuka:
- `lib/providers/`: State Management & Business Logic.
- `lib/repositories/`: Abstraksi sumber data (Local DB vs Remote API).
- `lib/services/`: Infrastruktur teknis (API, DB, Device Specs).
- `lib/ui/`: UI Components & Screens dengan desain "Mewah" (Navy Blue-950).

## 📂 Dokumentasi Penting
Untuk detail teknis lebih lanjut, silakan baca file berikut:
- [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) - Panduan Endpoint API.
- [MOBILE_DESIGN.md](./MOBILE_DESIGN.md) - Rencana Arsitektur & Standar Visual.
- [GEMINI.md](./GEMINI.md) - Dokumentasi Sistem Utama & Standar Bisnis.

## 🏁 Memulai Pengembangan
1. **Clone** repository ini.
2. Jalankan `flutter pub get` untuk menginstal dependensi.
3. Buat file `.env` (jika diperlukan) untuk Base URL API.
4. Jalankan aplikasi di emulator atau perangkat fisik: `flutter run`.

---
**Status Proyek:** Tahap Inisialisasi & Perancangan.
