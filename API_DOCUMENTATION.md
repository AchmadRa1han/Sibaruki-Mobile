# Dokumentasi API SIBARUKI v1 (Mobile Synchronization)

Dokumentasi ini menjelaskan cara berinteraksi dengan API SIBARUKI untuk keperluan aplikasi mobile.

## 1. Informasi Umum
- **Base URL:** `http://your-domain.com/api/v1`
- **Format Data:** `JSON`
- **Autentikasi:** `JWT (JSON Web Token)`
- **Header Wajib (kecuali Login):** 
  ```http
  Authorization: Bearer <your_jwt_token>
  Content-Type: application/json
  ```

---

## 2. Autentikasi (Auth)

### 2.1 Login User
Digunakan untuk mendapatkan token akses.
- **Endpoint:** `POST /auth/login`
- **Body:**
  ```json
  {
    "username": "surveyor_desa",
    "password": "password123"
  }
  ```
- **Response Sukses (200):**
  ```json
  {
    "status": true,
    "message": "Login berhasil",
    "data": {
      "token": "eyJhbGciOiJIUzI1Ni...",
      "user": {
        "id": 1,
        "username": "surveyor_desa",
        "role_name": "Surveyor",
        "role_scope": "local"
      },
      "expires_at": "2026-03-23 09:45:00"
    }
  }
  ```

---

## 3. Data Master (Dropdown & Referensi)

### 3.1 Ambil Data Referensi
Mengambil semua pilihan dropdown (Pendidikan, Pekerjaan, dll).
- **Endpoint:** `GET /master/referensi`
- **Response:** Mengelompokkan data berdasarkan kategori (`pekerjaan`, `pendidikan`, `status_tanah`, dll).

### 3.2 Ambil Daftar Desa
Mengambil daftar desa yang menjadi hak akses user tersebut.
- **Endpoint:** `GET /master/desa?category=rtlh` (Pilihan category: `rtlh` atau `kumuh`)
- **Response:** List desa dengan ID dan nama kecamatan.

---

## 4. Modul RTLH (Rumah Tidak Layak Huni)

### 4.1 List & Incremental Sync
Mengambil daftar RTLH. Gunakan `last_sync` untuk hanya mengambil data yang berubah sejak sinkronisasi terakhir.
- **Endpoint:** `GET /rtlh?last_sync=2026-03-01 10:00:00&desa_id=12`
- **Response:** Array data rumah beserta profil singkat pemilik.

### 4.2 Batch Sync (Upload Hasil Survei)
Mengirim banyak data survei sekaligus dari HP ke Server (Offline-to-Online).
- **Endpoint:** `POST /rtlh/sync`
- **Body:**
  ```json
  {
    "data": [
      {
        "penerima": { "nik": "123...", "nama_kepala_keluarga": "Budi", ... },
        "rumah": { "nik_pemilik": "123...", "desa_id": 12, ... },
        "kondisi": { "st_pondasi": "Baik", "st_atap": "Rusak", ... }
      }
    ]
  }
  ```

---

## 5. Modul Infrastruktur & Aset

### 5.1 Operasi CRUD Dinamis
Endpoint ini mendukung modul: `psu`, `pisew`, `arsinum`, `perumahan-formal`, `aset-tanah`.
- **List:** `GET /infrastruktur/{modul}`
- **Detail:** `GET /infrastruktur/{modul}/{id}`
- **Create:** `POST /infrastruktur/{modul}`
- **Update:** `PUT /infrastruktur/{modul}/{id}`
- **Delete:** `DELETE /infrastruktur/{modul}/{id}`

---

## 6. Modul Wilayah Kumuh (GIS)

### 6.1 List Wilayah Kumuh
- **Endpoint:** `GET /kumuh`
- **Fitur Khusus:** Properti `geo_coords` berisi array `[lat, lng]` yang dikonversi otomatis dari WKT database untuk langsung ditampilkan di Map mobile.

---

## 7. Media & Upload Foto

### 7.1 Upload Foto Survei
Mengunggah foto bukti fisik rumah/infrastruktur.
- **Endpoint:** `POST /media/upload`
- **Content-Type:** `multipart/form-data`
- **Key:** `file` (File Image, max 5MB)
- **Response Sukses:**
  ```json
  {
    "status": true,
    "data": {
      "file_name": "1710582412_abc.jpg",
      "full_url": "http://domain.com/uploads/mobile/20260316/1710582412_abc.jpg"
    }
  }
  ```

---

## 8. Kode Status HTTP
- `200 OK`: Request sukses.
- `201 Created`: Data baru berhasil dibuat.
- `400 Bad Request`: Input tidak valid atau parameter kurang.
- `401 Unauthorized`: Token hilang, salah, atau kadaluarsa.
- `404 Not Found`: Data tidak ditemukan.
- `500 Server Error`: Kesalahan pada sisi server.
