import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/parent/models/alert.dart';
import 'package:tora_frontend/features/parent/services/parent_service.dart';

class ParentNotificationsScreen extends HookWidget {
  final String childId;

  const ParentNotificationsScreen({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    // Usar estado local en lugar de Future para poder actualizar
    final alerts = useState<List<Alert>>([]);
    final isLoading = useState(true);
    final error = useState<String?>(null);

    // Cargar notificaciones
    Future<void> loadNotifications() async {
      isLoading.value = true;
      error.value = null;

      try {
        final notifications = await ParentService.getCachedNotifications();
        alerts.value = notifications;
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    // Cargar al inicio
    useEffect(() {
      loadNotifications();
      return null;
    }, []);

    Future<void> markAsRead(String alertId) async {
      await ParentService.markNotificationAsRead(alertId);

      // Actualizar lista local
      final index = alerts.value.indexWhere((a) => a.id == alertId);
      if (index != -1) {
        final updated = List<Alert>.from(alerts.value);
        updated[index] = updated[index].copyWith(read: true);
        alerts.value = updated;
      }
    }

    Future<void> markAllAsRead() async {
      await ParentService.markAllNotificationsAsRead();

      // Actualizar lista local
      alerts.value = alerts.value.map((a) => a.copyWith(read: true)).toList();
    }

    final unreadCount = alerts.value.where((a) => !a.read).length;

    if (isLoading.value) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error.value != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${error.value}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadNotifications,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context, unreadCount: unreadCount),
      body: RefreshIndicator(
        onRefresh: loadNotifications,
        child: Column(
          children: [
            Expanded(
              child: alerts.value.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: alerts.value.length,
                      itemBuilder: (context, index) {
                        final alert = alerts.value[index];
                        return _NotificationCard(
                          alert: alert,
                          isRead: alert.read,
                          onTap: () => markAsRead(alert.id),
                        );
                      },
                    ),
            ),
            if (unreadCount > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: markAllAsRead,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Marcar todas como leídas ($unreadCount)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, {int unreadCount = 0}) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const Text(
            'Notificaciones',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No hay notificaciones',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Alert alert;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.alert,
    required this.isRead,
    required this.onTap,
  });

  String _getIcon() {
    switch (alert.type.toLowerCase()) {
      case 'panic':
      case 'error':
        return '🚨';
      case 'warning':
      case 'emotional':
        return '😟';
      case 'success':
        return '✅';
      default:
        return '📢';
    }
  }

  Color _getIndicatorColor() {
    switch (alert.type.toLowerCase()) {
      case 'panic':
      case 'error':
        return Colors.orange;
      case 'warning':
      case 'emotional':
        return Colors.orange;
      case 'success':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Ahora';
          }
          return '${difference.inMinutes} min';
        }
        final hour = dateTime.hour;
        final minute = dateTime.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      } else if (difference.inDays == 1) {
        return 'Ayer';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.shade200,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          boxShadow: isRead
              ? []
              : [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIndicatorColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(_getIcon(), style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(alert.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // Unread indicator
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _getIndicatorColor(),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
