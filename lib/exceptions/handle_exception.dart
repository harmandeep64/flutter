import 'app_exceptions.dart';

class HandleException {
  void handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      ToastHelper.showError(message: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      ToastHelper.showError(message: message);
    } else if (error is ApiNotRespondingException) {
      ToastHelper.showError(message: 'Oops! It took longer to respond.');
    } else if (error is UnAuthorizedException) {
      var message = error.message;
      ToastHelper.showError(message: message);
    } else if (error is ForbiddenException) {
      var message = error.message;
      ToastHelper.showError(message: message);
    }else{
      ToastHelper.showError(message: "Something went wrong");
    }
  }
}