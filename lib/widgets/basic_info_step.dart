import 'package:client_management_system/widgets/custom_text_form_field.dart';
import 'package:client_management_system/widgets/file_upload_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BasicInfoStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController agentController;
  final Function(bool) onGeolocationToggle;
  final Function(String) onRequiredImageChanged;
  final Function(String) onOptionalImageChanged;
  final bool geolocationEnabled;
  final File? requiredImage;
  final File? optionalImage;

  const BasicInfoStep({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.agentController,
    required this.onGeolocationToggle,
    required this.onRequiredImageChanged,
    required this.onOptionalImageChanged,
    this.requiredImage,
    this.optionalImage,
    required this.geolocationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Client Name',
                    textController: nameController,
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Email',
                    textController: emailController,
                    icon: Icons.email,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Phone',
                    textController: phoneController,
                    icon: Icons.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Agent',
                    textController: agentController,
                    icon: Icons.person_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Enable Geolocation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: geolocationEnabled,
                  onChanged: onGeolocationToggle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Logo:",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 150,
                      child: FileUploadWidget(
                        onFileUploaded: onRequiredImageChanged,
                        label: 'Upload Logo',
                        icon: Icons.camera_alt_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Watermark:",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 150,
                      child: FileUploadWidget(
                        onFileUploaded: onOptionalImageChanged,
                        label: 'Upload Watermark',
                        icon: Icons.camera_alt_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (requiredImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.file(requiredImage!,
                    height: 100, width: 100, fit: BoxFit.cover),
              ),
            if (optionalImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.file(optionalImage!,
                    height: 100, width: 100, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }
}
