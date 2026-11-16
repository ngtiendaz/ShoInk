# ShoInk — App học viết chữ Nhật mỗi ngày

> **Tên đã chốt: ShoInk** (書 *sho* = chữ viết + *ink* = mực). Luôn viết "ShoInk" hoặc "Sho Ink", không viết "Shoink". App Store: "ShoInk: Write Japanese". Đã tìm trên web ngày 2026-11-15, chưa thấy app/nhãn hiệu trùng; còn phải tự kiểm tra USPTO (nhóm 9, 41), App Store, tên miền trước khi phát hành. Đã loại: Inku, Shodo (đã có app trùng mảng), Shogun.
>
> Mục tiêu: mỗi ngày 1 từ + 1 câu, học **cách viết đúng thứ tự nét**, phong cách tối giản kiểu Nhật.

---

## 1. Tính năng (MVP)

| # | Tính năng | Mô tả |
|---|-----------|-------|
| 1 | **Từ của ngày (今日の言葉)** | Random 1 từ/ngày (theo cấp JLPT người dùng chọn). Hiện kanji, cách đọc (furigana), nghĩa, phát âm, ví dụ. |
| 2 | **Xem thứ tự nét** | Animation từng nét, có số thứ tự, có thể tua từng nét (◀ ▶). |
| 3 | **Luyện viết (なぞり書き → 自由書き)** | 3 cấp: (a) tô theo nét mờ, (b) chỉ gợi ý nét kế tiếp, (c) viết tự do. App kiểm tra **thứ tự + hướng + vị trí** từng nét, báo đúng/sai ngay. |
| 4 | **Câu của ngày (今日の一句)** | 1 thành ngữ (ことわざ / 四字熟語) hoặc câu hay. Hiện nghĩa + giải thích, người dùng **chép lại từng chữ** trên ô genkō (原稿用紙). |
| 5 | **Lịch sử & ôn tập** | Lưu từ đã học, streak, ôn lại bằng SRS đơn giản (SM-2 / FSRS). |
| 6 | **Phát âm** | Nghe từ và câu. |

| 7 | **Nhật ký (日記)** | Người dùng viết 1–3 câu **tiếng Anh** → app dịch sang tiếng Nhật (đúng cấp JLPT) kèm furigana → chọn từ để thêm vào ôn tập → **chép tay** cả câu trên ô viết. Nhật ký đã chép được đóng dấu 書. |

**Kỹ thuật cho Nhật ký:**
- Dịch: gọi LLM qua backend nhỏ (prompt ép văn phong theo cấp N5–N1, trả JSON gồm câu, furigana từng token, danh sách từ + nghĩa). Phương án dự phòng/offline: Apple **Translation framework** (iOS 18, dịch trên máy, miễn phí) + tự tách từ.
- Furigana & tách từ: `CFStringTokenizer` (có phiên âm) hoặc MeCab/Sudachi; tra nghĩa từ JMdict có sẵn trong app.
- Nét chữ: mỗi chữ trong câu lấy từ KanjiVG như các màn khác.

**Thiết kế đã chốt (2026-11-15):** canvas "ShoInk — Japanese Writing App" (+ bảng Design system và Logo; logo chọn đề xuất: 01 "Fude & Hi" — nét bút lông + mặt trời đỏ trên nền chàm, không chữ), 12 màn: Sign in, Today, Word, Writing practice, Copy phrase, Notebook, Review, Session complete, Journal, New entry, Entry in Japanese, Me. Màu chàm `#1E2B45`, đỏ son `#B23A30`, vàng đồng `#B08D57`, nền washi `#F5F1E8` có hoạ tiết shippo; mọi nút bo tròn; UI tiếng Anh trước (dùng String Catalog để thêm tiếng Việt sau). Tab bar: Today · Review · Journal · Notebook · Me.

