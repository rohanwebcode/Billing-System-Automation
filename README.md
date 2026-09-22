# Dokumentasi Program Otomatisasi Broadcast WhatsApp (AutoHotkey v2)

Dokumen ini menjelaskan alur kerja, struktur kode, serta panduan penggunaan script **AutoHotkey (AHK v2)** yang dirancang untuk melakukan pengiriman pesan massal (*broadcast*) secara otomatis melalui **WhatsApp Web**.

## 1. Ringkasan Program

Program ini membantu mengotomatiskan proses pengiriman pesan pengingat tagihan internet (*billing notification*) kepada daftar pelanggan. Script bekerja dengan cara memanfaatkan **WhatsApp Direct URL** (`https://web.whatsapp.com/send?phone=...`), membuka alamat tersebut di browser (seperti Chrome), menunggu halaman dimuat, lalu menekan tombol `Enter` untuk mengirimkan pesan.

### Fitur Utama

* **Hotkey Trigger**: Dijalankan dengan kombinasi tombol `Ctrl + Win + R`.

* **Konfirmasi Awal**: Menampilkan dialog verifikasi sebelum memulai iterasi pesan massal.

* **Template Pesan Dinamis**: Memasukkan nama pelanggan dan rincian paket secara otomatis.

* **URL Encoding**: Mengubah pesan teks biasa menjadi format URL yang aman (`percent-encoding`).

* **Siklus Otomatis**: Melakukan navigasi tab browser dan simulasi ketukan tombol keyboard secara terus-menerus hingga seluruh daftar pelanggan terkirim.

## 2. Struktur Kode & Penjelasan Per Bagian

### A. Konfigurasi Hotkey & Data Pelanggan

```
#Requires AutoHotkey v2.0

; Hotkey Trigger: Ctrl (^) + Win (#) + R
^#r::
{
    ; 1. Daftar Nama Pelanggan & Nomor Tujuan
    daftarPelanggan := [
        { nama: "STR - SUTONO", nomor: "6285606245609" },
        { nama: "BLR - WAWAN NURHADI 2", nomor: "6285648304710" },
        ...
    ]

```

* **`#Requires AutoHotkey v2.0`**: Memastikan script dijalankan menggunakan sintaks AHK versi 2.

* **`^#r::`**: Kombinasi tombol pemicu (`Ctrl` + `Win` + `R`).

* **`daftarPelanggan`**: Array dari objek yang menyimpan pasangan `nama` dan `nomor` WhatsApp (format internasional tanpa tanda `+`).

### B. Dialog Konfirmasi

```
    ; Konfirmasi awal sebelum menjalankan otomatisasi massal
    if (MsgBox("Mulai mengirim " . daftarPelanggan.Length . " pesan broadcast?", "Konfirmasi AHK", "YesNo Icon?") = "No") {
        return
    }

```

Mencegah ketidaksengajaan menjalankan otomatisasi dengan menampilkan pop-up konfirmasi yang menunjukkan jumlah penerima.

### C. Pembentukan Template Pesan & Encoding

```
    for item in daftarPelanggan {
        pesan := "Pelanggan Yth.`n"
            . "Pembayaran tagihan internet Anda sudah dapat dilakukan.`n`n"
            . "Perangkat: " . item.nama . "`n"
            ...
        
        urlWA := "https://web.whatsapp.com/send?phone=" . item.nomor . "&text=" . UriEncode(pesan)

```

* **`pesan`**: Penggabungan string menggunakan operator `.` dan karakter *newline* (`` `n ``) untuk membuat format tagihan yang rapi.

* **`UriEncode(pesan)`**: Mengonversi spasi, baris baru, dan karakter khusus agar bisa disisipkan ke dalam link browser tanpa memutus tautan.

### D. Interaksi Browser & Simulasi Keyboard

```
        ; Buka URL di Chrome via Address Bar (Ctrl + L)
        Send("^l")
        Sleep(300)
        A_Clipboard := urlWA
        Send("^v{Enter}")

        ; Jeda agar WhatsApp Web selesai memuat halaman
        Sleep(20000)

        ; Tekan Enter untuk mengirim pesan
        Send("{Enter}")

        ; Jeda sebelum ke pelanggan berikutnya
        Sleep(5000)
    }

```

1. **`Send("^l")`**: Mengarahkan fokus ke *address bar* browser aktif.

2. **`A_Clipboard := urlWA` & `Send("^v{Enter}")`**: Memasukkan link ke clipboard lalu menempelkannya ke address bar untuk navigasi lebih cepat.

