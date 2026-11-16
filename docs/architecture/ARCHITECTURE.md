# ShoInk — Kiến trúc

> **MVVM + Repository.** Không dùng UseCase, không tách Domain/Data.
> Mục tiêu: gọn cho app nhỏ nhưng vẫn test được và dễ thay nguồn dữ liệu.

## 1. Tổng quan

```
View (SwiftUI)
   │  gửi hành động, đọc state
   ▼
ViewModel (@Observable, @MainActor)
   │  gọi                         │  dùng thuật toán thuần
   ▼                              ▼
Repository (protocol + impl)     Logic (StrokeMatcher, SRSScheduler, DailyPicker)
   │
   ├─ APIClient (RESTful API)
   ├─ SwiftData (dữ liệu người dùng)
   └─ BundledDataStore (data đóng gói sẵn: KanjiVG, từ vựng, câu)

Core/DesignSystem ← mọi View chỉ dựng UI từ đây
```

**Hướng phụ thuộc (một chiều, không được vòng ngược):**

```
Features ──► Repositories ──► Core (Networking, Persistence)
    │              │
    ├──► Logic     └──► Models
    ├──► Models
    └──► Core (DesignSystem, Services, Utilities)
```

- `Models`, `Logic` không phụ thuộc gì ngoài Foundation.
- `Repositories` không biết đến `Features`.
- `Core` không biết đến `Features`, `Repositories`, `Logic`.

## 2. Cấu trúc thư mục

```
ShoInk/
├─ App/
│  ├─ ShoInkApp.swift          # @main: tạo AppContainer, đăng ký font, ModelContainer
│  ├─ AppContainer.swift       # tạo & giữ Repository/Service, inject qua Environment
│  ├─ RootView.swift           # chưa đăng nhập → Onboarding, đã đăng nhập → MainTabView
│  ├─ MainTabView.swift        # 5 tab + FloatingTabBar
│  ├─ Navigation/
│  │  ├─ AppTab.swift          # today, review, journal, notebook, me
│  │  ├─ Route.swift           # enum mọi màn có thể push
│  │  └─ Router.swift          # @Observable, path cho từng tab
│  └─ Config/
│     ├─ AppEnvironment.swift  # đọc base URL, feature flag từ Info.plist
│     ├─ Dev.xcconfig
│     └─ Prod.xcconfig
│
├─ Core/
│  ├─ DesignSystem/
│  │  ├─ Tokens/               # Color+Sho, Font+Sho, Spacing, Radius, Shadow
│  │  ├─ Fonts/                # .ttf (OFL) + FontRegistrar
│  │  ├─ Components/
│  │  │  ├─ Buttons/           # ShoButton, ShoIconButton
│  │  │  ├─ Chips/             # ShoChip, LevelPill
│  │  │  ├─ Cards/             # ShoCard, StatCard
│  │  │  ├─ Navigation/        # TopBar, FloatingTabBar
│  │  │  ├─ Inputs/            # ShoTextArea, ShoSegmentedControl, ShoToggle
│  │  │  ├─ Feedback/          # HankoSeal, ShoProgressBar, SessionProgress, RepetitionDots
│  │  │  └─ Writing/           # WritingPad, StrokeOrderTile, ManuscriptCell
│  │  ├─ Motifs/               # ShippoBackground, SunMotif
│  │  └─ Icons/                # ShoIcon → SF Symbols
│  ├─ Networking/
│  │  ├─ APIClient.swift       # URLSession + async/await
│  │  ├─ Endpoint.swift        # protocol: path, method, query, body, headers
│  │  ├─ HTTPMethod.swift
│  │  ├─ AuthInterceptor.swift # gắn token, refresh khi 401
│  │  └─ AppError.swift        # lỗi chung toàn app
│  ├─ Persistence/
│  │  ├─ ModelContainer+Sho.swift
│  │  └─ BundledDataStore.swift
│  ├─ Services/
│  │  ├─ SpeechService.swift   # AVSpeechSynthesizer ja-JP
│  │  ├─ AuthService.swift     # Sign in with Apple + Keychain
│  │  └─ NotificationService.swift
│  └─ Utilities/
│     ├─ Logger.swift
│     └─ Extensions/
│
├─ Models/
│  ├─ Word.swift, Kanji.swift, Stroke.swift, Phrase.swift
│  ├─ ReviewCard.swift, JournalEntry.swift, UserProfile.swift, JLPTLevel.swift
│  └─ Stored/                  # @Model của SwiftData (ReviewRecord, JournalRecord, PracticeLog…)
│
├─ Repositories/
│  ├─ WordRepository.swift     # protocol + DefaultWordRepository + endpoint của nhóm
│  ├─ PhraseRepository.swift
│  ├─ ReviewRepository.swift
│  ├─ JournalRepository.swift
│  ├─ AuthRepository.swift
│  └─ DTOs/                    # Codable theo JSON server, có toModel()
│
├─ Logic/
│  ├─ StrokeMatcher.swift      # chấm nét người dùng vs KanjiVG
│  ├─ SRSScheduler.swift       # tính lịch ôn (SM-2/FSRS)
│  └─ DailyPicker.swift        # chọn từ/câu của ngày theo seed ngày + JLPT
│
├─ Features/
│  ├─ Onboarding/   ├─ Today/   ├─ Word/      ├─ Writing/
│  ├─ Phrase/       ├─ Review/  ├─ SessionComplete/
│  ├─ Journal/      ├─ Notebook/├─ Settings/
│  │   (mỗi feature: <Name>View.swift, <Name>ViewModel.swift, Components/)
│
└─ Resources/
   ├─ Assets.xcassets
   ├─ Localization/
   │  ├─ Localizable.xcstrings # toàn bộ chuỗi UI (nguồn: en)
   │  └─ InfoPlist.xcstrings   # tên app, câu xin quyền (thông báo, micro…)
   └─ BundledData/             # kanjivg/, words.json, phrases.json (sinh bằng script)

ShoInkTests/
├─ Features/   # test ViewModel
├─ Logic/      # test StrokeMatcher, SRSScheduler, DailyPicker
├─ Repositories/
└─ Mocks/      # Mock repository + dữ liệu mẫu (dùng chung cho test và #Preview)
```