**Figma design system (2026-11-16):** https://www.figma.com/design/nZaxSau7UxvLVsJNVVXI73 — 3 trang (giới hạn gói Starter): *Foundations* (biến màu Primitives + Color semantic, Spacing, Radius, Size — có code syntax iOS `Color.sho.*`, `Spacing.*`, `Radius.*`; 21 text style; 7 effect style), *Assets* (19 icon, nền shippo sáng/tối, tile 32px, mặt trời, logo), *Components* (Button, Button On Brand, Icon Button, Chip, Segment/Segmented Control, Level Pill, Tab Item/Tab Bar, Toggle, Hanko Seal, Session Progress, Progress Bar, Repetition Dots, Rating Button, Calendar Day, Top Bar, Brand Header, Word/Phrase/Journal Card, Info Note, Stat Card, List/Word/Settings Row, Selectable Word, Character Tile, Stroke Order Tile, Writing Pad, Manuscript Cell, Tool Pill, Text Area, Kamon Emblem). Chưa dựng 12 màn trong Figma (quota MCP ~20 lượt/tháng).

Ngoài MVP (sau): bài học kana cho người mới, widget màn hình chính, thông báo mỗi sáng, iCloud sync, chế độ bút lông (thick brush) cho cảm giác 書道.

---

## 2. Nguồn dữ liệu (phần quan trọng nhất)

### 2.1 Nét chữ / thứ tự nét

| Nguồn | Nội dung | Định dạng | License | Ghi chú |
|-------|----------|-----------|---------|---------|
| **KanjiVG** ⭐ — github.com/KanjiVG/kanjivg | ~6.700 kanji + toàn bộ **hiragana, katakana**. Mỗi nét là 1 `<path>` SVG, đã đúng thứ tự, có số nét, có phân rã bộ thủ. | SVG/XML | CC BY-SA 3.0 | Chuẩn mực, dùng bởi Jisho, WaniKani… Nguồn chính. |
| **AnimCJK** — github.com/parsimonhi/animCJK | Kanji Nhật (bản riêng `svgsJa`, `graphicsJa.txt`) có **median (đường tâm nét)** + outline | SVG + JSON | Arphic PL / LGPL (kiểm tra lại) | Median rất hợp để **chấm điểm nét viết tay**. Format tương thích Hanzi Writer. |
| **Hanzi Writer** — hanziwriter.org | Thư viện JS animation + quiz viết nét | JS | MIT | Mặc định data tiếng Trung (một số chữ khác thứ tự nét Nhật!) → phải nạp data Nhật từ AnimCJK. |
| Kanji alive — kanjialive.com | 1.235 kanji, video nét bút lông, audio | API / CSV | CC BY 4.0 | Tham khảo thêm, đẹp nhưng ít chữ. |

⚠️ **Lưu ý:** thứ tự nét Nhật ≠ Trung ở một số chữ (必, 右/左, 田 …). Không dùng data Trung (Make Me a Hanzi) cho chữ Nhật.

**Cách dùng KanjiVG để chấm nét:** lấy từng path → sample thành N điểm → so với nét người dùng vẽ (điểm đầu, điểm cuối, hướng, khoảng cách Fréchet/DTW). Ngưỡng dung sai cho người mới nới lỏng hơn.

### 2.2 Từ vựng, cách đọc, nghĩa

| Nguồn | Nội dung | License |
|-------|----------|---------|
| **JMdict** (EDRDG) ⭐ | ~200k mục từ, kana, nghĩa (Anh + một số ngôn ngữ khác), POS | CC BY-SA 4.0 (EDRDG licence) |
| **jmdict-simplified** — github.com/scriptin/jmdict-simplified | JMdict/KANJIDIC đã convert sang **JSON** sẵn | CC BY-SA 4.0 |
| **KANJIDIC2** | Thông tin từng kanji: on/kun-yomi, số nét, cấp JLPT cũ, tần suất | CC BY-SA 4.0 |
| **kanji-data** — github.com/davidluzgouveia/kanji-data | JSON gộp KANJIDIC + cấp **JLPT mới (N5–N1)** + WaniKani level | MIT (data gốc theo license EDRDG) |
| **JLPT vocab lists** (Jonathan Waller, tanos.co.uk) | Danh sách từ theo N5→N1 | CC BY |
| **Kanjium** — github.com/mifunetoshiro/kanjium | **Pitch accent**, cách đọc | CC BY-SA 4.0 |

**Nghĩa tiếng Việt:** JMdict gần như không có tiếng Việt. Phương án:
1. Dùng nghĩa tiếng Anh từ JMdict làm gốc → dịch sang tiếng Việt **1 lần** (bằng LLM) cho bộ ~2–3k từ N5–N3, rồi **review tay**. Lưu sẵn trong DB, không gọi API lúc chạy.
2. Tham khảo từ điển Mazii/JDict để đối chiếu (chỉ đối chiếu, **không scrape** — vi phạm bản quyền).

