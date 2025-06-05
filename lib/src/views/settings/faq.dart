import 'package:flutter/material.dart';
import 'package:tridentpro/src/components/appbars/default.dart';
import 'package:tridentpro/src/components/containers/utilities.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Apa itu trading forex?',
      'answer':
      'Trading forex adalah aktivitas jual beli mata uang asing di pasar global. Tujuannya adalah memperoleh keuntungan dari pergerakan nilai tukar antar mata uang.',
    },
    {
      'question': 'Bagaimana cara membuka akun trading di aplikasi ini?',
      'answer':
      'Anda dapat membuka akun langsung melalui aplikasi dengan mengisi formulir pendaftaran, mengunggah dokumen KYC (seperti KTP dan NPWP), dan menunggu proses verifikasi dari tim kami.',
    },
    {
      'question': 'Apakah dana saya aman di PT Tridentpro Futures?',
      'answer':
      'Ya, PT Tridentpro Futures terdaftar dan diawasi oleh BAPPEBTI dan merupakan anggota resmi dari Bursa Berjangka Jakarta (BBJ) serta Kliring Berjangka Indonesia (KBI). Dana nasabah disimpan di rekening terpisah (segregated account).',
    },
    {
      'question': 'Apakah aplikasi ini menyediakan akun demo?',
      'answer':
      'Ya, kami menyediakan akun demo untuk pengguna baru agar dapat belajar dan membiasakan diri dengan platform sebelum melakukan trading riil.',
    },
    {
      'question': 'Berapa minimal deposit untuk mulai trading?',
      'answer':
      'Minimal deposit tergantung pada jenis akun yang Anda pilih. Informasi lebih detail dapat dilihat langsung di menu "Akun Trading" dalam aplikasi.',
    },
    {
      'question': 'Apakah saya bisa melakukan penarikan dana kapan saja?',
      'answer':
      'Tentu. Penarikan dana dapat dilakukan kapan saja selama hari kerja, dan akan diproses dalam waktu maksimal 1x24 jam tergantung pada sistem bank yang digunakan.',
    },
    {
      'question': 'Apakah aplikasi ini mendukung trading real-time?',
      'answer':
      'Ya, aplikasi kami menyediakan akses real-time ke pasar forex, lengkap dengan chart, indikator teknikal, dan eksekusi order secara langsung.',
    },
    {
      'question': 'Bagaimana jika saya mengalami kendala saat menggunakan aplikasi?',
      'answer':
      'Anda dapat menghubungi tim support kami melalui fitur live chat di aplikasi, atau melalui email dan nomor layanan pelanggan yang tersedia di halaman "Bantuan".',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: "",
        autoImplyLeading: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            UtilitiesWidget.titleContent(
              title: "Frequently Asking Question",
              subtitle: "Pertanyaan yang sering ditanyakan oleh Nasabah Kami",
              children: List.generate(
                faqs.length, (i) {
                  final faq = faqs[i];
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(faq['answer']!),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
