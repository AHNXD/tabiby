import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../shared/settings/view/settings_screen.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_form.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _residenceController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  String? _maritalStatus;
  String? _isSmoker;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _residenceController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _maritalStatus = null;
    _isSmoker = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _residenceController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Changes Saved Successfully!'),
          backgroundColor: Colors.green[600],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fix the errors in the form.'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "My Profile",
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const ProfileAvatar(),
              const SizedBox(height: 24),
              ProfileForm(
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                residenceController: _residenceController,
                heightController: _heightController,
                weightController: _weightController,
                maritalStatus: _maritalStatus,
                isSmoker: _isSmoker,
                onMaritalStatusChanged: (v) =>
                    setState(() => _maritalStatus = v),
                onIsSmokerChanged: (v) => setState(() => _isSmoker = v),
              ),
              const SizedBox(height: 30),
              PrimaryButton(text: "Save Changes", onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }
}
