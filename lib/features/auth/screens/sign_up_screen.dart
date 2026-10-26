import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_5/models/user.dart';
import 'package:flutter_application_5/services/auth_service.dart';
import 'package:flutter_application_5/data/mock_data.dart';
import 'package:flutter_application_5/models/category.dart';
import 'package:flutter_application_5/features/customer/navigation/customer_nav.dart';
import 'package:flutter_application_5/features/restaurant/navigation/restaurant_nav.dart';
import 'package:flutter_application_5/features/driver/navigation/driver_nav.dart';
import 'package:flutter_application_5/core/theme/app_theme.dart';
import 'package:flutter_application_5/core/widgets/dokan_logo.dart';
import 'package:flutter_application_5/features/auth/screens/email_verification_screen.dart';
import 'package:flutter_application_5/features/auth/screens/role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  final UserRole? role;
  const SignUpScreen({super.key, this.role});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late UserRole _currentRole;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _restaurantPhoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final Set<String> _selectedCuisineIds = {};

  String _selectedVehicleType = 'motorbike';
  bool _agreeTerms = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;
  final Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    _currentRole = widget.role ?? UserRole.customer;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _plateNumberController.dispose();
    _restaurantNameController.dispose();
    _restaurantPhoneController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام للمتابعة'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _serverErrors.clear();
    });

    try {
      final auth = context.read<AuthService>();
      final role = _currentRole;

      if (role == UserRole.customer) {
        await auth.registerClient(
          fullName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );
      } else if (role == UserRole.restaurant) {
        await auth.registerRestaurant(
          fullName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          restaurantName: _restaurantNameController.text,
          restaurantPhone: _restaurantPhoneController.text,
          description: _descriptionController.text,
          address: _addressController.text,
          lat: double.tryParse(_latController.text) ?? 0,
          lng: double.tryParse(_lngController.text) ?? 0,
          cuisineIds: _selectedCuisineIds.toList(),
        );
      } else {
        await auth.registerDriver(
          fullName: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          vehicleType: _selectedVehicleType,
          plateNumber: _plateNumberController.text,
        );
      }

      if (!mounted) return;
      final user = auth.currentUser;
      if (user != null && !user.emailVerified) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationScreen(user: user),
          ),
          (route) => false,
        );
      } else {
        _navigateToMain(role);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (e is AuthApiException) {
          _error = e.message;
          _serverErrors
            ..clear()
            ..addAll(e.fieldErrors);
        } else {
          _error = e.toString().replaceFirst('Exception: ', '');
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToMain(UserRole role) {
    switch (role) {
      case UserRole.customer:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CustomerNav()),
          (route) => false,
        );
      case UserRole.restaurant:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const RestaurantNav()),
          (route) => false,
        );
      case UserRole.driver:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DriverNav()),
          (route) => false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    const brandGreen = kEmeraldGreen;
    const textDark = Color(0xFF1E2432);
    const subtitleColor = Color(0xFF6B7280);
    const inputFill = Color(0xFFF3F4F8);
    const primaryLinkColor = kEmeraldGreen;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kEmeraldGreen,
                side: const BorderSide(color: kEmeraldGreen, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 16),
              label: const Text(
                'تغيير الحساب',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dokan Official Brand Logo
                      const Center(
                        child: DokanLogo(
                          size: 70,
                          showTagline: false,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Title
                      Text(
                        'إنشاء حساب جديد',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Subtitle
                      Text(
                        _subtitleForRole,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Interactive Role Selector Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            _buildRoleTab(UserRole.customer, 'عميل', Icons.person_outline),
                            _buildRoleTab(UserRole.driver, 'مندوب', Icons.delivery_dining_outlined),
                            _buildRoleTab(UserRole.restaurant, 'مطعم', Icons.storefront_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        hintText: 'الاسم بالكامل',
                        icon: Icons.person_outline_rounded,
                        fillColor: inputFill,
                        serverErrorKey: 'full_name',
                        errorText: _serverErrors['full_name'],
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'أدخل الاسم بالكامل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        fillColor: inputFill,
                        serverErrorKey: 'email',
                        errorText: _serverErrors['email'],
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'أدخل البريد الإلكتروني';
                          }
                          if (!val.contains('@')) {
                            return 'أدخل بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Phone Field
                      _buildTextField(
                        controller: _phoneController,
                        hintText: 'رقم الهاتف',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        fillColor: inputFill,
                        serverErrorKey: 'phone',
                        errorText: _serverErrors['phone'],
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'أدخل رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        fillColor: inputFill,
                        serverErrorKey: 'password',
                        errorText: _serverErrors['password'],
                        showPasswordToggle: true,
                        onPasswordToggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'أدخل كلمة المرور';
                          }
                          if (val.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          if (!RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)',
                          ).hasMatch(val)) {
                            return 'كلمة المرور يجب أن تحتوي على حروف وأرقام';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password Field
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hintText: 'تأكيد كلمة المرور',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        fillColor: inputFill,
                        showPasswordToggle: true,
                        onPasswordToggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'أعد إدخال كلمة المرور';
                          }
                          if (val != _passwordController.text) {
                            return 'كلمتا المرور غير متطابقتين';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      if (_currentRole == UserRole.driver) ...[
                        _buildVehicleTypeField(fillColor: inputFill),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _plateNumberController,
                          hintText: 'رقم اللوحة',
                          icon: Icons.confirmation_number_outlined,
                          fillColor: inputFill,
                          serverErrorKey: 'plate_number',
                          errorText: _serverErrors['plate_number'],
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل رقم اللوحة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Restaurant-specific fields (shown only for restaurant role)
                      if (_currentRole == UserRole.restaurant) ...[
                        _buildTextField(
                          controller: _restaurantNameController,
                          hintText: 'اسم المطعم',
                          icon: Icons.restaurant_outlined,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل اسم المطعم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _restaurantPhoneController,
                          hintText: 'هاتف المطعم',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل هاتف المطعم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _descriptionController,
                          hintText: 'وصف المطعم',
                          icon: Icons.description_outlined,
                          keyboardType: TextInputType.multiline,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل وصف المطعم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _addressController,
                          hintText: 'عنوان المطعم',
                          icon: Icons.location_on_outlined,
                          keyboardType: TextInputType.streetAddress,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل عنوان المطعم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _latController,
                          hintText: 'خط العرض (Lat)',
                          icon: Icons.place_outlined,
                          keyboardType: TextInputType.number,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل خط العرض';
                            }
                            if (double.tryParse(val.trim()) == null) {
                              return 'قيمة غير صالحة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _lngController,
                          hintText: 'خط الطول (Lng)',
                          icon: Icons.place_outlined,
                          keyboardType: TextInputType.number,
                          fillColor: inputFill,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'أدخل خط الطول';
                            }
                            if (double.tryParse(val.trim()) == null) {
                              return 'قيمة غير صالحة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Cuisine multi-select
                        _buildCuisineSelect(),
                        const SizedBox(height: 18),
                      ],

                      // Terms and Conditions Checkbox
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            child: Checkbox(
                              value: _agreeTerms,
                              activeColor: const Color(0xFF1E2B48),
                              checkColor: Colors.white,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              onChanged: (val) {
                                setState(() {
                                  _agreeTerms = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  () => setState(
                                    () => _agreeTerms = !_agreeTerms,
                                  ),
                              child: const Text(
                                'أوافق على شروط الاستخدام وسياسة الخصوصية',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E2432),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Error message if any
                      if (_error != null && _serverErrors.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],

                      // Sign Up Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'إنشاء الحساب',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لديك حساب بالفعل؟ ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryLinkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _subtitleForRole {
    switch (_currentRole) {
      case UserRole.restaurant:
        return 'أنشئ حساباً جديداً لإدارة مطعمك وعملائك';
      case UserRole.driver:
        return 'انضم إلينا وابدأ في توصيل الطلبات والأرباح';
      default:
        return 'أنشئ حسابك واستمتع بأشهى المأكولات بسرعة وسهولة';
    }
  }

  Widget _buildRoleTab(UserRole role, String title, IconData icon) {
    final isSelected = _currentRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentRole = role;
            _serverErrors.clear();
            _error = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? kEmeraldGreen : const Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? kEmeraldGreen : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    required Color fillColor,
    String? serverErrorKey,
    String? errorText,
    bool showPasswordToggle = false,
    VoidCallback? onPasswordToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) {
        if (serverErrorKey != null &&
            _serverErrors.containsKey(serverErrorKey)) {
          setState(() {
            _serverErrors.remove(serverErrorKey);
            if (_serverErrors.isEmpty) {
              _error = null;
            }
          });
        }
      },
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF1E2432),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF8C93A3),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: fillColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 14),
          child: Icon(icon, color: const Color(0xFF5A6275), size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        suffixIcon:
            showPasswordToggle
                ? GestureDetector(
                  onTap: onPasswordToggle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF5A6275),
                      size: 22,
                    ),
                  ),
                )
                : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kEmeraldGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildVehicleTypeField({required Color fillColor}) {
    return DropdownButtonFormField<String>(
      value: _selectedVehicleType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'اختر نوع المركبة';
        }
        return null;
      },
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedVehicleType = value;
          _serverErrors.remove('vehicle_type');
          if (_serverErrors.isEmpty) {
            _error = null;
          }
        });
      },
      items: const [
        DropdownMenuItem(value: 'motorbike', child: Text('دراجة نارية')),
        DropdownMenuItem(value: 'bicycle', child: Text('دراجة')),
        DropdownMenuItem(value: 'car', child: Text('سيارة')),
      ],
      decoration: InputDecoration(
        hintText: 'نوع المركبة',
        filled: true,
        fillColor: fillColor,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 14),
          child: Icon(
            Icons.two_wheeler_outlined,
            color: Color(0xFF5A6275),
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kEmeraldGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorText: _serverErrors['vehicle_type'],
      ),
    );
  }

  Widget _buildCuisineSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نوع المطبخ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E2432),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              MockData.categories.map((Category cat) {
                final selected = _selectedCuisineIds.contains(cat.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedCuisineIds.remove(cat.id);
                      } else {
                        _selectedCuisineIds.add(cat.id);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? kEmeraldGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            selected
                                ? kEmeraldGreen
                                : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        color:
                            selected ? Colors.white : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