---

## 3. Vai trò & rule từng phần

Ký hiệu: ✅ được làm · ❌ không được làm.

### 3.1 `App/`
**Làm gì:** khởi động app, lắp ghép dependency, điều hướng cấp cao.

- ✅ `AppContainer` là **nơi duy nhất** khởi tạo Repository, Service, APIClient.
- ✅ Inject dependency qua `@Environment` (custom `EnvironmentKey`) hoặc truyền qua init của ViewModel.
- ✅ `Router` giữ `NavigationPath`/`[Route]` riêng cho từng tab; `Route` là `Hashable` enum có associated value là **id**, không truyền cả object lớn.
- ❌ Không viết logic nghiệp vụ hay gọi API trong `App/`.
- ❌ Không tạo Repository ở chỗ khác (`DefaultXRepository()` chỉ xuất hiện trong `AppContainer` và test).

### 3.2 `Core/DesignSystem/`
**Làm gì:** toàn bộ ngôn ngữ thiết kế, khớp 1–1 với Figma và `docs/DESIGN_SYSTEM.md`.

- ✅ Tên token và component **trùng tên Figma** (`Color.sho.bgApp`, `Font.sho.kanjiHero`, `Spacing.xl`, `Radius.lg`, `.shoShadow(.raised)`, `ShoButton(style: .primary, size: .large)`).
- ✅ Component nhận dữ liệu bằng tham số đơn giản (`String`, `Bool`, closure). Có `#Preview` cho mọi biến thể.
- ✅ Hỗ trợ Dynamic Type cho chữ UI; ô viết và chữ mẫu giữ kích thước cố định.
- ✅ Hoạ tiết/con dấu là trang trí → `.accessibilityHidden(true)`.
- ❌ Không import Model, Repository, ViewModel. Component không biết `Word`, `JournalEntry`… (nhận `String`, không nhận model).
- ❌ Không gọi API, không đọc SwiftData.
- ❌ Ngoài thư mục `Tokens/`, **không** viết mã màu hex, cỡ font, số spacing/radius trực tiếp ở bất kỳ đâu trong app.

