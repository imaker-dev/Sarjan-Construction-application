import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/utils/size_util.dart';
import 'package:sarjan_construction/core/widgets/app_button.dart';
import 'package:sarjan_construction/core/widgets/app_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _demoController = TextEditingController();

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.pAll(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Primary Branding Header
              Center(
                child: Padding(
                  padding: context.pSymmetric(v: 2),
                  child: const Text(
                    'Imaker Cunstuction',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Overview Card
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dashboard_rounded, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Active Field Workspace',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dynamic sizing, reusable widgets, and real-time color themes are actively applied across the app.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Demo Dynamic Widgets
              Text(
                'Reusable Widgets Showcase',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              AppTextField(
                controller: _demoController,
                labelText: 'Quick Site Note',
                hintText: 'Enter notes or material specs...',
                prefixIcon: Icons.edit_note_rounded,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Submit Note',
                      icon: Icons.check,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _demoController.text.isEmpty
                                  ? 'Please type something in the note field'
                                  : 'Note saved: ${_demoController.text}',
                            ),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Clear',
                      isOutlined: true,
                      onPressed: () {
                        _demoController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
