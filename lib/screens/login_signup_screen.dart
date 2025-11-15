import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    setState(() => _isLoading = true);

    try {
      final success = await authProvider.login(
        name: _nameController.text,
        mobileNo: _mobileController.text,
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      _showErrorDialog(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSignup() async {
    final authProvider = context.read<AuthProvider>();
    setState(() => _isLoading = true);

    try {
      final success = await authProvider.signup(
        name: _nameController.text,
        mobileNo: _mobileController.text,
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      _showErrorDialog(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _mobileController.clear();
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width >= 600;
    final contentWidth = isWeb ? width * 0.75 : width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: SafeArea(
            child: Column(
          children: [
            // Header with Bock Foods branding and gradient
            const _LoginHeaderWithGradient(),
            const SizedBox(height: 30),
            // Tab Bar for Login/Signup
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF27A600),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF27A600),
                  onTap: (_) => _clearFields(),
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Signup',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Login Tab
                  _buildLoginForm(),
                  // Signup Tab
                  _buildSignupForm(),
                ],
              ),
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Login with your credentials',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Email Field
          _buildTextField(
            controller: _emailController,
            hintText: 'Enter your email',
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Password Field
          _buildTextField(
            controller: _passwordController,
            hintText: 'Enter your password',
            label: 'Password',
            icon: Icons.lock_outlined,
            obscureText: _obscurePassword,
            onSuffixTap: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            suffixIcon: _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          const SizedBox(height: 24),
          // Login Button
          _buildActionButton(
            label: 'Login',
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Don't have an account? Switch to Signup",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign up to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          // Name Field
          _buildTextField(
            controller: _nameController,
            hintText: 'Enter your full name',
            label: 'Full Name',
            icon: Icons.person_outlined,
          ),
          const SizedBox(height: 16),
          // Mobile Field
          _buildTextField(
            controller: _mobileController,
            hintText: 'Enter 10 digit mobile number',
            label: 'Mobile Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          // Email Field
          _buildTextField(
            controller: _emailController,
            hintText: 'Enter your email',
            label: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Password Field
          _buildTextField(
            controller: _passwordController,
            hintText: 'Enter your password',
            label: 'Password',
            icon: Icons.lock_outlined,
            obscureText: _obscurePassword,
            onSuffixTap: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            suffixIcon: _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          const SizedBox(height: 16),
          // Address Field
          _buildTextField(
            controller: _addressController,
            hintText: 'Enter your address',
            label: 'Address',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          // Signup Button
          _buildActionButton(
            label: 'Sign Up',
            onPressed: _handleSignup,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Already have an account? Switch to Login',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: 1,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: const Color(0xFF27A600)),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: const Color(0xFF27A600)),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF27A600),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF27A600), Color(0xFF1E7D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF27A600).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Header section with gradient and icons - matching home screen style
class _LoginHeaderWithGradient extends StatelessWidget {
  const _LoginHeaderWithGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF27A600), Color(0xFF34D058)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative food icon on left
          Positioned(
            left: -50,
            top: 20,
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.emoji_food_beverage,
                size: 150,
                color: Colors.white,
              ),
            ),
          ),

          // Decorative restaurant icon on right
          Positioned(
            right: -30,
            top: 40,
            child: Opacity(
              opacity: 0.3,
              child: Icon(
                Icons.restaurant,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),

          // Decorative shopping bag on bottom left
          Positioned(
            left: 20,
            bottom: -20,
            child: Opacity(
              opacity: 0.25,
              child: Icon(
                Icons.shopping_bag,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),

          // ★ Centered Column with Text ★
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Bock Foods',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Order Fresh Food Online',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE8F5E9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
