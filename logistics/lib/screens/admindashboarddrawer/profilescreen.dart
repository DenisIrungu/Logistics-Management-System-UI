import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistcs/blocs/admin/admin_bloc.dart';
import 'package:logistcs/blocs/admin/admin_event.dart';
import 'package:logistcs/blocs/admin/admin_state.dart';
import 'package:logistcs/components/myButton.dart';
import 'package:logistcs/components/mytextfield.dart';
import 'package:logistcs/services/api_client.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _newProfilePicture;
  bool _isEditingPicture = false;
  bool _hasFetchedProfile = false;
  int? _profilePictureTimestamp;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  String _initialName = '';
  String _initialEmail = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    print('ProfileScreen: initState called');
    _profilePictureTimestamp = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasFetchedProfile) {
        print('ProfileScreen: Triggering initial FetchAdminProfile');
        context.read<AdminBloc>().add(FetchAdminProfile());
        _hasFetchedProfile = true;
      }
    });
  }

  @override
  void dispose() {
    print('ProfileScreen: dispose called');
    _nameController.dispose();
    _emailController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _onChangePicture() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _newProfilePicture = File(pickedFile.path);
          _isEditingPicture = true;
        });
      }
    } catch (e, stack) {
      print('Error picking image: $e');
      print('Stack trace: $stack');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _onSavePicture() {
    setState(() {
      _isEditingPicture = false;
    });
    context.read<AdminBloc>().add(UpdateAdminProfile(
          profilePicture: _newProfilePicture,
        ));
    setState(() {
      _newProfilePicture = null;
    });
  }

  void _onCancelPicture() {
    setState(() {
      _newProfilePicture = null;
      _isEditingPicture = false;
    });
  }

  void _onDeletePicture() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile Picture'),
        content:
            const Text('Are you sure you want to delete your profile picture?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<AdminBloc>().add(const UpdateAdminProfile(
                    profilePicture: null,
                  ));
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _onDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to request account deletion? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account deletion request submitted')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return "Email cannot be empty";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  Future<bool> _requestVerificationCode(String type) async {
    try {
      print(
          'ProfileScreen: Sending verification code request with type: $type');
      final response = await ApiClient().post(
        '/admin/send-verification-code',
        queryParams: {'type': type},
      );
      print(
          'ProfileScreen: Response received: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to send verification code: ${response.body}');
      }
    } catch (e) {
      print('ProfileScreen: Error in _requestVerificationCode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send verification code: $e')),
      );
      return false;
    }
  }

  Future<String?> _showVerificationCodeDialog() async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Verification Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('A verification code has been sent to your email.'),
            const SizedBox(height: 16),
            MyTextField(
              controller: _verificationCodeController,
              hintText: 'Enter 6-digit code',
              obscureText: false,
              keyboardType: TextInputType.number,
              maxlength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _verificationCodeController.clear();
              Navigator.pop(context, null);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final code = _verificationCodeController.text.trim();
              if (code.length != 6 || !RegExp(r'^\d+$').hasMatch(code)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter a valid 6-digit code')),
                );
                return;
              }
              Navigator.pop(context, code);
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _onSaveChanges() {
    final newEmail = _emailController.text.trim();
    final emailError = _validateEmail(newEmail);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }

    final hasNameChanged = _nameController.text != _initialName;
    final hasEmailChanged = newEmail != _initialEmail;
    final hasProfilePictureChanged = _newProfilePicture != null;

    if (!hasNameChanged && !hasEmailChanged && !hasProfilePictureChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to save')),
      );
      return;
    }

    if (hasEmailChanged) {
      _requestVerificationCode('email').then((codeSent) async {
        if (!codeSent) return;

        final verificationCode = await _showVerificationCodeDialog();
        if (verificationCode == null) return;

        context.read<AdminBloc>().add(UpdateAdminProfile(
              name: hasNameChanged ? _nameController.text : null,
              email: hasEmailChanged ? newEmail : null,
              verificationCode: verificationCode,
              profilePicture:
                  hasProfilePictureChanged ? _newProfilePicture : null,
            ));
      });
    } else {
      context.read<AdminBloc>().add(UpdateAdminProfile(
            name: hasNameChanged ? _nameController.text : null,
            profilePicture:
                hasProfilePictureChanged ? _newProfilePicture : null,
          ));
      setState(() {
        _newProfilePicture = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ProfileScreen: Building');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AdminBloc, AdminBlocState>(
        listener: (context, state) {
          print('ProfileScreen: BlocConsumer listener - state: $state');
          if (state.updateState is UpdateSuccess) {
            _initialName = _nameController.text;
            _initialEmail = _emailController.text;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            setState(() {
              _newProfilePicture = null;
              _profilePictureTimestamp = DateTime.now().millisecondsSinceEpoch;
            });
            print(
                'ProfileScreen: Triggering FetchAdminProfile after UpdateSuccess');
            context.read<AdminBloc>().add(FetchAdminProfile());
          } else if (state.updateState is UpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Failed to update profile: ${(state.updateState as UpdateFailure).error}'),
              ),
            );
          }
        },
        builder: (context, state) {
          print('ProfileScreen: BlocConsumer builder - state: $state');
          if (state.profileState is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.profileState is ProfileSuccess) {
            final profile = (state.profileState as ProfileSuccess).adminProfile;
            if (_nameController.text.isEmpty) {
              _nameController.text = profile.name;
            }
            if (_emailController.text.isEmpty) {
              _emailController.text = profile.email;
            }
            if (_initialName.isEmpty) {
              _initialName = profile.name;
            }
            if (_initialEmail.isEmpty) {
              _initialEmail = profile.email;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFFF9500), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _newProfilePicture != null
                              ? FileImage(_newProfilePicture!)
                              : profile.profilePicture != null
                                  ? NetworkImage(
                                      '${ApiClient.baseUrl}${profile.profilePicture}?t=$_profilePictureTimestamp',
                                    )
                                  : null,
                          child: _newProfilePicture == null &&
                                  profile.profilePicture == null
                              ? Text(
                                  _nameController.text.isNotEmpty
                                      ? _nameController.text[0].toUpperCase()
                                      : 'J',
                                  style: const TextStyle(
                                      fontSize: 40, color: Color(0xFF0F0156)),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _onChangePicture,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0F0156),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  state.updateState is UpdateLoading && _isEditingPicture
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _isEditingPicture
                              ? [
                                  ElevatedButton(
                                    onPressed: _onSavePicture,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F0156),
                                    ),
                                    child: const Text('Save'),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: _onCancelPicture,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF0F0156),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ]
                              : [
                                  OutlinedButton(
                                    onPressed: profile.profilePicture != null
                                        ? _onDeletePicture
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFFFF9500),
                                      disabledForegroundColor:
                                          const Color(0xFFFF9500)
                                              .withOpacity(0.5),
                                      side: const BorderSide(
                                        color: Color(0xFF0F0156),
                                        width: 2.0,
                                      ),
                                    ),
                                    child: const Text('Delete Picture'),
                                  ),
                                ],
                        ),
                  const SizedBox(height: 24),
                  MyTextField(
                    controller: _nameController,
                    hintText: 'Your Name',
                    obscureText: false,
                    labelText: 'Name',
                    suffixIcon: const Icon(Icons.edit),
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: _emailController,
                    hintText: 'example@gmail.com',
                    obscureText: false,
                    labelText: 'Email',
                    suffixIcon: const Icon(Icons.edit),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  state.updateState is UpdateLoading && !_isEditingPicture
                      ? const CircularProgressIndicator()
                      : MyButton(
                          text: 'Save Changes',
                          onPress: _onSaveChanges,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: _onDeleteAccount,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF0F0156),
                        width: 2.0,
                      ),
                      foregroundColor: const Color(0xFFFF9500),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Request Account Deletion',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.profileState is ProfileFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Failed to load profile: ${(state.profileState as ProfileFailure).error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print(
                          'ProfileScreen: Retry button pressed - Triggering FetchAdminProfile');
                      context.read<AdminBloc>().add(FetchAdminProfile());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }
}