### 3.3 `Core/Networking/`
**Làm gì:** gọi RESTful API dùng chung.

- ✅ Mọi request đi qua `APIClient.send(_ endpoint:) async throws -> T`.
- ✅ JSON: `keyDecodingStrategy = .convertFromSnakeCase`, ngày ISO-8601.
- ✅ Mọi lỗi được map về `AppError` (`.network`, `.unauthorized`, `.server(code:message:)`, `.decoding`, `.unknown`).
- ✅ Token lấy từ `AuthService` (Keychain) qua `AuthInterceptor`; tự refresh khi 401 rồi thử lại 1 lần.
- ✅ Base URL lấy từ `AppEnvironment` (theo `.xcconfig`), không hard-code.
- ❌ Không chứa endpoint cụ thể của tính năng (endpoint nằm trong file Repository tương ứng).
- ❌ Không biết đến DTO cụ thể hay Model của app.
- ❌ Không dùng thư viện mạng bên ngoài (Alamofire…) khi chưa thống nhất.

### 3.4 `Core/Persistence/`
**Làm gì:** cấu hình SwiftData và đọc data đóng gói sẵn.

- ✅ `ModelContainer` tạo một lần trong `ShoInkApp`.
- ✅ `BundledDataStore` chỉ **đọc** (KanjiVG, từ vựng, câu); cache trong bộ nhớ khi cần.
- ❌ Không truy vấn SwiftData trực tiếp từ View/ViewModel — luôn qua Repository.
- ❌ Không ghi vào data đóng gói sẵn.

### 3.5 `Core/Services/`
**Làm gì:** bọc khả năng hệ thống (giọng đọc, đăng nhập, thông báo) để thay được bằng mock.

- ✅ Mỗi service có protocol (`SpeechServicing`, `AuthServicing`…) + bản mặc định.
- ✅ Token và thông tin nhạy cảm lưu **Keychain**, không lưu `UserDefaults`.
- ❌ Không chứa logic nghiệp vụ của tính năng (vd. không chấm điểm, không chọn từ).

### 3.6 `Core/Utilities/`
- ✅ Extension nhỏ, Logger (`os.Logger`), helper thuần.
- ❌ Không thành "thùng rác": code gắn với một tính năng thì đặt trong feature đó.

### 3.7 `Models/`
**Làm gì:** kiểu dữ liệu của app.

- ✅ Model chính là `struct` thuần (`Identifiable`, `Hashable`, `Sendable`, có thể `Codable`).
- ✅ Model lưu SwiftData (`@Model class`) đặt trong `Models/Stored/`, tên có hậu tố `Record` (vd. `ReviewRecord`), kèm hàm chuyển sang struct.
- ❌ Không import SwiftUI. Không chứa logic gọi mạng/lưu trữ.
- ❌ View/ViewModel không dùng trực tiếp `@Model` hay DTO — chỉ dùng struct trong `Models/`.

### 3.8 `Repositories/`
**Làm gì:** nguồn dữ liệu duy nhất cho ViewModel; quyết định lấy từ API, SwiftData hay data đóng gói.

Mỗi file có cấu trúc:
```swift
protocol JournalRepository: Sendable {
    func translate(_ text: String, level: JLPTLevel) async throws -> JournalEntry
    func entries() async throws -> [JournalEntry]
}

struct DefaultJournalRepository: JournalRepository {
    let api: APIClient
    let store: ModelContainer
    // ...
}

private enum JournalEndpoint: Endpoint {
    case translate(TranslateRequestDTO)
    // path, method, body...
}
```

