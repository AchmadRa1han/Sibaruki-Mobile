# SIBARUKI Mobile - Comprehensive Design Document

Dokumen ini merangkum arsitektur, standar teknis, dan alur kerja aplikasi mobile SIBARUKI.

## 1. Spesifikasi Umum
- **Framework:** Flutter (Target: Android & iOS).
- **State Management:** `Provider` (Kebutuhan: Kemudahan & Skalabilitas Menengah).
- **Local Database:** `sqflite` (SQLite) untuk penyimpanan offline.
- **Networking:** `Dio` (HTTP Client dengan dukungan Interceptor & Progress).
- **Maps:** `flutter_map` (OpenStreetMap) dengan layer satelit default.
- **Image Handling:** `image_picker` (Camera/Gallery) & `path_provider` (Local Storage).

---

## 2. Arsitektur Kode (Repository Pattern)
Struktur folder yang akan diimplementasikan:
- `lib/core/`: Konstanta, tema warna, dan utilitas global.
- `lib/models/`: Data classes (JSON Serializable).
- `lib/services/`: 
    - `api_service.dart`: Koneksi ke REST API.
    - `database_helper.dart`: Operasi CRUD SQLite.
- `lib/repositories/`: Logika pemilihan sumber data (Remote vs Local).
- `lib/providers/`: State management (Auth, Sync, Data Modul).
- `lib/ui/`: 
    - `screens/`: Halaman utama (Login, Dashboard, List, Form).
    - `widgets/`: Komponen UI reusable (Custom Card, Button).

---

## 3. Skema Database Lokal (SQLite)
Berdasarkan API dan `GEMINI.md`, tabel-tabel utama meliputi:
- **users:** Menyimpan profil user & Token JWT.
- **referensi:** Menyimpan list dropdown (Pendidikan, Pekerjaan, dll).
- **rtlh_penerima:** Data profil penerima bantuan.
- **rtlh_rumah:** Data teknis kondisi rumah (Koordinat, Luas, dll).
- **infrastruktur:** Data aset dinamis (PSU, PISEW, dll).
- **media_sync:** Antrian foto yang belum terupload (Local path, Target ID).
- **sys_logs_mobile:** Catatan aktivitas surveyor (Audit Trail).

---

## 4. Strategi Offline & Sinkronisasi
### 4.1. Conflict Resolution
- **Aturan:** *Latest Data Wins*. Data dengan timestamp `updated_at` terbaru (baik di HP maupun Server) akan menjadi data final.
### 4.2. Alur Sinkronisasi (Sync Workflow)
1. **Pull (Online):** Mengambil data referensi dan update data terbaru dari server (`last_sync` parameter).
2. **Input (Offline):** Surveyor mengisi form dan mengambil foto. Data disimpan di SQLite dengan flag `is_pending = 1`.
3. **Push (Online):** User menekan tombol "Sinkronkan". Aplikasi melakukan:
    - Upload Foto satu-per-satu ke `/media/upload`.
    - Mengirim data JSON secara batch ke `/rtlh/sync`.
    - Mengubah flag `is_pending = 0` jika sukses.

---

## 5. Standar Visual & UX ("Mewah" Style)
Mengacu pada `GEMINI.md`:
- **Warna:** 
    - Primary: `#050A30` (Navy/Blue-950).
    - Secondary: `#2563EB` (Blue-600).
    - Danger: `#E11D48` (Rose-600).
- **Elemen:**
    - Radius: `40.0` (Rounded ekstrem pada Card dan Modal).
    - Typography: Font modern (Inter atau Roboto).
- **Peta:** 
    - Provider: OpenStreetMap (OSM).
    - Default View: Satellite Tile Layer.
    - GIS Format: Konversi Lat/Lng ke **WKT Point/Polygon** sebelum dikirim ke server.

---

## 6. Fitur Keamanan & Integritas
- **Sanitasi Data:** NIK/No KK dibersihkan dari karakter non-angka sebelum simpan.
- **Audit Trail:** Mencatat `device_info`, `timestamp`, dan `action` untuk setiap perubahan data.
- **Session:** Token JWT disimpan di `Encrypted Shared Preferences` (jika memungkinkan) atau Secure Storage.

---

## 7. Roadmap Implementasi
1. **Tahap 1:** Inisialisasi Project & Core UI (Theme & Splash).
2. **Tahap 2:** Auth System (Login & JWT Storage).
3. **Tahap 3:** Local Database & Service Referensi.
4. **Tahap 4:** Modul RTLH (List & Form Input Offline).
5. **Tahap 5:** GIS & Media Service (Kamera & Map).
6. **Tahap 6:** Sinkronisasi Batch System.
7. **Tahap 7:** Pengujian (E2E) & Finishing UI.
