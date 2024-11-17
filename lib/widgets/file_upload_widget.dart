import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(String) onFileUploaded;
  final String label;
  final IconData icon;

  const FileUploadWidget({
    Key? key,
    required this.onFileUploaded,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
      widget.onFileUploaded(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(
              _fileName ?? widget.label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
