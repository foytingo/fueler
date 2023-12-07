import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NoInternetLoadingView extends StatelessWidget {
  const NoInternetLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary, size: 100));
  }
}