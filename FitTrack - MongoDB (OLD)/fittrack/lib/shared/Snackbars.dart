import 'package:flutter/material.dart';

// Save Snackbars
final savingSnackbar = SnackBar(
  elevation: 8.0,
  backgroundColor: Colors.orange[400],
  content: Text(
    'Saving...',
    textAlign: TextAlign.center,
  ),
  duration: Duration(minutes: 1),
);

final saveSuccessSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.green[400],
  content: GestureDetector(
    child: Text(
      'Saved',
      textAlign: TextAlign.center,
    ),
  ),
);

final saveFailSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.red[400],
  content: GestureDetector(
    child: Text(
      'Save Failed',
      textAlign: TextAlign.center,
    ),
  ),
);

// Delete Snackbars
final deletingSnackbar = SnackBar(
  elevation: 8.0,
  backgroundColor: Colors.orange[400],
  content: Text(
    'Deleting...',
    textAlign: TextAlign.center,
  ),
  duration: Duration(minutes: 1),
);

final deleteSuccessSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.green[400],
  content: GestureDetector(
    child: Text(
      'Deleted',
      textAlign: TextAlign.center,
    ),
  ),
);

final deleteFailedSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.red[400],
  content: GestureDetector(
    child: Text(
      'Deleting Failed',
      textAlign: TextAlign.center,
    ),
  ),
);

// Developer Mode Snackbars
final enablingDevModeSnackbar = SnackBar(
  elevation: 8.0,
  backgroundColor: Colors.orange[400],
  content: Text(
    'Enabling Developer Mode...',
    textAlign: TextAlign.center,
  ),
  duration: Duration(minutes: 1),
);

final enablingDevModeSuccessSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.green[400],
  content: GestureDetector(
    child: Text(
      'Developer Mode Enabled',
      textAlign: TextAlign.center,
    ),
  ),
);

final disablingDevModeSnackbar = SnackBar(
  elevation: 8.0,
  backgroundColor: Colors.orange[400],
  content: Text(
    'Disabling Developer Mode...',
    textAlign: TextAlign.center,
  ),
  duration: Duration(minutes: 1),
);

final disablingDevModeSuccessSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.red[400],
  content: GestureDetector(
    child: Text(
      'Developer Mode Disabled',
      textAlign: TextAlign.center,
    ),
  ),
);

// Duplicating Snackbar
final duplicatingSnackbar = SnackBar(
  elevation: 8.0,
  backgroundColor: Colors.orange[400],
  content: Text(
    'Duplicating...',
    textAlign: TextAlign.center,
  ),
  duration: Duration(minutes: 1),
);

final duplicateSuccessSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.green[400],
  content: GestureDetector(
    child: Text(
      'Duplicated',
      textAlign: TextAlign.center,
    ),
  ),
);

final duplicateFailSnackbar = SnackBar(
  duration: Duration(seconds: 1),
  elevation: 8.0,
  backgroundColor: Colors.red[400],
  content: GestureDetector(
    child: Text(
      'Duplication Failed',
      textAlign: TextAlign.center,
    ),
  ),
);