3. **`Sleep(20000)`**: Menunggu selama 20 detik agar halaman WhatsApp Web memuat percakapan dan kotak pesan.

4. **`Send("{Enter}")`**: Mensimulasikan penekanan tombol Enter untuk mengirim pesan.

5. **`Sleep(5000)`**: Jeda buffer 5 detik sebelum melanjutkan ke item berikutnya.

### E. Fungsi Helper `UriEncode`

```
UriEncode(str) {
    out := ""
    loop parse, str
    {
        if RegExMatch(A_LoopField, "[a-zA-Z0-9_.~-]")
            out .= A_LoopField
        else
            out .= "%" . Format("{:02X}", Ord(A_LoopField))
    }
    return out
}

```

Fungsi ini membaca string karakter demi karakter. Karakter alfanumerik tetap dipertahankan, sedangkan karakter khusus (termasuk spasi dan `Enter`) diubah menjadi format Hexadecimal berawalan `%` (misal: spasi menjadi `%20`).

## 3. Cara Penggunaan

1. **Prasyarat**:

   * Install [AutoHotkey v2](https://www.autohotkey.com/?utm_source=gemini).

   * Buka Google Chrome (atau browser utama) dan log in ke **WhatsApp Web.** Direkomendasikan untuk menggunakan browser Google Chrome.

2. **Jalankan Script**:

   * Simpan kode ke dalam file berekstensi `.ahk` (misal: `broadcast.ahk`).

   * Klik dua kali file tersebut untuk menjalankannya.

3. **Eksekusi Broadcast**:

   * Buka jendela browser tempat WhatsApp Web sudah aktif.

   * Tekan kombinasi tombol **`Ctrl` + `Win` + `R`**.

   * Klik **Yes** pada pop-up konfirmasi.

   * **Jangan menyentuh mouse atau keyboard** selama proses otomatisasi berlangsung agar navigasi `Ctrl+L` dan `Ctrl+V` tidak terganggu.

## 4. Cara Menghentikan / Menonaktifkan Script Secara Paksa

Jika terjadi kesalahan input, salah sasaran pengiriman, atau otomatisasi berjalan di luar kendali, Anda dapat menghentikan program secara paksa menggunakan beberapa metode berikut:

### Opsi 1: Emergency Kill Switch

```
; Emergency Stop: Tekan Esc untuk langsung menutup script
Esc::ExitApp

; Alternatif Emergency Stop: Tekan Ctrl + Shift + Esc
^+Esc::ExitApp
```

> **Catatan**: Jika opsi ini ditambahkan, Anda cukup menekan tombol `Esc` (atau `Ctrl + Shift + Esc`) pada keyboard kapan saja untuk langsung mematikan otomatisasi seketika.

### Opsi 2: Melalui Windows Task Manager

Jika layar Anda terhalang atau keyboard/mouse sulit dikontrol akibat simulasi ketukan tombol:

1. Tekan kombinasi tombol **`Ctrl` + `Shift` + `Esc`** untuk membuka **Task Manager**.

2. Cari proses bernama **AutoHotkey** pada tab **Processes**.

3. Klik kanan pada proses tersebut, lalu pilih **End Task**.

### Opsi 3: Menggunakan Command Prompt (CMD) / PowerShell (Rekomendasi)

Untuk menghentikan semua proses AutoHotkey yang sedang berjalan melalui terminal:

1. Buka **Command Prompt (CMD)** atau **PowerShell**.

2. Jalankan perintah berikut lalu tekan `Enter`:

   ```
   taskkill /F /IM AutoHotkey64.exe
   
   ```

   *(Atau `taskkill /F /IM AutoHotkey32.exe` / `taskkill /F /IM AutoHotkey.exe` tergantung versi yang terinstall)*.

## 5. Catatan & Imbauan Tambahan

1. **Kecepatan Internet & Performa Komputer**: Waktu `Sleep(20000)` (20 detik) disesuaikan untuk mengantisipasi loading WhatsApp Web yang lambat. Jika koneksi internet sangat cepat, durasi ini bisa diperpendek.

2. **Fokus Jendela (Focus Window)**: Pastikan browser tetap menjadi jendela aktif selama script berjalan.

3. **Risiko Blokir WhatsApp**: Pengiriman pesan otomatis dalam jumlah besar ke banyak nomor secara cepat berisiko terdeteksi sebagai *spam* oleh sistem anti-spam WhatsApp. Disarankan untuk memberikan jeda waktu yang cukup antar pesan.