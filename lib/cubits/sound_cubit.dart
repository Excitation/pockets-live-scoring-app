import 'package:flutter_bloc/flutter_bloc.dart';

/// sound cubit to toggle the sound of the app.
class SoundCubit extends Cubit<bool> {
  /// The constructor of the class.
  /// The default value is true.
  SoundCubit() : super(true);

  /// Toggles the sound of the app.
  void toggleSound() {
    emit(!state);
  }
}
