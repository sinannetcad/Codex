# Tinder Clone (Backend + Flutter)

Bu repo, Tinder benzeri bir deneyim için .NET 8 Web API ve Flutter mobil istemcisini birlikte sunar.

## Backend (C# .NET 8)

```bash
dotnet run --project backend/Api/Api.csproj
```

Varsayılan adres: `http://localhost:5000`

### Örnek uç noktalar

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/profiles?userId=...`
- `POST /api/swipes`
- `GET /api/matches?userId=...`

## Flutter

```bash
cd frontend/flutter_app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

> Android emülatöründe `10.0.2.2` kullanılır. iOS simülatöründe `http://localhost:5000` yeterlidir.
