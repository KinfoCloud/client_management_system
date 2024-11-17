import 'package:client_management_system/widgets/country_list.dart';
import 'package:client_management_system/widgets/custom_text_form_field.dart';
import 'package:client_management_system/widgets/file_upload_widget.dart';
import 'package:client_management_system/widgets/styled_dropdown_button_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectsStep extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  final Function(List<Map<String, dynamic>>) onProjectsChanged;

  const ProjectsStep({
    Key? key,
    required this.projects,
    required this.onProjectsChanged,
  }) : super(key: key);

  @override
  ProjectsStepState createState() => ProjectsStepState();
}

class ProjectsStepState extends State<ProjectsStep> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _cyclesController = TextEditingController();
  String _selectedCountry = 'India';
  final List<String> _countries = countryList;

  @override
  // ignore: override_on_non_overriding_member
  void initstate() {
    super.initState();
    _cyclesController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                label: 'Project Name',
                textController: _projectNameController,
                icon: Icons.business,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StyledDropdownButtonFormField(
                value: _selectedCountry,
                labelText: 'Country',
                icon: Icons.location_on,
                items: _countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: _generateProject,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: const Text('Generate Project',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 32),
        ..._buildProjectCards(),
      ],
    );
  }

  void _generateProject() {
    if (_projectNameController.text.isNotEmpty) {
      final newProject = {
        'name': _projectNameController.text,
        'country': _selectedCountry,
        'auditContractStartDate': DateTime.now(),
        'auditContractEndDate': DateTime.now().add(const Duration(days: 365)),
        'numberOfAuditCycles': 0,
        'projectLogo': '',
        'cycles': <Map<String, dynamic>>[],
      };

      setState(() {
        widget.projects.add(newProject);
        widget.onProjectsChanged(widget.projects);
        _projectNameController.clear();
      });
    }
  }

  List<Widget> _buildProjectCards() {
    return widget.projects.asMap().entries.map((entry) {
      final index = entry.key;
      final project = entry.value;
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project ${index + 1} - ${project['name']}_${project['country'].toString().substring(0, 3).toUpperCase()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField('Audit Contract Start Date',
                        project['auditContractStartDate'], (newdate) {
                      setState(() {
                        project['auditContractStartDate'] = newdate;
                        widget.onProjectsChanged(widget.projects);
                      });
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      'Audit Contract End Date',
                      project['auditContractEndDate'],
                      (newDate) {
                        setState(() {
                          project['auditContractEndDate'] = newDate;
                          widget.onProjectsChanged(widget.projects);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildAuditCyclesField(project),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Logo:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  FileUploadWidget(
                    onFileUploaded: (filePath) {
                      setState(() {
                        project['projectLogo'] = filePath;
                        widget.onProjectsChanged(widget.projects);
                      });
                    },
                    label: 'Upload Project Logo',
                    icon: Icons.camera_alt_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (project['numberOfAuditCycles'] > 0)
                _buildCyclesTable(project),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAuditCyclesField(Map<String, dynamic> project) {
    return CustomTextFormField(
      label: 'Number of Audit Cycles',
      icon: Icons.repeat,
      textController: _cyclesController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number';
        }
        return null;
      },
      obscureText: false,
      onChanged: (value) {
        int cycleCount = int.tryParse(value) ?? 0;
        setState(() {
          project['numberOfAuditCycles'] = cycleCount;
          project['cycles'] = List.generate(
            cycleCount,
            (index) => {
              'cycleNo': index + 1,
              'startDate': DateTime.now(),
              'endDate': DateTime.now().add(const Duration(days: 30)),
              'numberOfVisits': 0,
            },
          );
          widget.onProjectsChanged(widget.projects);
        });
      },
    );
  }

  Widget _buildCyclesTable(Map<String, dynamic> project) {
    return Table(
      border: TableBorder.all(),
      children: [
        const TableRow(
          children: [
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text('Cycle No.'))),
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text('Start Date'))),
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text('End Date'))),
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8), child: Text('No. of Visits'))),
          ],
        ),
        ...project['cycles'].map<TableRow>((cycle) {
          return TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(cycle['cycleNo'].toString()),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildDateField('', cycle['startDate'], (newDate) {
                    setState(() {
                      cycle['startDate'] = newDate;
                      widget.onProjectsChanged(widget.projects);
                    });
                  }),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildDateField('', cycle['endDate'], (newDate) {
                    setState(() {
                      cycle['endDate'] = newDate;
                      widget.onProjectsChanged(widget.projects);
                    });
                  }),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        cycle['numberOfVisits'] = int.tryParse(value) ?? 0;
                        widget.onProjectsChanged(widget.projects);
                      });
                    },
                    controller: TextEditingController(
                      text: cycle['numberOfVisits'].toString(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDateField(
      String label, DateTime date, Function(DateTime) onChanged) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(date),
    );

    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != date) {
          onChanged(pickedDate);
          dateController.text =
              DateFormat('yyyy-MM-dd').format(pickedDate); // Update text
        }
      },
      child: AbsorbPointer(
        child: CustomTextFormField(
          label: label,
          icon: Icons.calendar_today,
          textController: dateController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    super.dispose();
  }
}
