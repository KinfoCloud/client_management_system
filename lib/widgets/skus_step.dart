import 'dart:io';
import 'dart:async';
import 'package:client_management_system/widgets/custom_file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;
import 'package:excel/excel.dart';

class SKUsStep extends StatelessWidget {
  final List<String> skus;
  final Function(List<String>) onSkusChanged;
  final List<Map<String, dynamic>> projects;

  // Function to generate and save the Excel file for SKUs
  Future<void> generateAndSaveExcel(BuildContext context) async {
    if (kIsWeb) {
      await _generateAndSaveExcelWeb();
    } else {
      await _generateAndSaveExcelMobile(context);
    }
  }

  // Function to save the Excel file for mobile
  Future<void> _generateAndSaveExcelMobile(BuildContext context) async {
    try {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        List<int> excelBytes = await _generateExcelBytes();

        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/skus_list.xlsx');
        await file.writeAsBytes(excelBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel file saved to ${file.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }

  // Function to generate the Excel file for the web
  Future<void> _generateAndSaveExcelWeb() async {
    List<int> excelBytes = await _generateExcelBytes();

    final blob = html.Blob([excelBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", "skus_list.xlsx")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  // Function to generate the Excel bytes
  Future<List<int>> _generateExcelBytes() async {
    var excel = Excel.createExcel();

    // Add a sheet
    var sheet = excel['Sheet1'];

    // Add header row data
    sheet.appendRow([
      TextCellValue("SKU Code"),
      TextCellValue("SKU Name"),
      TextCellValue('Category'),
      TextCellValue('Price'),
    ]);

    // Convert the data to bytes
    return excel.encode()!;
  }

  const SKUsStep({
    super.key,
    required this.skus,
    required this.onSkusChanged,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    // Get the last added project (if any)
    final project = projects.isNotEmpty ? projects.last : null;

    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKUs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              "Download the template",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await generateAndSaveExcel(context);
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Template'),
              ),
            ),
            const SizedBox(height: 16),

            // Display project info if available
            if (project != null) ...[
              Text(
                'Project ${projects.length} - ${project['name']}_${project['country'].toString().substring(0, 3).toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
            ],

            // File picker for "SKUs List"
            const Text(
              'SKUs List:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFileUploadWidget(
                    onFileUploaded: (filePath) {
                      // Handle file upload for SKUs List
                    },
                    buttonText: "Choose File",
                    placeholderText: "No file chosen",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // File picker for "SKU Images"
            const Text(
              'SKU Images:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFileUploadWidget(
                    onFileUploaded: (filePath) {
                      // Handle file upload for SKU Images
                    },
                    buttonText: "Choose File",
                    placeholderText: "No file chosen",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            if (skus.isNotEmpty) ...[
              Text(
                'Uploaded Files:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: skus.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.file_present),
                    title: Text(skus[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onSkusChanged(
                          skus.where((file) => file != skus[index]).toList(),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
