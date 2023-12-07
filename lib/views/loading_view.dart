
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingView{

  LoadingView(this.context);

  late BuildContext context;


  Future<void> startLoading() async {
    return await showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context){
      return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).colorScheme.primary,size: 100,),);
    });
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }


}