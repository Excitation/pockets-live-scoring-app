import 'package:flutter/material.dart';
import 'package:pocketslivescoringapp/network/api_service.dart';
import 'package:pocketslivescoringapp/providers/login_state_provider.dart';
import 'package:pocketslivescoringapp/utils/toast_utils.dart';
import 'package:pocketslivescoringapp/widgets/loading_button.dart';
import 'package:provider/provider.dart';

/// The login screen of the app.
class LoginScreen extends StatefulWidget {
  /// The constructor of the class.
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// The key of the form.
  /// This is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  /// The controllers for the email and password fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// bool to check if the password is hidden or not.
  bool _isPasswordHidden = true;

  /// The current state of the login button.
  LoadingButtonState _loginButtonState = LoadingButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildLogo(),
              const SizedBox(height: 16),
              _buildLabel(text: 'Username/Email'),
              const SizedBox(height: 8),
              _buildEmailField(),
              const SizedBox(height: 32),
              _buildLabel(text: 'Password'),
              const SizedBox(height: 8),
              _buildPasswordField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() => Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      );

  /// [text] is the text to be displayed in the label.
  Widget _buildLabel({required String text}) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );

  Widget _buildEmailField() => TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _getFieldDecoration(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _validateEmailUsername,
        autocorrect: false,
      );

  Widget _buildPasswordField() => Semantics(
        label: 'Password',
        child: TextFormField(
          controller: _passwordController,
          decoration: _getFieldDecoration(isPassword: true),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: _isPasswordHidden,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          validator: _validatePassword,
        ),
      );

  InputDecoration _getFieldDecoration({bool isPassword = false}) {
    return InputDecoration(
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
              ),
              color: Theme.of(context).iconTheme.color,
              onPressed: _togglePasswordVisibility,
            )
          : Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.secondary,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  /// Toggles the visibility of the password.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  /// Validates the email.
  String? _validateEmailUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email/Username cannot be empty';
    }
    return null;
  }

  /// Validates the password.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length < 6) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  Widget _buildLoginButton() => LoadingButton(
        state: _loginButtonState,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _tryLogin();
          }
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      );

  void _tryLogin() {
    setState(() {
      _loginButtonState = LoadingButtonState.loading;
    });

    ApiService.instance.login(_emailController.text, _passwordController.text)
      ..then((value) {
        setState(() {
          _loginButtonState = LoadingButtonState.done;
        });
        _handleLoginSuccess();
      })
      ..catchError((dynamic error) {
        setState(() {
          _loginButtonState = LoadingButtonState.idle;
        });
        _showErrorToast(error.toString());
        return false;
      });
  }

  void _showErrorToast(String string) {
    ToastUtils.showErrorToast(context, string);
  }

  void _handleLoginSuccess() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Provider.of<LoginStateProvider>(context, listen: false)
          .setLoginState(LoginState.loggedIn);
    });
  }
}