- ✅ Một repository cho một nhóm dữ liệu (Word, Phrase, Review, Journal, Auth…).
- ✅ Trả về **Model** (struct), không trả DTO hay `@Model`.
- ✅ DTO nằm trong `Repositories/DTOs/`, tên hậu tố `DTO` (`TranslateResponseDTO`), có `func toModel() -> JournalEntry`.
- ✅ Endpoint của nhóm khai báo `private` trong chính file repository đó.
- ✅ Hàm là `async throws`, ném `AppError`.
- ❌ Không import SwiftUI, không giữ state UI, không điều hướng.
- ❌ Repository không gọi Repository khác. Nếu cần ghép nhiều nguồn, ViewModel gọi lần lượt; nếu việc ghép phức tạp và lặp lại → tách hàm trong `Logic/`.
- ❌ Không đặt thuật toán (chấm nét, SRS) trong Repository.

### 3.9 `Logic/`
**Làm gì:** thuật toán thuần, xác định được, test kỹ.

- ✅ `struct`/`enum` với hàm thuần: cùng input → cùng output. Ngày giờ, random… truyền vào làm tham số (vd. `DailyPicker.pick(for date:, level:, from:)`).
- ✅ Mỗi file trong `Logic/` **bắt buộc** có test trong `ShoInkTests/Logic/`.
- ❌ Không gọi API, không đọc SwiftData, không import SwiftUI.
- ❌ Không dùng `Logic/` cho việc chỉ chuyển tiếp lời gọi (đó là việc của ViewModel). Chỉ thêm file khi có thuật toán thật.

### 3.10 `Features/`
**Làm gì:** từng màn hình theo MVVM.

```
Features/Writing/
├─ WritingView.swift
├─ WritingViewModel.swift
└─ Components/          # component chỉ dùng trong Writing
```

**View**
- ✅ Chỉ dựng UI từ `Core/DesignSystem` + state của ViewModel.
- ✅ Có `#Preview` dùng mock repository từ `ShoInkTests/Mocks` (hoặc `PreviewData`).
- ✅ Chữ hiển thị là `LocalizedStringKey`/String Catalog, không ghép chuỗi thủ công.
- ❌ Không gọi Repository, APIClient, SwiftData trực tiếp.
- ❌ Không chứa logic (if/else nghiệp vụ, tính toán). Chỉ có logic hiển thị đơn giản.

**ViewModel**
- ✅ `@Observable @MainActor final class <Name>ViewModel`.
- ✅ Nhận dependency qua `init` (protocol repository, router, service) — không tự tạo.
- ✅ State màn hình là một `enum ViewState { case idle, loading, loaded(Content), failed(AppError) }` hoặc các thuộc tính rõ ràng; không dùng nhiều `Bool` rời rạc dễ mâu thuẫn.
- ✅ Hành động người dùng là hàm động từ: `func translate() async`, `func submitStroke(_:)`, `func rate(_:)`.
- ✅ Điều hướng bằng `router.push(.wordDetail(id:))`.
- ❌ Không import SwiftUI view, không giữ `View`, không biết màu/font.
- ❌ Không dùng `@Model`/DTO; không gọi `URLSession`.
- ❌ ViewModel này không gọi ViewModel khác. Dữ liệu dùng chung → qua Repository hoặc Router.

**Components/ của feature**
- ✅ Component dùng ở **1** feature thì để trong feature đó.
- ✅ Dùng từ **2** feature trở lên → chuyển lên `Core/DesignSystem/Components` và đổi tên theo Figma.

### 3.11 `Resources/`
- ✅ Mọi chuỗi UI nằm trong `Localization/` (xem §3.13).
- ✅ `BundledData/` chỉ được sinh bằng script build data (không sửa tay); ghi nguồn + license trong màn Credits.
- ❌ Không để màu trong Asset Catalog song song với token (tránh hai nguồn sự thật) — trừ App Icon và Accent Color.

### 3.12 `ShoInkTests/`
- ✅ Test ViewModel với mock repository (kiểm tra state chuyển đúng: loading → loaded/failed).
- ✅ Test bắt buộc cho `Logic/`.
- ✅ Test decode DTO bằng JSON mẫu và `toModel()`.
- ✅ Mock dùng chung trong `Mocks/`, tên `Mock<Name>Repository`.

### 3.13 Localization (đa ngôn ngữ)
**Hiện tại:** chỉ tiếng Anh (`en` là ngôn ngữ nguồn, `developmentRegion = en`). **Sau này:** thêm ngôn ngữ (vi, es, fr, de, ko, zh-Hans…) chỉ bằng cách thêm bản dịch vào String Catalog — không sửa code.

