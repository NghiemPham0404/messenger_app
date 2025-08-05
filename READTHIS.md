
# MVVM Clean Architecture
```bash
lib/
│
├── core/                  # Shared utils, themes, services, exceptions
│   ├── network/
│   ├── error/
│   └── widgets/           # Reusable generic widgets (not feature-specific)
│
├── features/
│   ├── user/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   ├── widgets/
│   │   │   └── bloc/ or viewmodel/
│   │   └── user_feature.dart
│   │
│   ├── todo/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── todo_feature.dart
│
├── main.dart
└── app.dart               # Routes, initialization, etc.

```