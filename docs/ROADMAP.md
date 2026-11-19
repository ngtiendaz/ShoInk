# ShoInk — Roadmap & Checklist

Dự án chia **4 phase**. Mỗi task nhỏ (≈ 1–3 giờ), làm theo vòng:
**đọc hướng dẫn → tự code → build/Preview → nhờ review ("review <mã task>") → sửa → tick `[x]`**.

| Phase | Nội dung | Trạng thái |
|---|---|---|
| **1. Frontend** | Design system, khung app, 12 màn hình với dữ liệu giả (mock) | 🔵 Đang làm |
| **2. Data & Logic** | Dữ liệu thật đóng gói trong app, nét chữ KanjiVG, chấm nét, SRS, lưu trữ SwiftData | ⚪ |
| **3. Backend & tích hợp** | Server REST, đăng nhập Apple, dịch nhật ký, đồng bộ tiến độ | ⚪ |
| **4. Hoàn thiện & phát hành** | Đa ngôn ngữ, accessibility, tối ưu, TestFlight, App Store | ⚪ |

> **👉 Task tiếp theo:** `1.B2` — `Font+Sho`

---

## Phase 1 — Frontend (dữ liệu giả)

Mục tiêu: chạy được toàn bộ 12 màn, đúng design, điều hướng đủ, dùng mock data. Chưa cần dữ liệu thật hay server.

### 1.A — Dọn nền
- [x] **1.A1** Gỡ Core Data template, đổi `ContentView` → `RootView`
- [x] **1.A2** Thêm 3 font (8 file .ttf + license) + `FontRegistrar`

### 1.B — Design tokens · `Core/DesignSystem/Tokens`
- [x] **1.B1** `Color+Sho` — `init(hex:)`, 20 primitive, 38 semantic, `Color.sho.*`
- [ ] **1.B2** `Font+Sho` — 21 kiểu chữ (`Font.sho.kanjiHero`…), Preview tự có font
- [ ] **1.B3** `Spacing` + `Radius` — hằng số theo `DESIGN_SYSTEM.md`
- [ ] **1.B4** `Shadow` — modifier `.shoShadow(.raised / .floating / .tabBar / …)`
- [ ] **1.B5** `DesignSystemGallery` — 1 màn chỉ để Preview, hiển thị toàn bộ token

### 1.C — Components cơ bản · `Core/DesignSystem/Components`
- [ ] **1.C1** `ShoIcon` — enum map tên icon → SF Symbols
- [ ] **1.C2** `ShoButton` — Primary / Accent / Secondary × Large / Medium / Small, icon trước/sau
- [ ] **1.C3** `ShoButton` On Brand — On Brand / Outline On Brand (dùng trên nền chàm)
- [ ] **1.C4** `ShoIconButton` — Surface 44 / Ghost 48 / Accent 64 / Brand 34
- [ ] **1.C5** `ShoChip` — Level / Status / Success / Prompt / Prompt Selected / Tag
- [ ] **1.C6** `ShoCard` — khung thẻ (surface, viền, bo 22, shadow tuỳ chọn)
- [ ] **1.C7** `TopBar` — nút trái · tiêu đề · nút phải
- [ ] **1.C8** `ShoSegmentedControl` — 2–5 lựa chọn, tone Light / Brand
- [ ] **1.C9** `ShoToggle` + `LevelPill`
- [ ] **1.C10** `ShoProgressBar` + `RepetitionDots` + `SessionProgress`
- [ ] **1.C11** `HankoSeal` — 3 cỡ × 3 tone, xoay −8°
- [ ] **1.C12** `ShippoBackground` (vẽ bằng `Canvas`) + `SunMotif`

### 1.D — Khung app · `App/`
- [ ] **1.D1** `AppTab` + `Route` (enum)
- [ ] **1.D2** `Router` (`@Observable`, path riêng cho từng tab)
- [ ] **1.D3** `FloatingTabBar` (component) + `MainTabView` (5 tab, mỗi tab 1 `NavigationStack`)
- [ ] **1.D4** `AppContainer` + inject qua `@Environment`
- [ ] **1.D5** `RootView` chọn Onboarding hay MainTabView (cờ giả `isSignedIn`)

### 1.E — Models + mock data · `Models/`, `Repositories/`, `ShoInkTests/Mocks`
- [ ] **1.E1** `JLPTLevel`, `Word`, `Kanji`, `Stroke` (struct)
- [ ] **1.E2** `Phrase`, `ReviewCard`, `JournalEntry`, `UserProfile`
- [ ] **1.E3** Protocol `WordRepository` + `PhraseRepository` + mock (木漏れ日, 七転び八起き…)
- [ ] **1.E4** Protocol `ReviewRepository` + `JournalRepository` + `AuthRepository` + mock
- [ ] **1.E5** `PreviewData` — dữ liệu mẫu dùng chung cho mọi `#Preview`

