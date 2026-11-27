import 'package:flutter/material.dart';

class Catatan {
  final String judul;
  final String isi;
  final String tanggal;

  const Catatan(
      this.judul,
      this.isi,
      this.tanggal,
      );
}

// Menggunakan final List (bukan const) agar data bisa ditambah dan dihapus tanpa error
final List<Catatan> daftarCatatan = [
  const Catatan(
    'Belajar Flutter',
    'Mempelajari widget dasar seperti Text, Column, dan Container.',
    '2024-05-20',
  ),
  const Catatan(
    'Tugas Data Struktur',
    'Kerjakan soal stack dan queue pada modul 3.',
    '2024-05-21',
  ),
  const Catatan(
    'Olahraga Pagi',
    'Jogging selama 30 menit di taman kampus.',
    '2024-05-22',
  ),
];

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const DaftarCatatan(),
      '/tambah': (context) => const TambahCatatan(),
      '/detail': (context) => const DetailCatatan(),
    },
  ),
);

// Menggunakan StatefulWidget agar daftar otomatis ter-update saat kembali dari Tambah/Detail
class DaftarCatatan extends StatefulWidget {
  const DaftarCatatan({
    super.key,
  });

  @override
  State<DaftarCatatan> createState() => _DaftarCatatanState();
}

class _DaftarCatatanState extends State<DaftarCatatan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catatan Harian',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarCatatan.length,
        itemBuilder: (context, index) {
          final c = daftarCatatan[index];
          return ListTile(
            leading: const Icon(
              Icons.note_alt_outlined,
              color: Colors.indigo,
            ),
            title: Text(c.judul),
            subtitle: Text(c.tanggal),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/detail',
                arguments: c,
              );
              setState(() {});
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/tambah');
          setState(() {});
        },
      ),
    );
  }
}

class TambahCatatan extends StatefulWidget {
  const TambahCatatan({
    super.key,
  });

  @override
  State<TambahCatatan> createState() => TambahCatatanState();
}

class TambahCatatanState extends State<TambahCatatan> {
  final judulController = TextEditingController();
  final isiController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: isiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Isi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final catatanBaru = Catatan(
                      judulController.text,
                      isiController.text,
                      DateTime.now().toIso8601String().substring(0, 10),
                    );
                    setState(() {
                      daftarCatatan.insert(0, catatanBaru);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Catatan berhasil disimpan'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailCatatan extends StatelessWidget {
  const DetailCatatan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = ModalRoute.of(context)!.settings.arguments as Catatan;
    return Scaffold(
      appBar: AppBar(
        title: Text(c.judul),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.indigo,
                ),
                const SizedBox(width: 8),
                Text(
                  c.tanggal,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              c.isi,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  daftarCatatan.remove(c);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan dihapus'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}