# ShoInk — project context

App iOS học **viết chữ Nhật** mỗi ngày: một từ mới, một câu (thành ngữ / câu nói hay), luyện **thứ tự nét** trên ô viết, ôn tập SRS, và **nhật ký** (viết tiếng Anh → dịch sang tiếng Nhật → chép tay). Tên: **ShoInk** = 書 *sho* (chữ viết) + *ink* (mực). Luôn viết "ShoInk", không viết "Shoink".

## Quyết định đã chốt
- Nền tảng: **iOS native, SwiftUI**. Xcode project `ShoInk.xcodeproj`, bundle `Daz.ShoInk`, deployment target iOS 26.2, template có sẵn Core Data (`Persistence.swift`).
- Người dùng: **đã biết kana**, muốn học từ vựng nhanh + cách viết, phiên ~**15 phút/ngày**: Từ mới (3') → Luyện viết (5') → Chép câu (4') → Ôn tập (3').
- Thị trường **nước ngoài** → UI **tiếng Anh** trước; dùng String Catalog để thêm tiếng Việt sau.
- Đăng nhập: **Sign in with Apple** (dùng `SignInWithAppleButton` của hệ thống), đồng bộ tiến độ qua iCloud/CloudKit.
- Câu mỗi ngày: ことわざ + câu nói hay, câu ngắn 4–12 chữ.
- Data đóng gói sẵn trong app (offline). "Từ của ngày" chọn bằng seed theo ngày + cấp JLPT, không cần server.

## Màn hình (12) — spec ở `docs/design/screens/`
0 Sign in · 1 Today · 2 Word of the day · 3 Writing practice (Trace/Guided/Free) · 4 Copy the phrase · 5 Notebook · 6 Review (SRS Again/Hard/Good/Easy) · 7 Session complete · 8 Journal · 9 New entry (English) · 10 Entry in Japanese (furigana, chọn từ để ôn, chép tay) · 11 Me & settings.
Tab bar nổi: **Today · Review · Journal · Notebook · Me**.

## Design system
Xem `docs/DESIGN_SYSTEM.md` (màu, font, spacing, radius, shadow, component, icon → SF Symbols). Figma: https://www.figma.com/design/nZaxSau7UxvLVsJNVVXI73
- Gói Figma Starter/ghế View: chỉ ~20 lượt gọi Figma MCP mỗi tháng → hạn chế gọi Figma; ưu tiên đọc `docs/DESIGN_SYSTEM.md` và file HTML trong repo.
- Màu chính: washi `#F5F1E8`, paper `#FFFDF8`, sumi `#1C1C1C`, ai `#1E2B45`, shu `#B23A30`, kin `#B08D57`, stone `#6B665E`.
- Font (OFL, phải bundle): Shippori Mincho, Klee One, Zen Kaku Gothic New.

## Nguồn dữ liệu (kiểm tra lại license trước khi phát hành)
- Nét chữ & thứ tự nét: **KanjiVG** (CC BY-SA 3.0, có cả kana) — nguồn chính; **AnimCJK** (bản Nhật, có median để chấm nét). Không dùng data nét chữ Trung (thứ tự nét khác).
- Từ vựng: **JMdict** qua `jmdict-simplified` (JSON), **KANJIDIC2**, `kanji-data` (cấp JLPT mới), Kanjium (pitch accent). Nghĩa tiếng Việt cho bản sau: dịch 1 lần + duyệt tay.
- Câu: Wiktionary (proverbs, 四字熟語), Tatoeba (CC BY 2.0 FR). Tự curate 365 câu.
- Phát âm: AVSpeechSynthesizer `ja-JP`, đọc theo **kana**; sau có thể pre-generate (VOICEVOX/Google TTS).
- Dịch nhật ký: LLM qua backend nhỏ (trả câu theo cấp JLPT + furigana + danh sách từ), dự phòng Apple Translation framework; tách từ/furigana bằng `CFStringTokenizer` hoặc MeCab.
- Data CC BY-SA cần màn "Credits & data licenses" trong app (đã có trong màn Me).

## Kiến trúc — BẮT BUỘC đọc `docs/architecture/ARCHITECTURE.md` trước khi viết code
**MVVM + Repository** (không UseCase, không tách Domain/Data). Thư mục: `App/ · Core/{DesignSystem, Networking, Persistence, Services, Utilities} · Models/ · Repositories/ · Logic/ · Features/ · Resources/`.
Rule tóm tắt:
- View chỉ dựng UI từ `Core/DesignSystem` + state của ViewModel; không gọi Repository/API/SwiftData.
- ViewModel `@Observable @MainActor`, nhận dependency qua init (protocol), không biết màu/font, không dùng DTO/`@Model`.
- Repository = protocol + `Default…` impl + endpoint `private` trong cùng file; trả struct trong `Models/`; không gọi repository khác.
- API RESTful qua `Core/Networking/APIClient` (URLSession async/await), lỗi map về `AppError`.
- Thuật toán thuần (chấm nét, SRS, chọn từ của ngày) trong `Logic/`, bắt buộc có test.
- Không hard-code màu/font/spacing ngoài `Core/DesignSystem/Tokens`; component dùng ở ≥2 feature → chuyển vào DesignSystem, đặt tên theo Figma.
- Chỉ `AppContainer` được khởi tạo repository/service thật.
- **Đa ngôn ngữ** (hiện chỉ `en`, sau thêm vi và các ngôn ngữ khác): mọi chuỗi UI qua `Resources/Localization/Localizable.xcstrings` (plural, comment, `FormatStyle` cho ngày/số); nội dung học (nghĩa, giải thích) lưu theo mã ngôn ngữ trong BundledData với fallback `en`; chữ Nhật không bao giờ vào String Catalog. Chi tiết: ARCHITECTURE.md §3.13.

## Kỹ thuật cốt lõi
- Ô viết: SwiftUI `Canvas` + `DragGesture` tự thu điểm từng nét (không dùng PencilKit). Chấm nét: resample ~32 điểm, so điểm đầu/cuối/hướng + DTW với path KanjiVG; ngưỡng theo cài đặt Gentle/Standard/Strict.
- Render nét mẫu: parse path SVG của KanjiVG → `Path`, animate `trim(from:to:)`.
- Lưu trữ: Core Data (template sẵn) hoặc SwiftData; tiến độ SRS (SM-2/FSRS).

## Tài liệu trong repo
- `docs/PLAN.md` — kế hoạch đầy đủ, lộ trình, rủi ro.
- `docs/architecture/ARCHITECTURE.md` — kiến trúc, cấu trúc thư mục, rule từng phần, quy ước đặt tên, checklist.
- `docs/DESIGN_SYSTEM.md` — token & component.
- `docs/design/screens/` — HTML từng màn (+ `canvas.json`).
- `docs/brand/logo/` — logo SVG/PNG. **Logo chính = bản nền sáng** (Paper, nét bút Ai, mặt trời Shu); bản nền Ai là `*-dark-*`. App icon: Any = sáng, Dark = tối (đã gắn vào `Assets.xcassets/AppIcon.appiconset`).

## Bước tiếp theo đề xuất
1. Theme trong code: `Color.sho`, `Font.sho`, `Spacing`, `Radius`, shadow modifiers, bundle 3 font.
2. Prototype chấm nét với vài chữ KanjiVG (phần rủi ro nhất).
3. Pipeline data (script build SQLite/JSON từ KanjiVG + jmdict-simplified + kanji-data).
4. Dựng các màn theo thứ tự: Today → Word → Writing → Phrase → Review → Journal.
