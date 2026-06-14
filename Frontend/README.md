# JasaKu 🛠️

**JasaKu** adalah aplikasi marketplace jasa lokal berbasis mobile yang menghubungkan pengguna dengan penyedia jasa di sekitar mereka — mulai dari tukang, cleaning service, hingga jasa profesional lainnya.

---

## 📱 UI Design

> _Figma Design: [JasaKu – UI/UX Design](https://www.figma.com/design/ZPWFsK1NVMdgW8QPrkgQ7e/JasaKu?node-id=0-1&t=IWBUG7qh9EnkGNLV-1)_

---

## 🚀 Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | Flutter 3.44.0 (Dart 3.12.0) |
| State Management | Riverpod |
| Navigation | go_router |
| HTTP Client | Dio |
| Arsitektur | Feature-first + Shared Widgets |

---

## 🏗️ Struktur Folder

```
lib/
├── app/
│   ├── router.dart             # Konfigurasi go_router
│   └── theme.dart              # App theme & warna
│
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── login_provider.dart
│   │   └── widgets/
│   │       ├── login_footer.dart
│   │       ├── login_form.dart
│   │       ├── role_selector.dart
│   │       └── login_screen.dart
│   │
│   ├── home/
│   │   ├── providers/
│   │   └── widgets/
│   │       └── home_screen.dart
│   │
│   ├── search/
│   │   ├── pages/
│   │   ├── providers/
│   │   └── widgets/
│   │       └── search_screen.dart
│   │
│   ├── chat/               # (in progress)
│   ├── profile/            # (in progress)
│   └── splash/             # Splash screen
│
├── shared/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_search_bar.dart
│       ├── app_text_field.dart
│       ├── floating_bottom_nav_bar.dart
│       └── main_shell.dart     # Shell route wrapper
│
└── main.dart
```

---

## ✨ Fitur

| Fitur | Status |
|---|---|
| Login & Role Selector | ✅ Done |
| Home / Beranda | ✅ Done |
| Search Jasa | ✅ Done |
| Detail Jasa | 🚧 In Progress |
| Semua Kategori | 🚧 In Progress |
| Chat | 🚧 In Progress |
| Profile | 🚧 In Progress |

---

## 🛠️ Setup & Instalasi

### Prasyarat

- Flutter `3.44.0` (channel stable)
- Dart `3.12.0`
- Android Studio / VS Code dengan Flutter & Dart plugin

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/rifqiikhsan/jasaku.git
   cd jasaku/Frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

### Build Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik dan pengembangan pribadi.

---

> Dibuat dengan ❤️ menggunakan Flutter 3.44.0