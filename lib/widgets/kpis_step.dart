import 'package:client_management_system/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class KPIsStep extends StatefulWidget {
  final List<Map<String, dynamic>> kpis;
  final Function(Map<String, double>) onKPIsChanged;
  final List<Map<String, dynamic>> projects;

  const KPIsStep({
    super.key,
    required this.kpis,
    required this.onKPIsChanged,
    required this.projects,
  });

  @override
  _KPIsStepState createState() => _KPIsStepState();
}

class _KPIsStepState extends State<KPIsStep> {
  final TextEditingController _kpiNameController = TextEditingController();
  final TextEditingController _kpiDescriptionController =
      TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryCodeController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _skuCodeController = TextEditingController();
  final TextEditingController _skuNameController = TextEditingController();

  bool _isCategoryCodeChecked = false;
  bool _isCategoryNameChecked = false;
  bool _isBrandNameChecked = false;
  bool _isSkuCodeChecked = false;
  bool _isSkuNameChecked = false;

  final List<Map<String, String>> _tableData = [];

  @override
  Widget build(BuildContext context) {
    final project = widget.projects.isNotEmpty ? widget.projects.last : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KPIs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            if (project != null) ...[
              Text(
                'Project ${widget.projects.length} - ${project['name']}_${project['country'].toString().substring(0, 3).toUpperCase()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
            ],
            CustomTextFormField(
              label: 'KPI Name',
              textController: _kpiNameController,
              icon: Icons.text_fields,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: 'KPI Description',
              textController: _kpiDescriptionController,
              icon: Icons.description,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Category Code'),
                    value: _isCategoryCodeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCategoryCodeChecked = value ?? false;
                      });
                    },
                  ),
                ),
                if (_isCategoryCodeChecked)
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Category Code',
                      textController: _categoryCodeController,
                      icon: Icons.code,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Category Name'),
                    value: _isCategoryNameChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCategoryNameChecked = value ?? false;
                      });
                    },
                  ),
                ),
                if (_isCategoryNameChecked)
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Category Name',
                      textController: _categoryNameController,
                      icon: Icons.label,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Brand Name'),
                    value: _isBrandNameChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isBrandNameChecked = value ?? false;
                      });
                    },
                  ),
                ),
                if (_isBrandNameChecked)
                  Expanded(
                    child: CustomTextFormField(
                      label: 'Brand Name',
                      textController: _brandNameController,
                      icon: Icons.local_offer,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('SKU Code'),
                    value: _isSkuCodeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isSkuCodeChecked = value ?? false;
                      });
                    },
                  ),
                ),
                if (_isSkuCodeChecked)
                  Expanded(
                    child: CustomTextFormField(
                      label: 'SKU Code',
                      textController: _skuCodeController,
                      icon: Icons.code,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('SKU Name'),
                    value: _isSkuNameChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isSkuNameChecked = value ?? false;
                      });
                    },
                  ),
                ),
                if (_isSkuNameChecked)
                  Expanded(
                    child: CustomTextFormField(
                      label: 'SKU Name',
                      textController: _skuNameController,
                      icon: Icons.label,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addKPIToTable,
              child: const Text('Add'),
            ),
            const SizedBox(height: 16),
            _buildKpiTable(),
          ],
        ),
      ),
    );
  }

  void _addKPIToTable() {
    setState(() {
      _tableData.add({
        'KPI': _kpiNameController.text,
        'Description': _kpiDescriptionController.text,
        'Category Name': _categoryNameController.text,
        'Category Code': _categoryCodeController.text,
        'Brand Name': _brandNameController.text,
        'SKU Code': _skuCodeController.text,
        'SKU Name': _skuNameController.text,
      });

      _kpiNameController.clear();
      _kpiDescriptionController.clear();
      _categoryNameController.clear();
      _categoryCodeController.clear();
      _brandNameController.clear();
      _skuCodeController.clear();
      _skuNameController.clear();
      _isCategoryCodeChecked = false;
      _isCategoryNameChecked = false;
      _isBrandNameChecked = false;
      _isSkuCodeChecked = false;
      _isSkuNameChecked = false;
    });

    Map<String, double> updatedKPIs = {};
    widget.onKPIsChanged(updatedKPIs);
  }

  Widget _buildKpiTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('KPI')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Category Name')),
        DataColumn(label: Text('Category Code')),
        DataColumn(label: Text('Brand Name')),
        DataColumn(label: Text('SKU Code')),
        DataColumn(label: Text('SKU Name')),
      ],
      rows: _tableData
          .map(
            (data) => DataRow(
              cells: [
                DataCell(Text(data['KPI'] ?? '')),
                DataCell(Text(data['Description'] ?? '')),
                DataCell(Text(data['Category Name'] ?? '')),
                DataCell(Text(data['Category Code'] ?? '')),
                DataCell(Text(data['Brand Name'] ?? '')),
                DataCell(Text(data['SKU Code'] ?? '')),
                DataCell(Text(data['SKU Name'] ?? '')),
              ],
            ),
          )
          .toList(),
    );
  }
}
