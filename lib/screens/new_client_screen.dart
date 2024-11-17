import 'package:client_management_system/widgets/app_bar_widget.dart';
import 'package:client_management_system/widgets/basic_info_step.dart';
import 'package:client_management_system/widgets/projects_step.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
// import 'package:client_management/widgets/app_bar_widget.dart';
// import 'package:client_management/models/client.dart';
// import 'package:client_management/widgets/client_form_steps/basic_info_step.dart';
// import 'package:client_management/widgets/client_form_steps/projects_step.dart';
// import 'package:client_management/widgets/client_form_steps/master_stores_step.dart';
// import 'package:client_management/widgets/client_form_steps/skus_step.dart';
// import 'package:client_management/widgets/client_form_steps/kpis_step.dart';
// import 'package:client_management/widgets/client_form_steps/summary_step.dart';
import '../widgets/progress_bar.dart';

class NewClientScreen extends StatefulWidget {
  const NewClientScreen({super.key});

  @override
  NewClientScreenState createState() => NewClientScreenState();
}

class NewClientScreenState extends State<NewClientScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // TextControllers for Basic Info Step
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _geolocationEnabled = false;
  File? _requiredImage;
  File? _optionalImage;
  String? _selectedAgent;

  final List<String> _agentOptions = [
    'Agent 1',
    'Agent 2',
    'Agent 3',
  ];

  final List<String> _stepTitles = [
    'Basic Info',
    'Projects',
    'Master Stores',
    'SKUs',
    'KPIs',
    'Summary',
  ];
  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase: $e');
      }
      // You might want to show a snackbar or dialog here to inform the user
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProgressBar(
                steps: _stepTitles,
                currentStep: _currentStep,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleNext,
        label: _currentStep == _stepTitles.length - 1
            ? const Text('Done', style: TextStyle(fontWeight: FontWeight.bold))
            : const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return BasicInfoStep(
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
          agentOptions: _agentOptions,
          selectedAgent: _selectedAgent,
          onAgentChanged: (value) => setState(() => _selectedAgent = value),
          onGeolocationToggle: (value) =>
              setState(() => _geolocationEnabled = value),
          onRequiredImageChanged: _handleRequiredImageChanged,
          onOptionalImageChanged: _handleOptionalImageChanged,
          requiredImage: _requiredImage,
          optionalImage: _optionalImage,
          geolocationEnabled: _geolocationEnabled,
        );
      case 1:
        return ProjectsStep(
            projects: _projects,
            onProjectsChanged: (updatedProjects) {
              setState(() {
                _projects = updatedProjects;
              });
            });
      case 2:
        return const Placeholder(child: Text('Master Stores Step'));
      case 3:
        return const Placeholder(child: Text('SKUs Step'));
      case 4:
        return const Placeholder(child: Text('KPIs Step'));
      case 5:
        return const Placeholder(child: Text('Summary Step'));
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleNext() {
    if (_currentStep < _stepTitles.length - 1) {
      if (_currentStep == 0 && !_validateBasicInfo()) {
        return;
      }
      setState(() {
        _currentStep++;
      });
    } else {
      _submitForm();
    }
  }

  bool _validateBasicInfo() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedAgent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return false;
    }
    // if (_requiredImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please upload a logo')),
    //   );
    //   return false;
    // }
    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Upload images to Firebase Storage
        String? requiredImageUrl =
            await _uploadImage(_requiredImage, 'required_images');
        String? optionalImageUrl =
            await _uploadImage(_optionalImage, 'optional_images');

        // Create a new client document in Firestore
        await FirebaseFirestore.instance.collection('clients').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'agent': _selectedAgent,
          'geolocationEnabled': _geolocationEnabled,
          'requiredImageUrl': requiredImageUrl,
          'optionalImageUrl': optionalImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding client: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage(File? image, String folder) async {
    if (image == null) return null;
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('$folder/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      return await storageReference.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  void _handleRequiredImageChanged(String filePath) {
    setState(() {
      _requiredImage = File(filePath);
    });
  }

  void _handleOptionalImageChanged(String filePath) {
    setState(() {
      _optionalImage = File(filePath);
    });
  }
}
