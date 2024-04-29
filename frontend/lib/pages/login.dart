import 'package:flutter/material.dart';
import 'package:frontend/network.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool isLoading = false;
  // Email Validation
  final emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool validateEmail(String email) {
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  final network = NetworkService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    showPassword = true;
    _emailController.text = 't@tt.ru';
    _passwordController.text = 'tttttt';
  }

  // Sign In Function
  void login() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      try {
        await network.loginUser(
            _emailController.text, _passwordController.text);

        setState(() {});
        Future.delayed(
          const Duration(seconds: 2),
          () {
            isLoading = false;
            setState(() {});
            Navigator.pushReplacementNamed(
              context,
              '/tasks',
            );
          },
        );
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Login Page',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 50),
              Image.asset(
                "assets/images/logo.jpeg",
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your email';
                        }
                        if (!validateEmail(_emailController.text)) {
                          return 'Please Enter Valid Email';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.grey.shade900,
                          focusColor: Colors.white),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: showPassword ? false : true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.security,
                          color: Colors.grey,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(36.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade900,
                        focusColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            'New User? Register Here',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        login();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Center(
                          child: isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
