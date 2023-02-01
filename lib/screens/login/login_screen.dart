import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketslivescoringapp/cubits/login_cubit.dart';
import 'package:pocketslivescoringapp/cubits/matches_cubit.dart';
import 'package:pocketslivescoringapp/main.dart';
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/screens/homepage/home_screen.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';
import 'package:pocketslivescoringapp/widgets/loading_button.dart';

/// The login screen of the app.
class LoginScreen extends StatefulWidget {
  /// The constructor of the class.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// The key of the form.
  /// This is used to validate the form.
  final _formKey = GlobalKey<FormState>();

  /// The controller for passcode field.
  final _passcodeController = TextEditingController(text: '123456');

  /// login bloc
  final loginCubit = LoginCubit();

  /// Matches bloc
  final matchesCubit = MatchesCubit();

  /// The dispose method of the class.
  /// This is used to dispose  [_passcodeController]
  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  /// The build method of the class.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
            create: (context) => loginCubit,
          ),
          BlocProvider<MatchesCubit>(
            create: (context) => matchesCubit..getMatches(),
          ),
        ],
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginStateSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (context) => HomeScreen(
                    matchInfo: matchesCubit.selectedMatch!,
                    token: state.token,
                  ),
                ),
              );
            }
            if (state is LoginStateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Error'),
                ),
              );
            }
          },
          child: RefreshIndicator(
            onRefresh: () {
              matchesCubit.getMatches();
              return Future.value();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildLogo(),
                      if (kDebugMode) ...[
                        _buildBaseUrlField(),
                        const SizedBox(height: 32)
                      ],
                      _buildLabel(text: 'Select Match'),
                      const SizedBox(height: 8),
                      _buildMatchField(),
                      const SizedBox(height: 32),
                      _buildLabel(text: 'Passcode'),
                      const SizedBox(height: 8),
                      _buildPasscodeField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      _buildLoginButton(),
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
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
        ),
      );

  Widget _buildMatchField() => BlocBuilder<MatchesCubit, MatchesState>(
        builder: (context, state) {
          final dropdownItems = state.when<List<DropdownMenuItem<MatchInfo>>>(
            initial: (_) => [
              DropdownMenuItem<MatchInfo>(
                value: MatchInfo.none(),
                child: const Text('Loading...'),
              )
            ],
            loading: (_) => [
              DropdownMenuItem<MatchInfo>(
                value: MatchInfo.none(),
                child: const Text('Loading...'),
              )
            ],
            error: (state) => [
              DropdownMenuItem<MatchInfo>(
                value: MatchInfo.none(),
                child: Text(
                  '${state.message}',
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
            loaded: (state) {
              return state.matches.map((e) {
                return DropdownMenuItem<MatchInfo>(
                  value: e,
                  child: Text(
                    e.tournamentNameWithPlayers,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },
          );

          return DropdownButtonFormField(
            items: dropdownItems,
            decoration: _getFieldDecoration(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
              overflow: TextOverflow.ellipsis,
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a match';
              }
              return null;
            },
            itemHeight: 60,
            isExpanded: true,
            value: dropdownItems.first.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => matchesCubit.selectedMatch = value,
          );
        },
      );

  Widget _buildPasscodeField() => Semantics(
        label: 'Passcode',
        child: TextFormField(
          controller: _passcodeController,
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
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
        isPasscode ? CupertinoIcons.lock : CupertinoIcons.tray_full_fill,
        color: Theme.of(context).iconTheme.color,
        size: 32,
      ),
      filled: true,
      isDense: false,
      prefixIconConstraints: const BoxConstraints(
        minWidth: 54,
        minHeight: 32,
      ),
      contentPadding: const EdgeInsets.all(32),
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

    return null;
  }

  Widget _buildLoginButton() => BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          debugPrint('Login State: $state');
          return LoadingButton(
            state: state.toLoadingButtonState,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _tryLogin();
              }
            },
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          );
        },
      );

  void _tryLogin() {
    debugPrint('Trying to login');
    if (matchesCubit.selectedMatch == null) {
      return;
    }

    if (matchesCubit.selectedMatch!.id == -1) {
      return;
    }

    debugPrint('Trying to login');
    loginCubit.login(
      matchId: matchesCubit.selectedMatch!.id.toString(),
      passcode: _passcodeController.text,
    );
  }

  Widget _buildBaseUrlField() {
    return TextFormField(
      style: TextStyle(
        color: Theme.of(context).colorScheme.background,
        fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
      ),
      initialValue: AppConstants.baseUrl,
      decoration: InputDecoration(
        prefixIcon: Icon(
          CupertinoIcons.globe,
          color: Theme.of(context).iconTheme.color,
          size: 32,
        ),
        filled: true,
        isDense: false,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 54,
          minHeight: 32,
        ),
        contentPadding: const EdgeInsets.all(32),
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
      ),
      autocorrect: false,
      enableSuggestions: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.url,
      onChanged: (value) {
        baseUrl = value;
      },
    );
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
