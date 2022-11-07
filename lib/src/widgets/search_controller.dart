import 'dart:async';

import 'package:flutter/foundation.dart';

const _debounceDuration = Duration(milliseconds: 500);

class SearchController extends ValueNotifier<String> {
  SearchController(super.value);

  Timer? _debounce;

  @override
  set value(String newValue) {
    if (_debounce != null) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () async {
      _debounce = null;
      super.value = newValue;
    });
  }
}
