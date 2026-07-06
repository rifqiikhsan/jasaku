import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  // ── Init ─────────────────────────────────────────────────
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: iOS),
    );

    // Minta permission di Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // ── Show ─────────────────────────────────────────────────
  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const android = AndroidNotificationDetails(
      'jasaku_channel',
      'JasaKu',
      channelDescription: 'Notifikasi JasaKu',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iOS = DarwinNotificationDetails();

    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: android, iOS: iOS),
    );
  }

  // ── Shortcut untuk auth ───────────────────────────────────
  static Future<void> showLoginSuccess(String fullName) => show(
    id: 1,
    title: 'Selamat datang kembali! 👋',
    body: 'Halo $fullName, kamu berhasil masuk ke JasaKu.',
  );

  static Future<void> showRegisterSuccess(String fullName) => show(
    id: 2,
    title: 'Registrasi berhasil! 🎉',
    body: 'Halo $fullName, akunmu sudah siap digunakan.',
  );
}