Có **2 loại nội dung** cần tách bạch:

| Loại | Ví dụ | Nằm ở | Cách dịch |
|---|---|---|---|
| **Chuỗi UI** | "Start writing", "Review", "12 words due" | `Resources/Localization/Localizable.xcstrings` | Thêm ngôn ngữ trong String Catalog |
| **Nội dung học** | nghĩa của 木漏れ日, giải thích thành ngữ, bản dịch câu ví dụ | `Resources/BundledData/` (JSON theo mã ngôn ngữ) | Script build data sinh thêm bản dịch |

Chữ **tiếng Nhật** (kanji, kana, câu gốc) **không bao giờ** nằm trong String Catalog — đó là dữ liệu học, không phải chuỗi UI.

**Rule chuỗi UI**
- ✅ Mọi chữ hiển thị đi qua String Catalog: `Text("Start writing")`, `String(localized: "Start writing")`, hoặc symbol sinh tự động (`STRING_CATALOG_GENERATE_SYMBOLS = YES`).
- ✅ Chuỗi trong ViewModel/Model/Repository trả về `LocalizedStringResource` hoặc dùng `String(localized:)`, không trả `String` cứng.
- ✅ Số đếm dùng **plural** trong catalog ("%lld words due" → 1 word / 2 words); định dạng số, ngày, giờ bằng `FormatStyle` (`date.formatted(.dateTime.weekday().month().day())`) — không ghép chuỗi ngày tay.
- ✅ Ghép biến bằng interpolation trong một key duy nhất (`"Stroke \(current) / \(total)"`), không ghép nhiều key với nhau (thứ tự từ khác nhau giữa các ngôn ngữ).
- ✅ Thêm **comment** cho key mơ hồ (`String(localized: "Copy", comment: "Copy the phrase by hand")`).
- ✅ Tên app, câu xin quyền (thông báo, micro…) để trong `InfoPlist.xcstrings`.
- ✅ UI phải chịu được chuỗi dài hơn tiếng Anh ~30–40% (tiếng Đức, Pháp): không fix cứng width cho nút/nhãn, cho phép xuống dòng; kiểm tra bằng pseudo-language "Double-Length" trong scheme.
- ✅ Dùng `leading/trailing` thay vì `left/right` để sẵn sàng cho ngôn ngữ RTL (nếu có).
- ❌ Không hard-code chuỗi hiển thị dạng `String` thường trong View (`Text(verbatim:)` chỉ dùng cho dữ liệu, vd. chữ Nhật).
- ❌ Không dùng `NSLocalizedString` kiểu cũ hay file `.strings` rời.
- ❌ Không đưa chuỗi UI vào `Core/DesignSystem` dưới dạng cứng — component nhận `LocalizedStringKey`/`LocalizedStringResource` từ ngoài truyền vào.

**Rule nội dung học đa ngôn ngữ**
- ✅ Model chứa bản dịch theo mã ngôn ngữ, vd. `Word.meanings: [LanguageCode: [String]]`; luôn có `en` làm bản dự phòng.
- ✅ Repository chọn bản dịch theo ngôn ngữ hiện tại của app (`Locale.current.language`), fallback về `en` nếu thiếu.
- ✅ Gọi API dịch nhật ký gửi kèm ngôn ngữ của người dùng (`sourceLanguage`) để sau này người dùng viết nhật ký bằng tiếng khác ngoài tiếng Anh.
- ❌ Không lưu nghĩa đã dịch thành chuỗi đơn trong `Models/` (sẽ phải sửa model khi thêm ngôn ngữ).

**Chọn ngôn ngữ**
- App theo ngôn ngữ hệ thống; người dùng đổi riêng cho app trong *Settings › ShoInk › Language* (iOS per-app language). Màn *Me › App language* mở trang đó bằng `UIApplication.openSettingsURLString` — không tự làm bộ chuyển ngôn ngữ trong app.

