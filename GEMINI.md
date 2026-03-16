# SIBARUKI - Technical & Architectural Documentation

## 1. Arsitektur Teknologi & Standar Core
- **Framework:** CodeIgniter 4.6.x (PHP 8.1+).
- **Styling:** Tailwind CSS v3 (Custom JIT Build).
- **Frontend Interactivity:** Vanilla JS (ES6+) dengan pola `async/await`.
- **Database:** MySQL dengan ekstensi Spasial (WKT - Well-Known Text).
- **Library Utama:** 
  - `PhpSpreadsheet 2.0+` (Penting: Gunakan `setCellValue` koordinat string, hindari `ByColumnAndRow`).
  - `Leaflet.js` & `Leaflet.draw` untuk GIS.
  - `Lucide Icons` (Client-side rendering).

## 2. Standar Database & Data Integrity
### 2.1. Skema Tabel Utama
- **RTLH:** Terbagi menjadi 3 tabel relasional: `rtlh_penerima` (NIK as PK), `rtlh_rumah` (id_survei as PK), `rtlh_kondisi_rumah`.
- **Modul Lain:** Menggunakan `id` (Auto Increment) kecuali **Wilayah Kumuh** yang menggunakan `FID`.
- **Trash System:** Tabel `trash_data` menyimpan paket data lengkap dalam format **JSON** (`data_json`) untuk mendukung fitur *Undo/Restore*.

### 2.2. Integritas Penghapusan (Delete & Bulk Delete)
- **Mandat:** Dilarang menghapus data secara permanen secara langsung dari tabel utama.
- **Pola:** 
  1. `transStart()`
  2. Fetch data asli.
  3. Insert ke `trash_data` (JSON-encoded).
  4. Hapus dari tabel utama.
  5. `transComplete()`
  6. `logActivity('Hapus Massal/Hapus', ...)`

## 3. Logika Controller & Operasi Data
### 3.1. Robust CSV Import (Pola Wajib)
Setiap fungsi `importCsv` harus mengimplementasikan:
- **Auto-Reset ID:** Jalankan `ALTER TABLE ... AUTO_INCREMENT = 1` jika `countAllResults() === 0` sebelum insert.
- **Delimiter Detection:** Deteksi otomatis antara koma (`,`) dan titik koma (`;`).
- **Header Guard:** Lewati baris yang mengandung keyword header atau jika kolom pertama bukan numerik (NO).
- **Data Sanitization:**
  - **NIK/No KK:** `preg_replace('/[^0-9]/', '', $val)`.
  - **Numeric/Currency:** Hapus titik ribuan, ganti koma desimal menjadi titik.
  - **Date:** Gunakan `DateTime::createFromFormat('d-m-Y', $val)` untuk menangani format Indonesia.
- **TTL Splitting:** Gunakan Regex cerdas untuk memisahkan Tempat dan Tanggal Lahir (dmY, dMY, atau gabungan tanpa koma).

### 3.2. Advanced Excel Export
- **Full Columns:** Wajib mengekspor **seluruh** kolom teknis (bukan hanya yang tampil di tabel).
- **Readable Values:** Konversi data ID Referensi menjadi teks yang bisa dibaca (`RefMaster::getAllMapped()`).
- **Long Numeric Fix:** Tambahkan spasi di akhir NIK/No KK agar tidak berubah menjadi format E+ di Excel.

## 4. Sistem Monitoring & Audit Trail
### 4.1. Audit Trail Forensic
Setiap aksi perubahan data wajib mencatat metadata berikut di `sys_logs`:
- **Data Diff:** Bandingkan `$oldData` vs `$newData` untuk mencatat kolom mana saja yang berubah.
- **Client Info:** `IP Address`, `User Agent` (Browser/OS).
- **Severity:** 
  - `info`: Tambah, Export.
  - `warning`: Ubah, Hapus (pindahkan ke Trash).
  - `critical`: Hapus Permanen, Login Gagal.

## 5. Standar UI/UX ("Mewah" Style)
### 5.1. Elemen Visual
- **Rounded:** Gunakan radius ekstrem `rounded-[2.5rem]` pada kartu utama.
- **Color Palette:** Primary `blue-950`, Secondary `blue-600`, Accent `rose-600` (untuk aksi bahaya).
- **Glassmorphism:** Sidebar mobile dan modal menggunakan efek backdrop-blur.

### 5.2. Bulk Action Bar
- Bar aksi massal harus muncul dari atas (`-translate-y-full`) hanya saat ada checkbox yang aktif.
- Menampilkan counter "X TERPILIH".
- Menangani konfirmasi via `window.customConfirm` (Async Promise).

## 6. Geospasial & Peta
- **Default View:** Selalu gunakan **Satellite Layer** sebagai default di halaman detail.
- **WKT Extraction:** Gunakan fungsi `extractCoordinates` (Regex) untuk mem-parsing data WKT dari database ke koordinat Leaflet `[lat, lng]`.
- **FitBounds:** Peta otomatis melakukan `fitBounds()` pada poligon yang dimuat.

## 7. Standar Pengujian (Testing)
- **E2E Mandate:** Setiap modul wajib memiliki file `cypress/e2e/crud_[nama_modul].cy.js`.
- **Alur Test:** `Visit Index` -> `Click Tambah` -> `Fill Form` -> `Submit` -> `Search Results` -> `Update` -> `Delete`.
- **Konvensi Selector:** Prioritaskan `cy.contains('teks_tombol')` daripada class CSS yang dinamis.

## 8. Perintah Spark (CLI)
- `db:truncate_rtlh`: Kosongkan total data RTLH & Reset ID.
- `db:truncate_aset`: Kosongkan total data Aset & Reset ID.
- `db:find-ngaco-ttl`: Debugging data tanggal lahir yang tidak ter-parsing sempurna.
- `wkt:fix`: Memperbaiki data WKT yang corrupt atau tidak valid.
