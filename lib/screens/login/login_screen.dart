import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketslivescoringapp/providers/login_provider.dart';
import 'package:pocketslivescoringapp/providers/tables_provider.dart';
import 'package:pocketslivescoringapp/widgets/loading_button.dart';

/// The login screen of the app.
class LoginScreen extends ConsumerStatefulWidget {
  /// The constructor of the class.
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// The key of the form.
  /// This is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  /// The controllers for the email and password fields.
  final _tableController = TextEditingController();
  final _passcodeController = TextEditingController();

  /// The dispose method of the class.
  /// This is used to dispose [_tableController] and [_passcodeController]
  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  /// The build method of the class.
  @override
  Widget build(BuildContext context) {
    _listenToLoginState();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildLogo(),
              _buildLabel(text: 'Select Table'),
              const SizedBox(height: 8),
              _buildTableField(),
              const SizedBox(height: 32),
              _buildLabel(text: 'Passcode'),
              const SizedBox(height: 8),
              _buildPasscodeField(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the logo widget.
  Widget _buildLogo() => Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
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

  Widget _buildTableField() => DropdownButtonFormField(
        items: _dropdownItems,
        decoration: _getFieldDecoration(),
        validator: (value) {
          if (value == null) {
            return 'Please select a table';
          }
          return null;
        },
        value: _dropdownItems.first.value,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _tableController.text = value.toString(),
      );

  Widget _buildPasscodeField() => Semantics(
        label: 'Passcode',
        child: TextFormField(
          controller: _passcodeController,
          decoration: _getFieldDecoration(isPasscode: true),
          autocorrect: false,
          enableSuggestions: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.number,
          validator: _validatePasscode,
        ),
      );

  InputDecoration _getFieldDecoration({bool isPasscode = false}) {
    return InputDecoration(
      prefixIcon: Icon(
        isPasscode ? Icons.pin : Icons.table_restaurant,
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

  /// Validates the password.
  String? _validatePasscode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passcode cannot be empty';
    }

    if (value.length != 6) {
      return 'Passcode must be 6 digits';
    }
    return null;
  }

  Widget _buildLoginButton() => LoadingButton(
        state: ref.watch(loginProvider).toLoadingButtonState,
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
    ref.read(loginProvider.notifier).login(
          _tableController.text,
          _passcodeController.text,
        );
  }

  List<DropdownMenuItem<int>> get _dropdownItems {
    final tables = ref.watch(tablesProvider);
    return tables.when(
      data: (tables) {
        return tables
            .map(
              (table) => DropdownMenuItem<int>(
                value: table.id,
                child: Text(table.name),
              ),
            )
            .toList();
      },
      error: (error, trace) {
        return [
          DropdownMenuItem<int>(value: -1, child: Text(error.toString()))
        ];
      },
      loading: () {
        return [
          const DropdownMenuItem<int>(value: -1, child: Text('Loading...'))
        ];
      },
    );
  }

  /// Listens to the login state.
  /// This is called when the widget is mounted.
  void _listenToLoginState() {
    ref.listen(loginProvider, (previous, next) {
      if (next is LoginStateSuccess) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}

/// Login State to LoadingButton State mapping.
extension LoginStateToLoadingButtonState on LoginState {
  /// Returns the [LoadingButtonState] for the [LoginState].
  LoadingButtonState get toLoadingButtonState {
    if (this is LoginStateLoading) {
      return LoadingButtonState.loading;
    } else if (this is LoginStateError) {
      return LoadingButtonState.idle;
    } else if (this is LoginStateSuccess) {
      return LoadingButtonState.done;
    } else {
      return LoadingButtonState.idle;
    }
  }
}
