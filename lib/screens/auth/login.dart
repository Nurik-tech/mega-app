import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password) onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isDarkMode = false;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate async login
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        widget.onLogin(_emailController.text, _passController.text);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1DB954); // eToro-style green (you can pick your own)
    final backgroundColor = _isDarkMode ? Colors.black : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                    'assets/stockman.PNG',
                      height: 80,
                      fit: BoxFit.contain,
                    ), // Your app logo here
            const SizedBox(height: 48),


            Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email TextField
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.email, color: textColor.withOpacity(0.5)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password TextField
                        TextFormField(
                          controller: _passController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: textColor.withOpacity(0.3)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            prefixIcon: Icon(Icons.lock, color: textColor.withOpacity(0.5)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: textColor.withOpacity(0.5),
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: forgot password action
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: textColor.withOpacity(0.7)),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: navigate to register
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Theme toggle button at top-right
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: _isDarkMode ? Colors.white : Colors.black54),
                  tooltip: _isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
                  onPressed: _toggleTheme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


