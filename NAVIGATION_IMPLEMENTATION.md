# Karuhun POS - Implementasi Navigation dengan Bottom Navigation Bar

## Fitur yang Diimplementasikan

### 1. **Onboarding Screen**

- Halaman pengenalan aplikasi dengan 3 slide
- Menggunakan PageView untuk navigasi antar slide
- Indikator halaman yang dinamis
- Menyimpan status onboarding completed di SharedPreferences
- Navigasi otomatis ke login setelah selesai

### 2. **Main Screen dengan Bottom Navigation**

- Container utama yang menampung 3 tab: Dashboard, Produk, Riwayat
- Menggunakan PageView untuk smooth transition
- NavigationBloc untuk state management yang efisien
- MultiBlocProvider untuk menghindari rebuild yang tidak perlu

### 3. **Multi BLoC Provider Implementation**

- **NavigationBloc**: Mengatur state navigasi bottom bar
- **DashboardBloc**: Mengelola state halaman dashboard
- **ProductBloc**: Mengelola state daftar produk
- **AuthBloc**: Mengelola state autentikasi

### 4. **Router Configuration**

- Redirect logic berdasarkan status onboarding dan login
- Route protection dengan SharedPreferences
- Smooth navigation menggunakan Go Router

## Struktur File Baru

```
lib/
├── features/
│   ├── main/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   └── navigation_bloc.dart
│   │       └── screen/
│   │           └── main_screen.dart
│   ├── onboarding/
│   │   └── presentation/
│   │       └── screen/
│   │           └── onboarding-screen.dart
│   └── transaction-history/
│       └── presentation/
│           └── screen/
│               └── transaction-history-screen.dart (updated)
└── router/
    └── app_router.dart (updated)
```

## Cara Kerja Navigation

### Flow Aplikasi:

1. **First Launch**: Onboarding → Login → Main (Dashboard)
2. **Subsequent Launches**: Main (jika logged in) atau Login

### NavigationBloc:

```dart
// Events
class NavigateToTab extends NavigationEvent {
  final int index;
}

// States
class NavigationChanged extends NavigationState {
  final int index;
}
```

### Bottom Navigation Tabs:

1. **Tab 0**: Dashboard (DashboardView)
2. **Tab 1**: Produk (ProductListView)
3. **Tab 2**: Riwayat (TransactionHistoryView)

## Keunggulan Implementasi

### 1. **No Unnecessary Rebuilds**

- Setiap BLoC memiliki scope yang jelas
- MultiBlocProvider memungkinkan sharing state tanpa rebuild
- PageView mempertahankan state widget saat berpindah tab

### 2. **Clean Architecture**

- Separation of concerns yang jelas
- Dependency injection dengan GetIt + Injectable
- State management yang konsisten dengan BLoC pattern

### 3. **Performance Optimized**

- Lazy loading untuk setiap feature
- State preservation antar navigasi
- Efficient memory management

### 4. **User Experience**

- Smooth animations dengan PageView
- Visual feedback dengan indikator
- Proper loading states dan error handling

## Navigation Flow Diagram

```
App Start
    ↓
Check Onboarding Status
    ↓
[Not Completed] → Onboarding Screen → Login Screen
    ↓                                      ↓
[Completed] → Check Login Status          ↓
    ↓                                      ↓
[Not Logged In] → Login Screen ───────────┘
    ↓
[Logged In] → Main Screen (Bottom Navigation)
    ↓
┌─────────────────────────────────────────────┐
│ Tab 0: Dashboard │ Tab 1: Products │ Tab 2: History │
│ DashboardView    │ ProductListView │ TransactionView│
└─────────────────────────────────────────────┘
```

## Penggunaan

### Menjalankan Aplikasi:

```bash
# Install dependencies
flutter pub get

# Generate injection code
dart run build_runner build

# Run application
flutter run
```

### Navigasi Programmatic:

```dart
// Berpindah tab dari kode
context.read<NavigationBloc>().add(NavigateToTab(1)); // Ke tab Produk

// Logout
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('is_logged_in', false);
context.go('/login');
```

## Notes

- Aplikasi menggunakan Go Router untuk routing
- State management dengan BLoC pattern
- Dependency injection dengan Injectable
- Responsive design untuk berbagai ukuran layar
- Material Design 3 theme
