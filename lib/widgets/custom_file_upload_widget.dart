import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomFileUploadWidget extends StatefulWidget {
  final Function(String) onFileUploaded;
  final String buttonText;
  final String placeholderText;

  const CustomFileUploadWidget({
    Key? key,
    required this.onFileUploaded,
    this.buttonText = "Choose File",
    this.placeholderText = "No file chosen",
  }) : super(key: key);

  @override
  _CustomFileUploadWidgetState createState() => _CustomFileUploadWidgetState();
}

class _CustomFileUploadWidgetState extends State<CustomFileUploadWidget> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
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
    return Row(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            widget.buttonText,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _fileName ?? widget.placeholderText,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
