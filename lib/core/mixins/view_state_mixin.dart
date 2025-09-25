import '../components/view_state_handler.dart';

// Base view state mixin for view models
mixin ViewStateMixin {
  ViewState _currentState = ViewState.loading;
  String? _errorMessage;

  ViewState get currentState => _currentState;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _currentState == ViewState.loading;
  bool get isSuccess => _currentState == ViewState.success;
  bool get isEmpty => _currentState == ViewState.empty;
  bool get isError => _currentState == ViewState.error;

  void setLoading() {
    _currentState = ViewState.loading;
    _errorMessage = null;
  }

  void setSuccess() {
    _currentState = ViewState.success;
    _errorMessage = null;
  }

  void setEmpty() {
    _currentState = ViewState.empty;
    _errorMessage = null;
  }

  void setError(String message) {
    _currentState = ViewState.error;
    _errorMessage = message;
  }
}