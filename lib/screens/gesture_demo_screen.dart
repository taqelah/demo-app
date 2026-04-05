import 'package:flutter/material.dart';
import '../constants/test_keys.dart';

class GestureDemoScreen extends StatefulWidget {
  const GestureDemoScreen({super.key});

  @override
  State<GestureDemoScreen> createState() => _GestureDemoScreenState();
}

class _GestureDemoScreenState extends State<GestureDemoScreen> {
  // Dismissible cards
  final List<_SwipeItem> _swipeItems = List.generate(
    5,
    (i) => _SwipeItem(id: i, title: 'Swipe Card ${i + 1}'),
  );

  // Reorderable list
  final List<String> _reorderItems =
      List.generate(5, (i) => 'Drag Item ${i + 1}');

  // Long press
  String _longPressResult = 'Long press the card below';

  // Double tap zoom
  final _transformController = TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    setState(() {
      if (_isZoomed) {
        _transformController.value = Matrix4.identity();
      } else {
        _transformController.value = Matrix4.identity()..scaleByDouble(2.5, 2.5, 1.0, 1.0);
      }
      _isZoomed = !_isZoomed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gesture Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Dismissible Cards
          Text('Swipe Cards',
              key: TestKeys.gestureSwipeSection,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Swipe right to favorite, left to delete'),
          const SizedBox(height: 8),
          ..._swipeItems.map((item) => Dismissible(
                key: TestKeys.gestureDismissibleCard(item.id),
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.favorite, color: Colors.white, size: 28),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.delete, color: Colors.white, size: 28),
                ),
                onDismissed: (direction) {
                  setState(() => _swipeItems.remove(item));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(direction == DismissDirection.startToEnd
                        ? '${item.title} favorited!'
                        : '${item.title} deleted!'),
                  ));
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.drag_indicator),
                    title: Text(item.title),
                  ),
                ),
              )),

          const Divider(height: 32),

          // Section 2: Reorderable List
          Text('Drag & Drop Reorder',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Long press and drag to reorder'),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ReorderableListView.builder(
              key: TestKeys.gestureReorderableList,
              itemCount: _reorderItems.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _reorderItems.removeAt(oldIndex);
                  _reorderItems.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                return Card(
                  key: TestKeys.gestureReorderableItem(index),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(_reorderItems[index]),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 32),

          // Section 3: Long Press
          Text('Long Press',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_longPressResult),
          const SizedBox(height: 8),
          GestureDetector(
            key: TestKeys.gestureLongPressCard,
            onLongPressStart: (details) {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                items: [
                  PopupMenuItem(
                    value: 'copy',
                    child: const Text('Copy'),
                    onTap: () =>
                        setState(() => _longPressResult = 'Copied!'),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: const Text('Share'),
                    onTap: () =>
                        setState(() => _longPressResult = 'Shared!'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text('Delete'),
                    onTap: () =>
                        setState(() => _longPressResult = 'Deleted!'),
                  ),
                ],
              );
            },
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Long press me for options')),
              ),
            ),
          ),

          const Divider(height: 32),

          // Section 4: Double Tap Zoom
          Text('Double Tap to Zoom',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            key: TestKeys.gestureDoubleTapImage,
            onDoubleTap: _toggleZoom,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 200,
                child: InteractiveViewer(
                  transformationController: _transformController,
                  child: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                    child: Center(
                      child: Icon(Icons.checkroom,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 32),

          // Section 5: Pinch to Zoom
          Text('Pinch to Zoom',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              child: InteractiveViewer(
                key: TestKeys.gesturePinchZoomContainer,
                minScale: 1.0,
                maxScale: 4.0,
                child: Container(
                  color: Colors.teal.withValues(alpha: 0.15),
                  child: const Center(
                    child: Icon(Icons.zoom_in, size: 80, color: Colors.teal),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SwipeItem {
  final int id;
  final String title;
  _SwipeItem({required this.id, required this.title});
}
