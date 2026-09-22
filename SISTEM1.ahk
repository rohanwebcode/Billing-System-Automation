#Requires AutoHotkey v2.0

; Hotkey Trigger: Ctrl (^) + Win (#) + R
^#r::
{
    ; 1. Daftar Nama Pelanggan & Nomor Tujuan
    daftarPelanggan := [
        { nama: "STR - LOREM", nomor: "6281515884665" }, 
        { nama: "BLR - IPSUM", nomor: "6281515884665" },
        ; { nama: "SUK - DOLOR", nomor: "6200000000000" },
        ; { nama: "SUK - SIT AMET", nomor: "6200000000000" },
        ; { nama: "WOJ - CONSECTETUR", nomor: "6200000000000" },
        ; { nama: "GAN - ADIPISICING MASK", nomor: "6200000000000" },
        ; Copy untuk menambahkan daftar pelanggan yang akan dibroadcast
    ]

    ; Konfirmasi awal sebelum menjalankan otomatisasi massal
    if (MsgBox("Mulai mengirim " . daftarPelanggan.Length . " pesan broadcast?", "Konfirmasi AHK", "YesNo Icon?") = "No") {
        return
    }

    ; 2. Iterasi untuk setiap pelanggan dalam array
    for item in daftarPelanggan {
        ; Template pesan dengan variabel nama pelanggan
        pesan := "Pelanggan Yth.`n"
            . "Pembayaran tagihan internet Anda sudah dapat dilakukan.`n`n"
            . "Perangkat: " . item.nama . "`n"
            . "Produk: PAKET 15 MBPS`n"
            . "Status: *Belum Dibayar*`n"
            . "Tanggal Jatuh Tempo: 2026-09-15 23:50:00`n"
            . "Add Ons: 0 Items`n"
            . "Jumlah yang Harus Dibayar: 125,000`n`n"
            . "Rekening Pembayaran :`n"
            . "- LOREM : 12345678901 an Rohan`n"
            . "- IPSUM : 123456789012345 an Rohan`n`n"
            . "Untuk konfirmasi pembayaran bisa kirim bukti transfer ke`n"
            . "nomor Whatsapp:`n"
            . "6212345678987`n`n"
            . "Terima kasih atas perhatian Anda terhadap faktur ini.`n`n"
            . "Salam,`n"
            . "Tim Dukungan ~ PERMATA FIBER`n"
            . "*PT. PERMATA DATA*"

        ; 3. Format URL WhatsApp Direct
        urlWA := "https://web.whatsapp.com/send?phone=" . item.nomor . "&text=" . UriEncode(pesan)

        ; 4. Buka URL di Chrome via Address Bar (Ctrl + L)
        Send("^l")
        Sleep(300)
        A_Clipboard := urlWA
        Send("^v{Enter}")

        ; 5. Jeda 15 detik (15000 ms) agar WhatsApp Web selesai memuat halaman
        Sleep(20000)

        ; 6. Tekan Enter untuk mengirim pesan
        Send("{Enter}")

        ; 7. Jeda waktu tambahan sebelum berpindah ke pelanggan berikutnya (3 detik)
        Sleep(5000)
    }

    MsgBox("Proses broadcast selesai!", "Sukses", "64")
}

; Fungsi encoding karakter untuk URL
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

; Emergency Stop: Tekan Esc untuk langsung menutup script
Esc::ExitApp

; Alternatif Emergency Stop: Tekan Ctrl + Shift + Esc
^+Esc::ExitApp