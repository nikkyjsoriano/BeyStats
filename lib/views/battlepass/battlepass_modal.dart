import 'package:bey_stats/app_states/experiment_state.dart';
import 'package:bey_stats/views/battlepass/onboarding/battlepass_onboarding.dart';
import 'package:flutter/material.dart';

class BattlepassModal extends StatelessWidget {
  const BattlepassModal({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Read experiment value before opening modal (while we have BlocProvider access)
          final skipOnboarding = ExperimentState.isSkipOnboardingExperimentOn(context);
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 900,
                  padding: const EdgeInsets.fromLTRB(20, 13, 20, 28),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                            child: BattlepassOnboarding(
                                () => Navigator.pop(context),
                                skipOnboarding: skipOnboarding))
                      ],
                    ),
                  ),
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.sync,
          size: 25,
        )
        //params
        );
  }
}
