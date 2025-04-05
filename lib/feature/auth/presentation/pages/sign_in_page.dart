import 'package:blog_app/feature/auth/presentation/widgets/auth_feilds.dart';
import 'package:blog_app/feature/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthFeilds(hintText: 'Email', controller: emailController),
                const SizedBox(height: 15),
                AuthFeilds(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                const AuthGradientButton(buttontext: 'Sign In'),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(signuppage);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: ' Sign Up',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color.fromRGBO(111, 92, 255, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
