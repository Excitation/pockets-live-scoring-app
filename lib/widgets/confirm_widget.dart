import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketslivescoringapp/cubits/confirm_cubit.dart';

/// confirm widget class
///  This shows the final score
/// also two containers asking the both players confirm the final score
/// and the submit final score button at the bottom which will be enabled
/// only when both players confirm the final score
/// this widget uses the confirm cubit to handle the confirm state

class ConfirmWidget extends StatelessWidget {
  /// The constructor of the class.
  const ConfirmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConfirmCubit, GameConfirm>(
      listener: (context, state) {
        if (state.ended) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            toolbarHeight: 70,
            title: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Final Score',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    state.matchInfo.playerOne.fullName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    state.score1.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' - ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    state.score2.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    state.matchInfo.playerTwo.fullName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConfirmCubit>().confirmPlayer1();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.player1Confirmed
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'Confirm',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConfirmCubit>().confirmPlayer2();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.player2Confirmed
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      'Confirm',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (state.loading ||
                      !state.player1Confirmed ||
                      !state.player2Confirmed) return;

                  context.read<ConfirmCubit>().endGame(state.time);
                },
                label: const Text(
                  'Submit Score',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
