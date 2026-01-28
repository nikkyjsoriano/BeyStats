import 'package:bey_stats/views/battlepass/onboarding/debug_results_view.dart';
import 'package:bey_stats/views/battlepass/onboarding/error_onboarding.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_pairing.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_remove_bey.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_scanning.dart';
import 'package:bey_stats/views/battlepass/onboarding/onboarding_turnon.dart';
import 'package:bey_stats/views/battlepass/onboarding/stats_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BattlepassOnboarding extends StatefulWidget {
  final VoidCallback _closeModal;
  final bool skipOnboarding;

  const BattlepassOnboarding(this._closeModal, {this.skipOnboarding = false, super.key});

  @override
  BattlepassOnboardingState createState() => BattlepassOnboardingState();
}

class BattlepassOnboardingState extends State<BattlepassOnboarding> {
  late PageController _pageController;

  int pageIndex = 0;
  List<Widget> pages = [];
  bool _hasCheckedSkipOnboarding = false;

  void nextModalPage() {
    pageIndex = 1;
    _pageController.nextPage(
        duration: const Duration(milliseconds: 100), curve: Curves.decelerate);
  }

  void errorModalPage() {
    pageIndex = 6;
    _pageController.animateToPage(5,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void debugResultsPage() {
    pageIndex = 7;
    _pageController.animateToPage(6,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    pages.add(OnboardingTurnon(nextModalPage, widget._closeModal));
    pages.add(OnboardingRemoveBey(nextModalPage, widget._closeModal));
    pages.add(OnboardingPairing(nextModalPage, widget._closeModal));
    pages.add(
        OnboardingScanning(nextModalPage, widget._closeModal, errorModalPage, debugResultsPage));
    pages.add(StatsOnboarding(() {}, widget._closeModal));
    pages.add(ErrorOnboarding(widget._closeModal));
    pages.add(DebugResultsView(widget._closeModal));

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedSkipOnboarding) {
      _hasCheckedSkipOnboarding = true;
      if (widget.skipOnboarding) {
        // Skip to scanning page (index 3)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(3);
          setState(() {
            pageIndex = 3;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (value) => {
              setState(() {
                pageIndex = value;
              })
            },
        itemBuilder: (_, i) {
          return pages[i];
        });
  }
}