### 2.3 Thành ngữ / câu mỗi ngày

| Nguồn | Nội dung | License |
|-------|----------|---------|
| **Wiktionary** — Category: Japanese proverbs / yojijukugo | Hàng trăm ことわざ, 四字熟語 có nghĩa + cách đọc | CC BY-SA |
| **Tatoeba** — tatoeba.org/downloads | Hàng trăm nghìn câu Nhật có bản dịch (có cả tiếng Việt một phần) + audio một số câu | CC BY 2.0 FR (audio license riêng từng câu) |
| Tự biên soạn | 365 câu chọn lọc, viết giải thích tiếng Việt | Của bạn |

👉 **Khuyến nghị:** tự curate **365 câu** (lấy gốc từ Wiktionary + Tatoeba), thêm giải thích tiếng Việt. Chất lượng > số lượng — đây là "linh hồn" của app. Ưu tiên câu **ngắn (4–12 chữ)** để viết lại được trên điện thoại.

### 2.4 Âm thanh (phát âm)

| Phương án | Ưu | Nhược |
|-----------|----|-------|
| **TTS hệ điều hành** (AVSpeechSynthesizer iOS / Web Speech API `ja-JP`) ⭐ | Miễn phí, offline, không lo license | Giọng hơi máy, đôi khi đọc sai kanji đa âm → truyền **kana** thay vì kanji |
| **VOICEVOX** (TTS Nhật, miễn phí) | Giọng tự nhiên, pre-generate file mp3 | Phải ghi credit nhân vật giọng, xem điều khoản từng voice |
| Google / Azure TTS | Rất tự nhiên | Trả phí; pre-generate 1 lần thì rẻ |
| Tatoeba audio | Người thật | Ít câu, license từng câu |
| ❌ JapanesePod101, Forvo scrape | — | Không được phép dùng |

👉 MVP: TTS hệ điều hành, đọc theo **kana**. Sau: pre-generate mp3 bằng VOICEVOX/Google cho bộ từ đã chọn.

### 2.5 Font

- **Klee One** (Google Fonts, OFL) — font kiểu viết tay giáo khoa, nét rõ ràng → hợp để hiển thị chữ mẫu.
- **Noto Serif JP / Shippori Mincho** (OFL) — cho tiêu đề, cảm giác Nhật trang nhã.
- **Zen Kaku Gothic / Noto Sans JP** — cho text UI.

---

## 3. Pipeline dữ liệu (chạy 1 lần, offline)

```
KanjiVG (SVG) ─────┐
AnimCJK (median) ──┤
kanji-data (JLPT) ─┼─► script build (Node/Python) ─► app.sqlite / JSON bundle
jmdict-simplified ─┤        • lọc từ N5–N3 (~3k từ)
Kanjium (pitch) ───┤        • gắn stroke paths cho từng chữ trong từ
Wiktionary/Tatoeba ┘        • dịch nghĩa VI (LLM) → review tay
                            • xuất 365 "daily sentences"
```

Schema gợi ý:

```
characters(char PK, type[kanji|hira|kata], strokes_json, stroke_count, on, kun, jlpt)
words(id, kanji, kana, meaning_vi, meaning_en, jlpt, pitch, example_ja, example_vi)
daily_phrases(id, text, kana, meaning_vi, explanation_vi, type[kotowaza|yoji|quote])
progress(item_id, item_type, ease, interval, due_at, last_score)
practice_log(date, item_id, strokes_correct, strokes_total)
```

Data bundle trong app (vài MB, dùng offline hoàn toàn). Chọn "từ của ngày" bằng **seed theo ngày** (`hash(yyyy-mm-dd + userLevel)`) để không cần server.

---

## 4. Kiến trúc & công nghệ

**Khuyến nghị: iOS native (SwiftUI)** — viết tay trên iPhone/iPad (Apple Pencil) là trải nghiệm cốt lõi.

