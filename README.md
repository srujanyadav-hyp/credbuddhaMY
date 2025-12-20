//----------my way of developing CredBuddha App-----------------------//

complete floder structure


 lib/
├── main.dart                     # Entry Point
├── app.dart                      # Root Widget (MultiProvider/Scope)
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart
│   │   └── assets_path.dart
│   ├── network/
│   │   ├── api_client.dart       # Dio Setup
│   │   └── network_info.dart     # Internet Connectivity Check
│   ├── router/
│   │   └── router.dart           # Navigation Logic
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/
│       ├── extensions.dart
│       └── validators.dart
├── features/
│   ├── auth/                     # --- AUTH MODULE ---
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── dashboard/                # --- HOME MODULE ---
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       └── profile_screen.dart
│   └── loans/                    # --- LOAN MODULE ---
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── exceptions/
    └── widgets/
        ├── primary_button.dart
        └── custom_text_field.dart