**Thêm một ngôn ngữ mới (checklist)**
- [ ] Xcode › Project › Info › Localizations › thêm ngôn ngữ.
- [ ] Dịch `Localizable.xcstrings` và `InfoPlist.xcstrings` (có thể export `.xcloc` gửi người dịch).
- [ ] Chạy script build data để sinh nghĩa/giải thích nội dung học cho ngôn ngữ đó.
- [ ] Kiểm tra layout bằng ngôn ngữ đó + Double-Length pseudo-language.
- [ ] Cập nhật ảnh App Store / metadata theo ngôn ngữ.

---

## 4. Quy ước đặt tên

| Loại | Mẫu | Ví dụ |
|---|---|---|
| View màn hình | `<Feature>View` | `WritingView` |
| ViewModel | `<Feature>ViewModel` | `WritingViewModel` |
| Repository | `<Name>Repository` / `Default<Name>Repository` | `JournalRepository` |
| Mock | `Mock<Name>Repository` | `MockJournalRepository` |
| DTO | `<Name>DTO` | `TranslateResponseDTO` |
| SwiftData model | `<Name>Record` | `ReviewRecord` |
| Service | `<Name>Service` + protocol `<Name>Servicing` | `SpeechService` |
| Component DS | Tên Figma, prefix `Sho` khi trùng tên SwiftUI | `ShoButton`, `WritingPad` |
| Route | `case` thường, id làm tham số | `.wordDetail(id: Word.ID)` |

Một file — một kiểu chính. Tên file trùng tên kiểu.

## 5. Concurrency & lỗi

- Dùng **Swift Concurrency** (`async/await`, `Task`). Không dùng Combine cho luồng mới.
- ViewModel `@MainActor`. Repository/Logic là `Sendable`.
- Hủy task khi rời màn: dùng `.task { await vm.load() }` trên View thay vì tự tạo `Task` không được quản lý.
- Lỗi luôn là `AppError`; ViewModel chuyển thành thông báo thân thiện (String Catalog). Không hiển thị lỗi kỹ thuật cho người dùng.

## 6. Ví dụ luồng: dịch nhật ký

1. `JournalNewView` → nút *Translate* gọi `await viewModel.translate()`.
2. `JournalNewViewModel` đặt `state = .loading`, gọi `journalRepository.translate(text, level:)`.
3. `DefaultJournalRepository` gọi `api.send(JournalEndpoint.translate(dto))` → nhận `TranslateResponseDTO` → `toModel()` → lưu `JournalRecord` vào SwiftData → trả `JournalEntry`.
4. ViewModel đặt `state = .loaded(entry)` và gọi `router.push(.journalEntry(id: entry.id))`.
5. Lỗi → `state = .failed(error)`, View hiển thị thông báo + nút thử lại.

## 7. Checklist khi thêm tính năng

- [ ] Tạo `Features/<Name>/<Name>View.swift` + `<Name>ViewModel.swift`.
- [ ] Cần dữ liệu mới? Thêm hàm vào repository phù hợp (hoặc repository mới) + mock tương ứng.
- [ ] Gọi API mới? Thêm `case` vào endpoint `private` trong file repository + DTO có `toModel()`.
- [ ] Có thuật toán? Đặt trong `Logic/` + viết test.
- [ ] UI chỉ dùng token/component trong `Core/DesignSystem`; component mới dùng chung → đặt vào DesignSystem theo tên Figma.
- [ ] Thêm `Route` nếu là màn có thể điều hướng tới.
- [ ] Chuỗi mới vào `Resources/Localization/Localizable.xcstrings` (có comment, plural nếu là số đếm); nội dung học có bản `en` + key theo ngôn ngữ.
- [ ] `#Preview` chạy được với mock.

## 8. Còn để mở

- **Lưu trữ:** dự kiến **SwiftData** (template hiện tại là Core Data `Persistence.swift`, sẽ thay khi bắt đầu code).
- **Đồng bộ tiến độ:** CloudKit hay server REST — chưa chốt.
- **Backend dịch nhật ký:** endpoint `POST /journal/translate` (dự kiến), trả câu theo cấp JLPT + furigana + danh sách từ.
