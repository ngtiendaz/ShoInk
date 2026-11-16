# ShoInk — Lộ trình frontend (code tay, có review)

Quy trình mỗi bước: **đọc hướng dẫn → tự code → build/chạy Preview → nhờ review → sửa → tick xong**.
Frontend dùng **dữ liệu giả (mock)**; SwiftData + backend làm ở giai đoạn sau.

## Giai đoạn 0 — Dọn nền
- [ ] **0.1** Gỡ Core Data template, đổi `ContentView` → `RootView` (placeholder)
- [ ] **0.2** Thêm 3 font + `FontRegistrar`, hiện thử được chữ bằng cả 3 font

## Giai đoạn 1 — Design tokens (`Core/DesignSystem/Tokens`)
- [ ] **1.1** `Color+Sho` (primitives + semantic)
- [ ] **1.2** `Font+Sho` (21 text style)
- [ ] **1.3** `Spacing`, `Radius`
- [ ] **1.4** `Shadow` (view modifier `.shoShadow(_:)`)
- [ ] **1.5** Màn `DesignSystemGallery` (chỉ để Preview) hiển thị toàn bộ token

## Giai đoạn 2 — Components cơ bản (`Core/DesignSystem/Components`)
- [ ] **2.1** `ShoButton` (Primary/Accent/Secondary/OnBrand/OutlineOnBrand × L/M/S)
- [ ] **2.2** `ShoIconButton`, `ShoIcon` (map SF Symbols)
- [ ] **2.3** `ShoChip`, `LevelPill`
- [ ] **2.4** `ShoCard`, `TopBar`
- [ ] **2.5** `ShippoBackground`, `SunMotif`, `HankoSeal`
- [ ] **2.6** `ShoSegmentedControl`, `ShoToggle`, `ShoProgressBar`, `SessionProgress`

## Giai đoạn 3 — Khung app (`App/`)
- [ ] **3.1** `AppTab`, `Route`, `Router`
- [ ] **3.2** `FloatingTabBar` + `MainTabView` (5 tab, mỗi tab 1 `NavigationStack`)
- [ ] **3.3** `AppContainer` + inject qua Environment

## Giai đoạn 4 — Models + mock data
- [ ] **4.1** Models: `JLPTLevel`, `Word`, `Kanji`, `Stroke`, `Phrase`
- [ ] **4.2** Models: `ReviewCard`, `JournalEntry`, `UserProfile`
- [ ] **4.3** Protocol repository + `Mock…Repository` với dữ liệu mẫu (木漏れ日, 七転び八起き…)

## Giai đoạn 5 — Màn hình (MVVM, dữ liệu mock)
- [ ] **5.1** Today
- [ ] **5.2** Word of the day (+ đọc phát âm bằng `SpeechService`)
- [ ] **5.3** Writing practice — ô viết vẽ tay (chưa chấm điểm)
- [ ] **5.4** Copy the phrase
- [ ] **5.5** Review (flashcard + 4 nút đánh giá)
- [ ] **5.6** Session complete
- [ ] **5.7** Journal list · New entry · Entry in Japanese (dịch giả lập)
- [ ] **5.8** Notebook
- [ ] **5.9** Me & settings
- [ ] **5.10** Sign in (UI + Sign in with Apple ở mức giao diện)

## Giai đoạn 6 — Logic (có test)
- [ ] **6.1** `DailyPicker`
- [ ] **6.2** `SRSScheduler`
- [ ] **6.3** Đọc path KanjiVG cho vài chữ + animate nét mẫu
- [ ] **6.4** `StrokeMatcher` (chấm nét) gắn vào Writing

## Sau frontend
- Script build data (KanjiVG, jmdict-simplified, kanji-data) → `Resources/BundledData`
- SwiftData (`Models/Stored`, repository thật)
- Backend + `APIClient` (đăng nhập, dịch nhật ký, đồng bộ)
- Thêm ngôn ngữ (vi…)
