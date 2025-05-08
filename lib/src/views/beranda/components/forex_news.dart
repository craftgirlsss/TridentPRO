import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForexNews extends StatefulWidget {
  const ForexNews({super.key});

  @override
  State<ForexNews> createState() => _ForexNewsState();
}

class _ForexNewsState extends State<ForexNews> {
  double itemHeight = 100.0;
  double maxVisibleItems = 3;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Global Forex News", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 8 > maxVisibleItems
              ? itemHeight * maxVisibleItems
              : itemHeight * 8,
          ),
          child: ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Berita ke ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Deskripsi Berita ke ${index + 1}"),
                    SizedBox(height: 4),
                    Text("Published: ${DateFormat('MMMM, dd yyyy').format(now)}", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
