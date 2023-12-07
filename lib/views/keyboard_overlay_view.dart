import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KeyboardOverlay {
  
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    final language = AppLocalizations.of(context)!;
   
    if(_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        right: 0.0,
        left: 0.0,
        child: Container(
          width: double.infinity,
          color: CupertinoColors.extraLightBackgroundGray,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: CupertinoButton(
                padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Text(language.done, style: const TextStyle(color: CupertinoColors.activeBlue,)),
                ),
              )
            )
        ));
    });

    overlayState.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}