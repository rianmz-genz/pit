import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart';
import 'package:pit/themes/AppTheme.dart';

class TermsAndConditions extends StatelessWidget {
  final String _markdowndata = '''# **Syarat dan Ketentuan**
Selamat datang di Platform (sebagaimana didefinisikan di bawah) Bengkel.id, terima kasih Anda telah menggunakan maupun mengakses layanan melalui Platform Bengkel.id. Syarat dan ketentuan penggunaan Platform yang tertera pada halaman ini (“**Syarat dan Ketentuan”**) mengatur hal-hal terkait akses Anda terhadap atas Platform Bengkel.id dan penggunaan seluruh fitur di dalamnya (“**Fitur**”) yang dikembangkan oleh PT Inovasi Solusi Digital melalui Platform Bengkel.id, yang dapat diakses melalui tautan https://bengkel.co.id (“**Bengkel.id**” atau “**Kami**” atau “**Platform**”).

Dengan melakukan akses pada Platform, Anda secara tegas dan tersurat menyatakan telah membaca, mengerti dan setuju untuk mengikatkan diri pada Syarat dan Ketentuan ini. Jika Anda tidak menyetujui Syarat dan Ketentuan ini, maka Anda tidak diperkenankan untuk mengakses Platform atau menggunakan Fitur. Syarat dan Ketentuan ini dapat dianggap sebagai perjanjian induk yang menjadi acuan untuk mengatur syarat dan ketentuan lainnya termasuk namun tidak terbatas pada kebijakan privasi atau ketentuan lainnya yang dapat dibuat oleh Kami dari waktu ke waktu, dan dengan mengikatkan diri pada Syarat dan Ketentuan ini, maka Anda menyatakan tunduk pada turunan dari Syarat dan Ketentuan ini. Ketidakberlakuan syarat dan ketentuan lainnya tidak akan menyebabkan Syarat dan Ketentuan ini menjadi tidak sah, tidak berlaku, dan/ atau tidak dapat dilaksanakan.

Dengan menyetujui Syarat dan Ketentuan ini, Anda dianggap cakap menurut hukum Indonesia dan hukum pada yurisdiksi yang berlaku untuk menyetujui Syarat dan Ketentuan ini. Jika Anda tidak cakap secara hukum (termasuk namun tidak terbatas pada orang yang belum dewasa, mereka yang berada di bawah pengampuan, atau perwakilan yang tidak sah) dan tidak didampingi oleh serta tidak memperoleh persetujuan dari orang yang dianggap cakap untuk melakukan perbuatan hukum pada saat mengakses Platform, maka Anda bertanggung jawab sepenuhnya atas segala hal yang Anda lakukan dalam Platform, termasuk namun tidak terbatas pada aktivitas yang Anda lakukan dengan pihak lain yang menggunakan Platform. Jika Anda bertindak sebagai karyawan, agen, atau penerima kuasa dan bertindak untuk dan atas nama individu lain, organisasi, badan usaha, badan hukum, maupun instansi lainnya, Anda dengan ini menyatakan dan menjamin bahwa Anda merupakan pihak yang berwenang untuk mewakili pihak tersebut, yang mana Syarat dan Ketentuan ini akan mengikat pihak yang Anda wakili tersebut.
### **Definisi**
1. **Akun** berarti sebagaimana didefinisikan dalam Pasal 2.1
1. **Anda** berarti setiap pengunjung dan/atau pengguna, yang mengakses dan/atau menggunakan Platform serta Fitur di dalamnya baik yang memiliki Akun maupun tidak memiliki Akun.
1. **Data Pribadi** berarti setiap data yang menyangkut identitas, kontak, profil, tingkah laku dalam Platform dan data terkait dengan informasi pribadi Anda yang dapat diidentifikasi baik secara langsung maupun tidak langsung melalui sistem elektronik dan/atau nonelektronik.
1. **Konsumen** berarti individu, badan usaha, atau badan hukum yang menggunakan aplikasi Bengkel.id.
1. **Konten** berarti semua teks, foto, gambar, ilustrasi, grafik, rekaman suara, video, klip audio-video, dan konten lainnya yang Anda unggah, pasang di atau melalui Platform.
1. **Tautan Pembayaran** berarti tautan khusus yang dikirimkan oleh Bengkel.id kepada Konsumen atas instruksi dari Konsumen lain yang memiliki piutang terhadap Konsumen tersebut.
1. **Hari Kerja** berarti hari, selain hari Sabtu, Minggu, hari libur resmi nasional, dan hari lainnya yang ditetapkan oleh pemerintah Indonesia sebagai hari libur, dimana Bank beroperasi secara komersial.
1. **Hukum Yang Berlaku** berarti setiap hukum nasional, provinsi setempat, kotamadya atau hukum lainnya, peraturan instansi, putusan, konstitusi, keputusan, aturan, kebijakan pemerintah yang mengikat, dan statuta dalam negara Republik Indonesia.
1. **Pihak Ketiga Terpilih** berarti sebagaimana didefinisikan dalam Pasal 4.1.
1. **Platform** berarti situs dan aplikasi dalam bentuk *web-app* dan/ atau *mobile*, serta situs dan/ atau aplikasi lainnya milik Bengkel.id yang dapat diciptakan dan dikembangkan oleh Bengkel.id dari waktu ke waktu.
1. **Produk** berarti setiap jasa yang ditawarkan oleh Bengkel.id melalui Platform.
1. **P2P Lenders** berarti sebagaimana didefinisikan dalam Pasal 1.4.
1. **P2P Lending** berarti sebagaimana didefinisikan dalam Pasal 1.4.
### **Tentang Bengkel.id**
1. Bengkel.id adalah perusahaan teknologi dengan misi memajukan bisnis 60 juta Usaha Mikro, Kecil dan Menengah di Indonesia.
1. Bengkel.id menghadirkan solusi dengan berbagai layanan yang mencakup pengelolaan transaksi penjualan dan utang piutang, pengelolaan stok, pembayaran yang akan terus dikembangan untuk memenuhi kebutuhan Anda.
1. Bengkel.id memiliki dua Fitur utama, yaitu; (i) pembukuan dimana Konsumen dapat mencatat transaksi penjualan dan utang dengan mudah; dan (ii) Pembayaran digital, dimana Bengkel.id berkerjasama dengan Pihak Ketiga Terpilih untuk melakukan penagihan dan Pembayaran hutang.
1. Selain Fitur tersebut, Bengkel.id juga memfasilitasi layanan pinjam meminjam uang berbasis teknologi informasi dalam rangka mempertemukan pemberi pinjaman dengan penerima pinjaman dalam rangka melakukan perjanjian pinjam meminjam (“**P2P Lending**”), yang mana jasa tersebut dilaksanakan oleh pihak ketiga (**“P2P Lenders**”), dan Kami hanya menjembatani aktivitas tersebut untuk dilaksanakan antara Konsumen dan P2P Lenders dan tidak melakukan kegiatan P2P Lending tersebut.
### **Ketentuan Akun**
1. Anda diharuskan untuk mendaftarkan diri pada sistem yang terdapat di Platform dengan membuat akun (“**Akun**”) terlebih dahulu untuk menggunakan Produk kami. Bengkel.id tidak memungut biaya pendaftaran apapun untuk setiap pengguna Platform Bengkel.id.
1. Setiap Konsumen dengan ini menyatakan bahwa Anda adalah orang yang cakap secara hukum dan mampu untuk mengikatkan dirinya dalam sebuah perjanjian yang sah dan mengikat secara hukum.
1. Untuk membuat Akun, Konsumen wajib melengkapi data-data yang diminta oleh Bengkel.id secara lengkap dan jujur di halaman Akun, Kami tidak bertanggung jawab atas akibat yang terjadi apabila terdapat informasi yang tidak benar, tidak akurat, maupun menyesatkan mengenai data-data yang Konsumen cantumkan pada Akun yang menyebabkan kerugian pada pihak ketiga.
1. Dalam hal Akun Anda telah terdaftar di Platform, Anda tidak dapat melakukan pendaftaran Akun berikutnya dengan menggunakan data yang sama dengan Akun Anda yang telah terdaftar. Anda dengan ini memahami bahwa Bengkel.id hanya menerima 1 (satu) nomor telepon/ponsel untuk digunakan dan didaftarkan dalam 1 (satu) akun. Konsumen dapat memperbarui nomor telepon/ponsel yang tercatat pada Platform dengan menghubungi layanan pengguna kami melalui kontak sebagaimana disebutkan disini.
1. Anda dapat melakukan perubahan dan/atau penghapusan atas setiap informasi atau data pada Akun Anda sewaktu-waktu dengan tetap tunduk pada ketentuan dan prosedur yang ditetapkan oleh Bengkel.id.
1. Anda dilarang untuk melakukan pengalihan dan/atau menjual Akun Anda yang telah terdaftar ke pihak lain tanpa persetujuan secara tertulis dari Kami.
1. Kami dengan kewenangan Kami sendiri dapat melakukan penangguhan Akun dan/ atau penutupan Akun Anda yang akan mengakibatkan Anda tidak dapat mengakses Akun Anda untuk sementara waktu atau secara permanen atas dugaan pelanggaran Syarat dan Ketentuan dan/ atau Hukum Yang Berlaku tanpa pemberitahuan atau informasi terlebih dahulu kepada Anda. Setelah Kami melakukan penangguhan Akun dan/atau penutupan Akun, kami akan memberitahukan hal tersebut kepada Anda melalui *e-mail* beserta sebab penangguhan dan/atau penutupan Akun. Kami dapat mengembalikan Akun Anda ke keadaan semula apabila Anda telah memperbaiki kesalahan Anda dan Anda memahami bahwa seluruh kerugian yang diderita oleh Anda selama penangguhan Akun merupakan tanggung jawab Anda sepenuhnya.
1. Kami dengan kewenangan kami dapat melakukan penangguhan Akun dan atau penutupan Akun Anda apabila Anda melewati batas jumlah transaksi yang akan kami tetapkan di kemudian hari dan/atau apabila Anda melakukan transaksi yang tidak berhubungan dengan kegiatan usaha Anda atau dengan kata lain, untuk kepentingan personal.
1. Anda bertanggung jawab atas keamanan Akun serta kode verifikasi yang dikirim oleh sistem Kami atau sistem pihak ketiga yang Kami tunjuk untuk Anda. Maka dari itu, Anda dengan ini menyatakan bahwa Kami tidak bertanggung jawab atas kerugian ataupun kendala yang timbul atas penyalahgunaan Akun Anda yang diakibatkan oleh kelalaian atau kesalahan Anda. Apabila terdapat indikasi penyalahgunaan atas Akun Anda, Kami hanya dapat membantu Anda untuk memeriksa, menangguhkan, atau menghentikan akses Anda terhadap Akun setelah Anda memberitahukan kepada Kami mengenai hal tersebut melalui fitur kontak kami pada Platform atau sarana komunikasi lainnya yang Kami sediakan dari waktu ke waktu.
1. Kami berhak sewaktu-waktu mengubah, menghapus, mengurangi, menambah dan/atau memperbarui Fitur yang terdapat pada Platform. Pemakaian Anda yang berkelanjutan terhadap Platform akan dianggap sebagai persetujuan atas perubahan, penghapusan, pengurangan, penambahan dan/atau pembaruan Fitur.
1. Setelah Anda membuat Akun, Kami berhak untuk mengakses dan menyimpan Daftar Kontak Anda. Tujuan mengakses Daftar Kontak Anda adalah untuk memberi tahu pengguna lain yang ada dalam Daftar Kontrak Anda bahwa Anda merupakan pengguna Platform ini juga dapat mengirimkan pesan pengingat untuk pembayaran dan hal-hal terkait lainnya. Selain itu, Kami juga Kami akan menjaga kerahasiaan Daftar Kontak Anda dan kami tidak akan mengalihkan Daftar Kontak Anda ke pihak ketiga mana pun tanpa persetujuan tertulis sebelumnya dari Anda. Hal ini diatur lebih lanjut dalam Kebijakan Privasi Kami.
1. Kami berhak untuk mengakses laman notifikasi pada gawai Anda serta mengakses surel Anda yang berkaitan dengan kegiatan transaksi perbankan dan data penjualan di situs e-commerce serta pembayaran digital lainnya dengan tujuan untuk membantu merapikan pembukuan keuangan di aplikasi Bengkel.id. Kami akan meminta persetujuan Anda terlebih dahulu sebelum melakukan kegiatan akses tersebut.
1. Anda memahami dan setuju bahwa Bengkel.id tidak akan bertanggung jawab atas kerugian atau kerusakan yang timbul dari kegagalan Anda untuk menjaga keamanan dan kerahasiaan akun Anda, termasuk akses yang tidak diinginkan sebagai akibat dari pemberian nama pengguna akun Anda kepada pihak ketiga, peminjaman akun Anda kepada pihak ketiga, mengakses tautan yang disediakan oleh pihak lain, memberikan atau memperlihatkan one-time-password (OTP) Anda kepada pihak lain, dan segala bentuk kelalaian Anda yang menyebabkan kerugian atau masalah pada akun Anda pada Platform. Anda memahami bahwa kami tidak memiliki kewajiban apa pun untuk memulihkan data dan informasi Anda yang disimpan pada atau sebagai bagian dari akun Anda.
### **Kebijakan Konten**
1. Dalam menggunakan Platform, Anda dilarang untuk:
   1. Menyamar sebagai orang atau entitas apa pun, secara tidak benar menyatakan atau memberikan pernyataan salah tentang afiliasi Anda dengan seseorang atau entitas;
   1. Melakukan aktivitas ilegal dan/atau perbuatan melawan hukum apapun atau melakukan transaksi untuk tujuan tersebut;
   1. Melakukan penipuan dalam bentuk apapun secara langsung dan/atau tidak langsung kepada pihak manapun;
   1. Menggunakan dan menampilkan kata, komentar, gambar, atau konten dalam bentuk apa pun yang mengandung konten SARA (Suku, Agama, Ras, dan Antar Golongan), mencemarkan nama baik Kami, mengandung unsur diskriminatif terhadap pihak tertentu, mengandung ujaran kebencian, vulgar, bersifat ancaman, mengandung pornografi, atau konten lainnya yang melanggar norma serta Hukum Yang Berlaku;
   1. Membuat dan/atau menggunakan perangkat keras, perangkat lunak, fitur, dan/atau perangkat lain apa pun untuk tujuan memanipulasi sistem Platform atau membuat salinan Platform atau bagian dari Platform, termasuk manipulasi atas (i) Konten, (ii) kegiatan perambahan (crawling/scraping); (iii) kegiatan otomasi dalam transaksi, jual beli, promosi, dan yang lainnya; dan/atau (v) aktivitas lain yang secara wajar dapat dianggap sebagai tindakan manipulatif terhadap sistem Platform;
   1. Menyalahgunakan atau mengganggu pengoperasian Platform atau server atau jaringan yang terhubung ke Platform, termasuk memasang, mengirimkan, mentransmisikan, mengunggah, atau menyediakan materi apa pun yang berisi virus perangkat lunak, worms, atau kode, dokumen, atau program komputer lainnya yang dirancang untuk mengganggu, menghancurkan atau membatasi fungsionalitas perangkat lunak atau perangkat keras komputer atau peralatan telekomunikasi;
   1. menulis Konten yang tidak tepat, tidak akurat dan mengandung informasi menyesatkan; dan
   1. menampilkan konten yang melanggar hak kekayaan intelektual pihak ketiga.
1. Kami berhak untuk secara sewaktu-waktu menghapus, tidak menampilkan, atau meminta Anda untuk memperbaiki atau mengubah konten yang Anda unggah jika Kami menemukan/ mendapatkan laporan dari Konsumen lain bahwa Anda melakukan larangan yang dimaksud pada Pasal 3.1 di atas baik sebagian atau seluruhnya, atau jika Anda tidak memenuhi kebijakan konten yang Kami tentukan.
1. Ketika Anda mengunggah atau memasukkan konten ke dalam Platform, Anda memberikan Kami hak non-eksklusif, tidak terbatas pada wilayah, secara terus-menerus, tidak dapat dibatalkan, bebas royalti untuk melaksanakan setiap dan semua hak cipta, publisitas, merek dagang, hak basis data dan hak kekayaan intelektual apapun yang Anda miliki dalam konten. Selanjutnya sepanjang diperbolehkan oleh Hukum Yang Berlaku, Anda dengan ini menyatakan untuk tidak menuntut hak ekonomi yang Anda miliki atas hak cipta dari konten tersebut terhadap Bengkel.id.
### **Tagihan dan Metode Pembayaran**
1. Dalam rangka menunjang Fitur penagihan dan pembayaran pada Platform, Kami bekerja sama dengan pihak ketiga terpilih untuk memproses pembayaran dari Konsumen yang memiliki hutang kepada Konsumen lainnya yang memiliki piutang (“**Pihak Ketiga Terpilih**”), dimana seluruh dana pembayaran akan diterima oleh dari dan oleh Konsumen melalui Pihak Ketiga Terpilih tersebut. Pihak Ketiga Terpilih yang dimaksud diantaranya adalah penyedia layanan *payment gateway* yakni Xendit, OY, dan/atau pihak lain yang mana akan melakukan kerjasama dengan Bengkel.id di masa depan.
1. Penagihan dilakukan dengan cara pengiriman tautan Pembayaran oleh Konsumen yang memiliki piutang ke Konsumen lainnya melalui menu ‘Tagih’ oleh Konsumen yang memiliki piutang melalui pesan singkat (SMS) atau aplikasi Whatsapp ke nomor telepon terdaftar Konsumen yang memiliki jumlah terutang setelah melakukan konfirmasi penagihan.
1. Dalam rangka menjaga keamanan transaksi, Konsumen yang melakukan penagihan akan diwajibkan untuk membuat nomor PIN sebagai bentuk otentikasi.
1. Setelah Konsumen lainnya menerima tautan Pembayaran, Konsumen dapat melakukan pembayaran dengan memilih metode pembayaran melalui berbagai pilihan bank atau dompet digital.
1. Untuk saat ini, Bengkel.id tidak memungut biaya apapun, dan pembayaran tidak akan dikenakan potongan transfer atau bank, dan biaya komisi untuk Konsumen yang melakukan pembayaran melalui tautan pembayaran tersebut. Namun, Bengkel.id dapat membebankan biaya untuk penggunaan Platform di masa depan (untuk hal mana kami akan melakukan perubahan atas Syarat dan Ketentuan ini). Oleh karena itu, biaya bank apa pun yang dikenakan kepada Konsumen tidak berada dalam kendali Bengkel.id dan pengguna harus berkonsultasi dengan bank Konsumen masing-masing dan Bengkel.id tidak akan bertanggung jawab atas hal tersebut.
1. Bengkel.id juga menyediakan Fitur penagihan utang dan pembayaran digital dengan mengetik tombol ‘Bayar’ dalam menu pembayaran digital.
1. Anda dengan ini melepaskan Kami dari tanggung jawab apapun termasuk penggantian biaya dan ganti rugi terkait pemrosesan pembayaran, keandalan sistem pembayaran yang diselenggarakan oleh Pihak Ketiga Terpilih, atau pengembalian dana dalam hal terdapat permasalahan atas transaksi.
1. Anda bertanggung jawab atas keamanan Akun serta kode verifikasi yang dikirim oleh sistem Kami atau sistem pihak ketiga yang Kami tunjuk untuk Anda. Anda diwajibkan untuk berhati-hati akan penipuan yang sangat marak terjadi dan Kami tidak akan bertanggung jawab atas kerugian, klaim, tuntutan atau masalah apapun yang timbul akibat penipuan atau bentuk perbuatan melawan hukum dan/atau tindak pidana lainnya yang terjadi dan merugikan Anda sehubungan dengan penggunaan Fitur pada Platform kami.
### **Data Pribadi Anda**
Kami akan selalu menjaga data pribadi Anda dengan mengacu pada Syarat dan Ketentuan ini dan Hukum Yang Berlaku. Ketentuan lebih lanjut mengenai keamanan data pribadi Anda dapat diakses melalui Kebijakan Privasi Kami yang merupakan bagian yang tidak terpisahkan dari Syarat dan Ketentuan ini.
### **Jangka Waktu dan Pembatasan Hak Akses**
1. Syarat dan Ketentuan ini akan berlaku untuk waktu tidak tertentu dan tetap mengikat Anda selama Anda menggunakan Platform hingga berakhir karena alasan-alasan yang ditentukan dalam Syarat dan Ketentuan.
1. Kami dengan kewenangan Kami sendiri dapat sewaktu-waktu memberhentikan sementara, membatasi atau mengakhiri akses Anda terhadap Platform, Fitur, dan/ atau Akun Anda baik untuk sementara atau permanen tanpa pemberitahuan terlebih dahulu kepada Anda dan tanpa melanggar ketentuan Hukum Yang Berlaku, selama untuk alasan:
1. pelanggaran yang Anda lakukan terhadap seluruh maupun sebagian dari Syarat dan Ketentuan ini atau tidak terpenuhinya kewajiban Anda terhadap Kami;
1. pelanggaran hukum yang Anda lakukan yang dapat merugikan Kami secara langsung atau tidak langsung.
1. Kami akan memberikan notifikasi kepada Anda maksimal 7 (tujuh) Hari Kerja setelah Kami melakukan pemberhentian sementara, pembatasan atau pengakhiran atas akses Anda terhadap Platform, Fitur, dan/atau Akun Anda.
1. Pemberhentian sementara, pembatasan atau pengakhiran atas akses Anda terhadap Platform, Fitur, dan/ atau Akun Anda untuk sementara atau permanen tidak membatasi Kami untuk menuntut ganti kerugian, melaporkan kepada pihak berwenang, dan/ atau mengambil tindakan lain yang Kami anggap perlu untuk melindungi kepentingan Bengkel.id.


### **Hak Kekayaan Intelektual**
1. Platform, Fitur, nama, nama dagang, logo, nuansa, tampilan, tulisan, gambar, video, konten, kode pemrograman, layanan dan materi lainnya yang disediakan oleh Kami (“**Materi**”) dilindungi oleh hak kekayaan intelektual berdasarkan Hukum Yang Berlaku. Seluruh hak, kepemilikan dan kepentingan dalam Materi adalah milik Kami seluruhnya dan Kami memberikan Anda lisensi non-eksklusif yang terbatas, tidak dapat dijual dan tidak dapat dialihkan yang mana dapat dicabut atau ditarik kembali atas kewenangan Kami sendiri. Anda dengan ini memahami bahwa Anda tidak akan memiliki hak, kepemilikan atau kepentingan terhadap Materi kecuali ditentukan lain oleh Syarat dan Ketentuan ini.
1. Anda dilarang untuk menyalin, mengubah, mencetak, mengadaptasi, menerjemahkan, menciptakan karya tiruan dari, mendistribusikan, memberi lisensi, menjual, memindahkan, menggandakan, mengirimkan, membuat karya turunan dari Materi, atau mengeksploitasi bagian mana pun dari Platform Kami.
1. Jika Kami menemukan adanya indikasi/ dugaan pelanggaran Syarat dan Ketentuan ini khususnya perihal hak kekayaan intelektual, Kami berhak untuk melakukan investigasi lebih lanjut, mengakhiri akses Anda terhadap Platform beserta Fitur di dalamnya, serta melakukan upaya hukum lainnya untuk menindaklanjuti indikasi/ dugaan pelanggaran tersebut.
1. Selain Materi milik Kami, Kami dapat menampilkan logo, merek dagang, maupun konten lainnya milik Konsumen.


### **Larangan Umum**
1. Anda hanya dapat mengakses Platform dan menggunakan Fitur tanpa melanggar Hukum Yang Berlaku atau hak siapa pun. Pada saat mengakses Platform dan/atau menggunakan Fitur, Anda dilarang untuk:
1. dengan sengaja dan tanpa hak atau melawan hukum melakukan intersepsi atau penyadapan atas transmisi informasi elektronik dan/ atau dokumen elektronik atau informasi elektronik dan/atau dokumen elektronik milik Konsumen lain, atau Kami;
1. dengan sengaja dan tanpa hak atau melawan hukum dengan cara apa pun mengubah, menambah, mengurangi, melakukan transmisi, merusak, menghilangkan, memindahkan atau menyembunyikan suatu informasi elektronik dan/atau dokumen elektronik yang tertera pada Platform baik yang bersifat pribadi atau publik;
1. dengan sengaja dan tanpa hak atau melawan hukum melakukan tindakan apa pun yang berakibat terganggunya akses Konsumen lain ke Platform;
1. dengan sengaja dan tanpa hak atau melawan hukum melakukan sub-lisensi, memproduksi, menjual, mengadakan untuk digunakan oleh pihak lain, mendistribusikan, menyediakan atau mengakui kepemilikan Platform, Fitur atau hak kekayaan intelektual lainnya milik Kami;
1. dengan sengaja dan tanpa hak atau melawan hukum melakukan manipulasi, perubahan, penghilangan, pengrusakan sebagian atau seluruh Platform;
1. memanfaatkan Platform dan/ atau Fitur untuk melakukan transaksi yang mengandung unsur penipuan atau melanggar hak pihak ketiga serta melanggar ketentuan Hukum Yang Berlaku;
1. menggunakan program atau melakukan sesuatu yang dapat mengakses, mencari atau mendapatkan informasi yang bukan merupakan hak Anda dari Platform;
1. mengganggu keberlangsungan atau merusak *server* atau jaringan yang terhubung dengan Platform atau mengabaikan standar prosedur, aturan atau Hukum Yang Berlaku terhadap koneksi Internet;
1. mencoba mengakses bagian dari Platform yang Anda tidak mempunyai hak untuk melakukan akses terhadapnya;
1. melakukan tindakan plagiarisme atau melakukan publikasi atas konten atau Materi yang ditampilkan pada Platform tanpa izin dari Kami atau pihak ketiga terkait ataupun tanpa mencantumkan identitas Kami atau pihak ketiga terkait sebagai pemegang hak cipta atas konten atau Materi;
1. melakukan atau berusaha melakukan *reverse engineer*, dekompilasi, pembongkaran terhadap kode pemrograman atau algoritma atau struktur yang terdapat di dalam Platform; dan/ atau
1. melakukan, menyuruh, turut serta, memberi bantuan atau memberi kesempatan melakukan aktivitas yang melanggar hukum, melanggar Syarat dan Ketentuan ini, melanggar hak pihak ketiga, atau beriktikad buruk selama mengakses Platform.
1. Kami memiliki hak untuk menuntut ganti rugi, menggugat secara perdata maupun melakukan proses hukum secara pidana atas seluruh perbuatan yang dilarang sebagaimana dimaksud dalam Pasal ini maupun Syarat dan Ketentuan ini secara keseluruhan.


### **Akses ke Konten Pihak Ketiga**
1. Platform dapat memuat konten milik pihak ketiga atau tautan ke situs pihak ketiga, yang disediakan sebagai informasi bagi Anda. Kami telah memiliki izin atau lisensi yang diperlukan sehubungan dengan tersedianya konten atau tautan ke situs pihak ketiga yang terdapat di Platform.
1. Kami hanya bertanggung jawab terhadap segala konten yang Kami miliki. Kami tidak menjamin setiap konten yang disediakan oleh pihak ketiga di Platform adalah konten yang berkualitas, akurat, dapat dipercaya, atau bebas dari pelanggaran hukum.
1. Kami tidak dapat melakukan kontrol, mendukung atau memonitor isi dari situs pihak ketiga dan tidak akan bertanggung jawab terhadap kesalahan atau kelalaian pihak ketiga, dan Anda bertanggung jawab terhadap diri Anda sendiri atas akses Anda ke dalam situs tersebut. Syarat dan Ketentuan ini tidak mencakup akses Anda ke dalam situs pihak ketiga tersebut.


### **Pembatasan Tanggung Jawab dan Ganti Rugi**
1. Kami selalu berupaya untuk menjaga Platform Kami aman, nyaman, dan berfungsi dengan baik. Namun, Kami tidak dapat menjamin bahwa Platform ini akan beroperasi secara terus-menerus atau akses ke Platform Kami dapat selalu sempurna.
1. Platform adalah portal web yang menyediakan layanan kepada Konsumen untuk melakukan kegiatan dan transaksi melalui Platform. Dengan demikian, setiap transaksi yang terjadi adalah transaksi antar Konsumen, sehingga Konsumen dengan ini menyetujui dan mengakui bahwa tanggung jawab Bengkel.id dalam hal ini hanya terbatas pada Bengkel.id sebagai penyedia jasa portal web.
1. ANDA DENGAN INI SETUJU BAHWA KAMI TIDAK AKAN BERTANGGUNG JAWAB ATAS RISIKO PENIPUAN YANG DILAKUKAN OLEH PIHAK LAIN DI DALAM PLATFORM DIKARENAKAN HAL TERSEBUT MERUPAKAN HAL YANG BERADA DILUAR KENDALI KAMI.
1. KAMI TIDAK AKAN BERTANGGUNG JAWAB ATAS SEMUA KESALAHAN YANG ANDA LAKUKAN DIKARENAKAN KETIDAK HATI-HATIAN ANDA DALAM MENGGUNAKAN PLATFORM DAN MELAKUKAN VERIFIKASI ATAS IDENTITAS PEMBAYARAN, TERMASUK KELALAIAN ANDA DALAM MELAKUKAN KESALAHAN PENGIRIMAN DANA ATAU PEMBAYARAN.
1. ANDA DENGAN INI SETUJU BAHWA ANDA MEMANFAATKAN SITUS KAMI ATAS RISIKO ANDA SENDIRI, DAN SITUS DIBERIKAN KEPADA ANDA PADA “SEBAGAIMANA ADANYA” DAN “SEBAGAIMANA TERSEDIA”, SERTA TIDAK DAPAT DIUBAH, DIMODIFIKASI, ATAU DISESUAIKAN DENGAN PERMINTAAN KHUSUS DARI ANDA.
1. ANDA MEMILIKI KEWAJIBAN UNTUK MELAKUKAN VERIFIKASI TERHADAP KEBENARAN IDENTITAS PENGGUNA LAIN DENGAN MENERAPKAN PRINSIP KEHATI-HATIAN DALAM MELAKUKAN TRANSAKSI APAPUN DIKARENAKAN KAMI TIDAK AKAN BERTANGGUNG JAWAB ATAS RISIKO PENIPUAN APAPUN YANG TERJADI MENGGUNAKAN PLATFORM KAMI. APABILA ANDA MEMILIKI KECURIGAAN ATAU KERAGU-RAGUAN BAHWA AKUN TERSEBUT BUKANLAH AKUN ASLI DAN MERASA BAHWA TERDAPAT INDIKASI PENIPUAN, MAKA KAMI DENGAN TEGAS MENYARANKAN ANDA UNTUK TIDAK MELANJUTKAN TRANSAKSI TERSEBUT UNTUK TERHINDAR DARI KONSEKUENSI YANG TIDAK DIINGINKAN.
1. KAMI MENOLAK UNTUK MENJAMIN BAHWA SITUS BESERTA FITUR AKAN BEROPERASI TANPA TERGANGGU ATAU BAHWA SITUS DAN FITUR TERSEBUT AKAN BEBAS DARI CACAT RINGAN ATAU KESALAHAN YANG TIDAK MEMPENGARUHI KINERJA TERSEBUT SECARA MATERIIL, ATAU BAHWA SEGALA FITUR YANG TERDAPAT PADA SITUS DIRANCANG UNTUK MEMENUHI SEMUA KEBUTUHAN ANDA.
1. Kami menolak untuk menjamin bahwa seluruh layanan yang disediakan oleh Kami, termasuk Platform serta Fitur di dalamnya akan selalu dapat tersedia dan dapat digunakan secara optimal di negara lain selain Indonesia. Jika Anda menggunakan Platform, dan/ atau Fitur dari yurisdiksi selain Indonesia atau jika Anda merupakan warga negara asing, Anda bertanggung jawab sepenuhnya atas penggunaan termasuk pada pembatasan penggunaan sesuai dengan hukum yang berlaku di yurisdiksi tersebut dan yurisdiksi Anda sebagai individu.
1. Segala kerusakan yang terjadi pada jaringan komputer, telepon seluler, aplikasi, atau perangkat lainnya milik Anda akibat penggunaan Platform merupakan tanggung jawab Anda sepenuhnya, sepanjang diizinkan oleh Hukum Yang Berlaku.
1. Sepanjang diizinkan Hukum Yang Berlaku, Kami dengan ini tidak bertanggung jawab dan Anda setuju untuk tidak mengajukan klaim kepada Kami atas segala akibat, kerugian, dan/atau kerusakan yang terjadi akibat namun tidak terbatas pada:
1. informasi atau konten yang dituliskan oleh Konsumen lainnya;
1. kelalaian atau kesalahan yang Anda lakukan selama mengakses dan/atau menggunakan Platform dan/atau Fitur termasuk kelalaian Anda dalam menjaga keamanan Akun;
1. pelanggaran hak atas kekayaan intelektual pihak ketiga oleh Anda;
1. penipuan yang dilakukan oleh pihak lain;
1. gangguan, *bug*, ketidakakuratan serta kecacatan yang ada pada Platform sepanjang Kami telah melaksanakan upaya wajar yang diperlukan untuk memperbaiki Platform;
1. kerusakan jaringan komputer, telepon seluler, atau perangkat elektronik Anda akibat penggunaan Platform;
1. virus ataupun hal berbahaya lainnya yang diperoleh dengan mengakses Platform dan/ atau Fitur; dan
1. peretasan yang dilakukan pihak ketiga kepada Akun Anda selama Kami telah melaksanakan prosedur keamanan yang wajar terhadap Platform dan/ atau Fitur.
1. Apabila terdapat perselisihan yang timbul antara Anda dengan Konsumen lainnya atau pihak ketiga, Anda dengan ini setuju untuk melepaskan Kami termasuk afiliasi Kami dari klaim dan tuntutan atas kerusakan dan kerugian (aktual dan tersirat).
1. Anda dengan ini setuju bahwa akan melepaskan Kami dari tuntutan ganti rugi dan menjaga Kami termasuk afiliasi Kami dari setiap klaim atau tuntutan, termasuk biaya hukum yang wajar, yang diajukan oleh pihak ketiga yang timbul baik secara langsung atau tidak langsung akibat pelanggaran Syarat dan Ketentuan ini oleh Anda, penggunaan Platform Kami yang tidak semestinya dan/atau pelanggaran Anda terhadap Hukum Yang Berlaku atau pelanggaran atas hak-hak pihak ketiga yang dilakukan oleh Anda.
1. Untuk kepentingan Pasal ini, afiliasi berarti (i) dalam kaitannya dengan badan hukum: pihak lain yang, secara langsung atau tidak langsung mengontrol, berada di bawah kontrol bersama dengan atau dikontrol secara langsung atau tidak langsung oleh Bengkel.id, atau (ii) dalam kaitannya dengan individu, siapa pun yang mempunyai hubungan kerja atau bertindak sebagai wakil atau kuasa dari Bengkel.id.


### **Penyelesaian Perselisihan**
1. Seluruh perselisihan yang muncul antara Anda dan Kami sehubungan dengan pelaksanaan Syarat dan Ketentuan ini diselesaikan secara musyawarah dan mufakat, dengan jangka waktu 30 (tiga puluh) Hari Kerja sejak perselisihan tersebut diinformasikan kepada Kami.
1. Sebelum menghubungi Kami secara langsung untuk melakukan perundingan penyelesaian masalah atau sengketa, Anda setuju untuk tidak mengumumkan, membuat tulisan-tulisan di media online maupun cetak terkait permasalahan tersebut yang dapat menyudutkan Bengkel.id.
1. Apabila tidak tercapai kesepakatan dari musyawarah dan mufakat, maka gugatan secara perdata dapat diajukan kepada pengadilan negeri yang berwenang sesuai dengan ketentuan Hukum Yang Berlaku.
1. Selama perselisihan dalam proses penyelesaian, Anda wajib untuk tetap mematuhi serta melaksanakan kewajiban-kewajiban yang Anda harus penuhi menurut Syarat dan Ketentuan ini.


### **Lain-lain**
1. Syarat dan Ketentuan ini dibuat, dilaksanakan, tunduk dan ditafsirkan berdasarkan ketentuan hukum Republik Indonesia.
1. Syarat dan Ketentuan ini mencakup ketentuan akses atas Platform yang berlaku sebagai perjanjian yang sah antara Bengkel.id dan Anda. Anda tidak dapat mengalihkan hak dan kewajiban Anda dalam Syarat dan Ketentuan ini kepada pihak ketiga mana pun.
1. Kami selalu berusaha untuk memberikan layanan yang terbaik untuk Anda dalam mengakses Platform Kami sehingga Kami berhak untuk melakukan perubahan terhadap Syarat dan Ketentuan ini guna menyesuaikan dengan perkembangan bisnis dan ketentuan Hukum Yang Berlaku. Perubahan terhadap Syarat dan Ketentuan ini dari waktu ke waktu akan diunggah ke Platform agar Anda dapat membaca perubahan dari Syarat dan Ketentuan ini. Dengan tetap mengakses dan menggunakan Platform, Anda menyatakan telah membaca, mengerti dan setuju untuk mengikatkan diri pada perubahan Syarat dan Ketentuan ini.
1. Apabila terdapat ketentuan atau bagian dari Syarat dan Ketentuan ini yang menjadi tidak sah, tidak dapat diterapkan atau menjadi tidak berlaku, maka Kami akan menyesuaikan ketentuan tersebut agar dapat dilaksanakan sesuai Hukum Yang Berlaku, dengan mana ketentuan lainnya dari Syarat dan Ketentuan ini akan tetap berlaku sepenuhnya.
1. Syarat dan Ketentuan ini dapat diterjemahkan ke bahasa asing lainnya selain Bahasa Indonesia yang disediakan oleh Kami. Terdapat kemungkinan bahwa beberapa bagian dalam Syarat dan Ketentuan ini memiliki arti, maksud, atau pengertian yang berbeda ketika diterjemahkan ke bahasa asing lainnya. Apabila terdapat perbedaan penafsiran antara versi Bahasa Indonesia dan versi bahasa asing, maka versi Bahasa Indonesia yang akan berlaku dan Anda dianjurkan untuk merujuk kepada versi Bahasa Indonesia.

''';
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Terms and Conditions"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Markdown(
                data: _markdowndata,
                styleSheet: MarkdownStyleSheet(
                    h1: AppTheme.OpenSans700(17, Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
