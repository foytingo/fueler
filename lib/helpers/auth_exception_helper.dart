import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AuthResultStatus {
  successful,
  successfulWithNoVehicle,
  emailAlreadyExists,
  invalidLoginCredentials,
  weakPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
  appleLoginError,
  googleLoginError,
}

class AuthExceptionHandler {
  static handleException(e) {
    AuthResultStatus status;
    switch (e) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "INVALID_LOGIN_CREDENTIALS":
        status = AuthResultStatus.invalidLoginCredentials;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case AuthorizationErrorCode.canceled:
      case AuthorizationErrorCode.failed:
      case AuthorizationErrorCode.notHandled:
      case AuthorizationErrorCode.notInteractive:
      case AuthorizationErrorCode.unknown:
        status = AuthResultStatus.appleLoginError;
        break;

      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode, context) {
    final language = AppLocalizations.of(context)!;
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = language.invalidEmail;
        break;
      case AuthResultStatus.invalidLoginCredentials:
        errorMessage = language.invalidLoginCredentials;
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = language.userNotFound;
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = language.emailAlreadyExists;
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = language.weakPassword;
        break;
      case AuthResultStatus.appleLoginError:
        errorMessage = language.appleLoginErrorResult;
      case AuthResultStatus.googleLoginError:
        errorMessage = language.googleLoginErrorResult;
      default:
        errorMessage = language.defaultResult;
    }

    return errorMessage;
  }
}