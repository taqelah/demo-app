import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

class DialogShowcaseScreen extends StatefulWidget {
  const DialogShowcaseScreen({super.key});

  @override
  State<DialogShowcaseScreen> createState() => _DialogShowcaseScreenState();
}

class _DialogShowcaseScreenState extends State<DialogShowcaseScreen> {
  String _resultText = 'Interact with a dialog to see the result here';

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert Dialog'),
        content: const Text('This is a sample alert dialog. Choose an action.'),
        actions: [
          TextButton(
            key: TestKeys.dialogAlertCancel,
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _resultText = 'Alert: Cancelled');
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            key: TestKeys.dialogAlertOk,
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _resultText = 'Alert: OK pressed');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bottom Sheet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('This is a modal bottom sheet with some content.'),
            const SizedBox(height: 16),
            ElevatedButton(
              key: TestKeys.dialogBottomSheetClose,
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _resultText = 'Bottom Sheet: Closed');
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This is a snackbar message'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => _resultText = 'Snackbar: Undo pressed');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Undo action performed!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
    setState(() => _resultText = 'Snackbar: Shown');
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => _resultText =
          'Date: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
    }
  }

  void _showTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _resultText = 'Time: ${time.format(context)}');
    }
  }

  void _showSimpleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose an option'),
        children: ['Red', 'Blue', 'Green'].map((color) {
          return SimpleDialogOption(
            key: TestKeys.dialogSimpleOption(color.toLowerCase()),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _resultText = 'Simple Dialog: $color selected');
            },
            child: Text(color),
          );
        }).toList(),
      ),
    );
  }

  void _showFullScreenDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: const Text('Full Screen Dialog'),
            leading: IconButton(
              key: TestKeys.dialogFullscreenClose,
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _resultText = 'Full Screen: Closed');
              },
            ),
          ),
          body: Center(
            key: TestKeys.dialogFullscreenContent,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fullscreen, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('This is a full-screen dialog',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialogs & Alerts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _resultText,
                key: TestKeys.dialogResultText,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildButton(
            key: TestKeys.dialogAlertTrigger,
            icon: Icons.warning_amber,
            label: 'Alert Dialog',
            onPressed: _showAlertDialog,
          ),
          _buildButton(
            key: TestKeys.dialogBottomSheetTrigger,
            icon: Icons.vertical_align_bottom,
            label: 'Bottom Sheet',
            onPressed: _showBottomSheet,
          ),
          _buildButton(
            key: TestKeys.dialogSnackbarTrigger,
            icon: Icons.info_outline,
            label: 'Snackbar',
            onPressed: _showSnackbar,
          ),
          _buildButton(
            key: TestKeys.dialogDatePickerTrigger,
            icon: Icons.calendar_today,
            label: 'Date Picker',
            onPressed: _showDatePicker,
          ),
          _buildButton(
            key: TestKeys.dialogTimePickerTrigger,
            icon: Icons.access_time,
            label: 'Time Picker',
            onPressed: _showTimePicker,
          ),
          _buildButton(
            key: TestKeys.dialogSimpleTrigger,
            icon: Icons.radio_button_checked,
            label: 'Simple Dialog (Radio Options)',
            onPressed: _showSimpleDialog,
          ),
          _buildButton(
            key: TestKeys.dialogFullscreenTrigger,
            icon: Icons.fullscreen,
            label: 'Full-Screen Dialog',
            onPressed: _showFullScreenDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required Key key,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton.icon(
        key: key,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