| Phần | Lựa chọn |
|------|----------|
| UI | SwiftUI |
| Canvas viết | Custom `Canvas` + DragGesture (tự bắt điểm) — **không dùng PencilKit** vì cần dữ liệu từng nét để chấm |
| Render nét mẫu | Parse SVG path KanjiVG → `Path`, animate `trim(from:to:)` |
| Chấm nét | Tự viết: resample 32 điểm → so start/end/direction + DTW với median |
| DB | SQLite (GRDB) hoặc SwiftData, bundle sẵn |
| TTS | AVSpeechSynthesizer `ja-JP` |
| Thông báo | UserNotifications — 7h sáng "今日の言葉" |
| Widget | WidgetKit (giai đoạn 2) |

*Phương án thay thế:* Web/PWA (React + Hanzi Writer + data AnimCJK) — nhanh nhất để prototype, chạy được mọi nơi. Có thể làm prototype web trước để test thuật toán chấm nét, rồi port.

---

## 5. Thiết kế — minimal kiểu Nhật

- **Màu:** nền giấy washi `#F7F4EE`, mực sumi `#1C1C1C`, 1 màu nhấn đỏ son (朱色) `#C8443A` cho con dấu/đúng-sai. Dark mode: nền `#16150F`, chữ `#E8E4DA`.
- **Bố cục:** rất nhiều khoảng trắng (間 — *ma*), 1 việc trên 1 màn hình, chữ mẫu thật lớn ở giữa.
- **Ô viết:** lưới 田字格 (ô vuông có đường chéo/chữ thập mờ) như vở tập viết Nhật.
- **Câu của ngày:** hiển thị **dọc (縦書き)** trên nền giấy, có con dấu hanko đỏ khi hoàn thành.
- **Chuyển động:** chậm, nhẹ, như mực thấm. Không gamification ồn ào — streak hiển thị kín đáo bằng các chấm mực.
- **Âm thanh/haptic:** haptic nhẹ khi nét đúng.

Màn hình chính (MVP — 5 màn):
1. **Hôm nay** — thẻ từ + thẻ câu
2. **Chi tiết từ** — nghĩa, đọc, nghe, animation nét
3. **Luyện viết** — canvas 田字格, 3 cấp độ
4. **Chép câu** — ô 原稿用紙, viết từng chữ
5. **Sổ tay** — lịch sử, ôn tập, cài đặt cấp độ

---

## 6. Lộ trình

| Giai đoạn | Thời gian (ước tính) | Việc |
|-----------|-----|------|
| **0. Nghiên cứu** | 3–5 ngày | Tải KanjiVG, AnimCJK, jmdict-simplified, kanji-data; kiểm tra license; xem chữ nào KanjiVG thiếu; chọn 50 từ thử |
| **1. Pipeline data** | 1 tuần | Script build SQLite; dịch nghĩa VI cho N5 (~800 từ); curate 60 câu đầu |
| **2. Prototype chấm nét** | 1–2 tuần | Canvas + thuật toán so nét, tinh chỉnh ngưỡng (khó nhất — làm sớm) |
| **3. MVP app** | 2–3 tuần | 5 màn hình, daily seed, TTS, lưu tiến độ |
| **4. Thiết kế & polish** | 1 tuần | Font, màu, animation mực, dark mode |
| **5. Beta** | 1–2 tuần | TestFlight, sửa ngưỡng chấm, thêm N4–N3, đủ 365 câu |

---

## 7. Rủi ro & câu hỏi mở

- **Chấm nét viết tay** là phần kỹ thuật khó nhất → làm prototype trước tiên.
- **License share-alike** (CC BY-SA của KanjiVG/JMdict): app vẫn thương mại được, nhưng phần **data** phát hành kèm phải giữ CC BY-SA + ghi credit trong màn "Giấy phép". Code app không bị ảnh hưởng.
- **Nghĩa tiếng Việt** cần review tay → tốn công nhất về nội dung.
- TTS đọc sai kanji đa âm → luôn đọc từ trường `kana`.

**Đã quyết định (2026-11-15):**
1. Nền tảng: **iOS native (SwiftUI)**.
2. Đối tượng: người **đã biết kana**, học từ vựng nhanh + cách viết, phiên ~**15 phút/ngày** → không cần bài học kana.
3. Câu mỗi ngày: **ことわざ + câu nói hay**.
4. Đăng nhập: **Sign in with Apple** (sync tiến độ qua CloudKit hoặc backend nhẹ).

Gợi ý phiên 15 phút: từ của ngày (3') → luyện viết 3 cấp (5') → chép câu (4') → ôn tập SRS (3').