### 1.F — Màn hình (MVVM) · `Features/`
Mỗi màn: `View` + `ViewModel` + `#Preview` dùng mock. Spec: `docs/design/screens/*.dc.html`.
- [ ] **1.F1** Today — `BrandHeader`, `WordCard`, `PhraseCard`, `ListRow` Review
- [ ] **1.F2** Word of the day — chữ + furigana, `CharacterTile`, `StrokeOrderTile`, ví dụ
- [ ] **1.F3** Word — nút Listen dùng `SpeechService` (AVSpeechSynthesizer ja-JP)
- [ ] **1.F4** Writing — `WritingPad` vẽ tay bằng `Canvas` + `DragGesture` (chưa chấm điểm)
- [ ] **1.F5** Writing — chế độ Trace / Guided / Free, `ToolPill` (undo, xem mẫu, xoá), nút Next
- [ ] **1.F6** Copy the phrase — ô viết + cột `ManuscriptCell` 原稿用紙
- [ ] **1.F7** Review — flashcard, 4 nút `RatingButton`, thanh tiến độ
- [ ] **1.F8** Session complete — con dấu 完, `StatCard`
- [ ] **1.F9** Journal list — `JournalCard`
- [ ] **1.F10** New entry — `TextArea`, prompt chips, nút Translate (dịch giả lập)
- [ ] **1.F11** Entry in Japanese — câu + furigana (ruby), `SelectableWord`, Copy by hand
- [ ] **1.F12** Notebook — `StatCard`, lịch con dấu (`CalendarDay`), `WordRow`
- [ ] **1.F13** Me & settings — `SettingsRow`, chọn level, toggle, mở Settings ngôn ngữ
- [ ] **1.F14** Sign in — `KamonEmblem`, `LevelPill`, nút Apple (UI)

### 1.G — Hoàn thiện Phase 1
- [ ] **1.G1** Điều hướng đầy đủ giữa 12 màn (theo canvas design)
- [ ] **1.G2** Mọi chuỗi UI nằm trong `Localizable.xcstrings`
- [ ] **1.G3** Rà review cuối: không hard-code màu/font/spacing, đúng kiến trúc
- [ ] **1.G4** Test ViewModel cơ bản với mock (ít nhất Today, Review, Journal)

---

## Phase 2 — Data & Logic

- [ ] **2.1** Script build data: KanjiVG + jmdict-simplified + kanji-data → `Resources/BundledData`
- [ ] **2.2** Tuyển 365 câu (ことわざ + câu hay) kèm nghĩa `en`
- [ ] **2.3** `BundledDataStore` + repository thật đọc data đóng gói
- [ ] **2.4** `DailyPicker` (chọn từ/câu theo ngày + JLPT) + test
- [ ] **2.5** Parse path SVG KanjiVG → `Path`, animate nét mẫu
- [ ] **2.6** `StrokeMatcher` (resample + DTW) + test, gắn vào Writing
- [ ] **2.7** `SRSScheduler` (SM-2/FSRS) + test, gắn vào Review
- [ ] **2.8** SwiftData: `Models/Stored` (ReviewRecord, JournalRecord, PracticeLog)
- [ ] **2.9** Repository thật lưu tiến độ, streak, lịch con dấu
- [ ] **2.10** Thông báo nhắc học buổi sáng (`NotificationService`)

## Phase 3 — Backend & tích hợp

- [ ] **3.1** Thiết kế API (OpenAPI): auth, journal translate, progress sync
- [ ] **3.2** Dựng backend (chọn stack) + deploy môi trường Dev
- [ ] **3.3** `Core/Networking`: `APIClient`, `Endpoint`, `AppError`, `AuthInterceptor`
- [ ] **3.4** Sign in with Apple thật + lưu token Keychain (`AuthService`)
- [ ] **3.5** Dịch nhật ký thật (LLM theo cấp JLPT + furigana + danh sách từ)
- [ ] **3.6** Đồng bộ tiến độ (CloudKit hoặc server)
- [ ] **3.7** Cấu hình Dev/Prod (`.xcconfig`), xử lý offline & lỗi mạng

## Phase 4 — Hoàn thiện & phát hành

- [ ] **4.1** Thêm tiếng Việt (UI + nội dung học), kiểm tra chuỗi dài (Double-Length)
- [ ] **4.2** Accessibility: VoiceOver, Dynamic Type, tương phản
- [ ] **4.3** Cắt bớt font (subset) để giảm dung lượng app
- [ ] **4.4** Hiệu năng: ô viết mượt, tải data nhanh
- [ ] **4.5** Màn Credits & data licenses (KanjiVG, JMdict, Tatoeba, font OFL)
- [ ] **4.6** Privacy policy, App Store metadata, ảnh chụp màn hình
- [ ] **4.7** TestFlight beta → sửa lỗi → phát hành App Store
