import 'package:flutter/material.dart';
import 'package:netflix/providers/download_provider.dart';
import 'package:provider/provider.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    DownloadProvider dp = Provider.of<DownloadProvider>(context, listen: true);
    return dp.downloads.isEmpty
        ? Center(
            child: Text("No Downloads Yet"),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: dp.downloads.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  dp.downloads.values.toList()[index][0],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  dp.downloads.values.toList()[index][2] == 100
                      ? 'Download Completed'
                      : '${dp.downloads.values.toList()[index][2].toStringAsFixed(2)}%',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: dp.downloads.values.toList()[index][2] == 100
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                      )
                    : CircularProgressIndicator(
                        value: dp.downloads.values.toList()[index][2] / 100,
                      ),
              );
            },
          );
  }
}
