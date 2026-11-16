# ShoInk Design System

Nguồn chính: **Figma** https://www.figma.com/design/nZaxSau7UxvLVsJNVVXI73 (3 trang: Foundations · Assets · Components).
Bản HTML tham chiếu từng màn: `docs/design/screens/*.dc.html` (đọc như spec; mở bằng trình duyệt sẽ thiếu runtime `support.js`).
Canvas thiết kế gốc (claude.ai artifact): https://claude.ai/artifact/9yan59bGZ5hAvcSU6dt1kw

Phong cách: Washi (giấy) + Ai 藍 (chàm, thương hiệu) + Shu 朱 (đỏ son, nhấn) + Kin 金 (vàng đồng). Hoạ tiết **shippo 七宝** mờ trên nền, mô-típ **mặt trời đỏ** lấp ló góc, mọi nút **bo capsule**, nhiều khoảng trắng. UI tiếng Anh (thêm tiếng Việt sau qua String Catalog).

## Màu

Tên token SwiftUI gợi ý: `Color.sho.<camelCase>` (đã đặt sẵn trong code syntax iOS của biến Figma).

### Primitives
| Token | Hex | Dùng cho |
|---|---|---|
| washi | `#F5F1E8` | Nền app |
| paper | `#FFFDF8` | Thẻ, ô viết, thanh |
| paperWarm | `#F8F4EC` | Ô thứ tự nét |
| sumi | `#1C1C1C` | Chữ, nét mực, nút primary |
| inkSoft | `#4F4A43` | Segment chưa chọn |
| stone | `#6B665E` | Chữ phụ |
| muted | `#8C8579` | Disabled / chữ lớn mờ (không dùng cho chữ nhỏ — tương phản thấp) |
| ai | `#1E2B45` | Thương hiệu: header, trạng thái chọn |
| aiTint | `#E7EAF1` | Chip cấp độ, ghi chú |
| mist | `#C9CCD6` | Chữ phụ trên nền Ai |
| shu | `#B23A30` | Nhấn: con dấu, nút Next, gợi ý nét |
| shuDeep | `#8E2C24` | Chữ đỏ trên nền tint, destructive |
| shuLight | `#D9604E` | Con dấu trên nền Ai |
| shuTint | `#F3E3DF` | Chip thành công, ô icon |
| sunTint | `#EFD9D3` | Mặt trời trên nền sáng |
| kin | `#B08D57` | Nhãn vàng trên Ai, furigana trên Ai |
| line | `#E8E1D3` | Viền thẻ, đường kẻ ô |
| lineStrong | `#DDD5C6` | Viền chip, chấm chưa xong |
| divider | `#EDE7DB` | Đường chia dòng, nét mờ |
| track | `#EFE9DD` | Nền segmented control |

### Semantic (alias về primitives)
- `bg/` app=washi · surface=paper · surfaceWarm=paperWarm · brand=ai · accent=shu · inverse=sumi · track · brandTint=aiTint · accentTint=shuTint · sunTint · inactive=lineStrong
- `text/` primary=sumi · secondary=stone · muted · soft=inkSoft · onBrand=washi · onBrandSecondary=mist · gold=kin · brand=ai · accent=shu · accentDeep=shuDeep · onAccent=paper
- `border/` default=line · subtle=lineStrong · divider · strong=sumi · brand=ai · gold=kin · accent=shu · onBrand=washi
- `icon/` primary=sumi · secondary=stone · onBrand=washi · accent=shu
- `motif/` sun=shu · sunOnBrand=shuLight · patternLight=ai (7%) · patternDark=washi (7%)

## Typography
3 font Google (SIL OFL — phải đóng gói vào app): **Shippori Mincho** (tiêu đề/câu Nhật), **Klee One** (chữ mẫu viết tay), **Zen Kaku Gothic New** (UI).

| Style | Font | Size/Line | Tracking |
|---|---|---|---|
| JP/Display | Shippori Mincho ExtraBold | 42/48 | +6% |
| JP/Title | Shippori Mincho ExtraBold | 20/26 | 0 |
| JP/Phrase | Shippori Mincho Bold | 26/32 | +12% |
| JP/Sentence | Shippori Mincho Medium | 18/30 | 0 |
| Kanji/Hero | Klee One SemiBold | 62/68 | 0 |
| Kanji/Card | Klee One SemiBold | 50/58 | 0 |
| Kanji/Tile | Klee One Regular | 28/34 | 0 |
| Kanji/List | Klee One Regular | 22/28 | 0 |
| Kana/Reading | Klee One Regular | 14/20 | +30% |
| UI/Title | Zen Kaku Gothic New Bold | 28/34 | 0 |
| UI/Headline | Zen Kaku Gothic New Bold | 22/28 | 0 |
| UI/Body Large | Zen Kaku Gothic New Medium | 18/26 | 0 |
| UI/Body | Zen Kaku Gothic New Regular | 15/22 | 0 |
| UI/Body Strong | Zen Kaku Gothic New Medium | 15/22 | 0 |
| UI/Button | Zen Kaku Gothic New Medium | 16/20 | 0 |
| UI/Callout | Zen Kaku Gothic New Regular | 13/19 | 0 |
| UI/Caption | Zen Kaku Gothic New Regular | 12/16 | 0 |
| UI/Overline | Zen Kaku Gothic New Medium | 11/14 | +14%, UPPERCASE |
| UI/Label Bold | Zen Kaku Gothic New Bold | 11/14 | 0 |
| UI/Tab | Zen Kaku Gothic New Regular | 11/14 | 0 |
| UI/Furigana | Zen Kaku Gothic New Regular | 10/12 | +2% |

## Spacing · Radius · Size
- **Spacing** (`Spacing.*`): xxs 4 · xs 8 · sm 12 · md 16 · lg 18 · xl 20 · xxl 24 · xxxl 36 · top 54. Lề màn hình 20, padding thẻ 20–22, khoảng giữa các thẻ 12, nút dưới cách đáy 36.
- **Radius** (`Radius.*`): xs 8 · sm 12 · md 18 · lg 22 (thẻ mặc định) · xl 26 · pad 28 (ô viết, flashcard) · full 999 (mọi nút/chip).
- **Size**: icon 16/20/24 · touch tối thiểu 44 · nút 52/56/64 · tab bar 62.

## Elevation (drop shadow, spread 0)
| Style | Màu | Opacity | Y | Blur |
|---|---|---|---|---|
| Raised (thẻ) | ai | 7% | 10 | 28 |
| Floating (ô viết, flashcard) | ai | 9% | 14 | 34 |
| Tab bar / tool pill | ai | 8% | 8 | 24 |
| Button Primary | sumi | 18% | 10 | 24 |
| Button Accent | shu | 30% | 10 | 24 |
| Button Brand | ai | 22% | 10 | 22 |
| Segment thumb | sumi | 12% | 1 | 3 |

## Hoạ tiết & mô-típ
- **Shippo**: tile 32×32, 5 vòng tròn r=16 (4 góc + tâm), nét 0.8, màu Ai 7% trên Washi / Washi 7% trên Ai. Trong code: xuất tile @3x và lặp (`Image(...).resizable(resizingMode: .tile)`) hoặc vẽ bằng `Canvas`.
- **Mặt trời**: hình tròn Shu (trên Ai) hoặc Sun tint (trên Washi), đặt lệch ra ngoài góc header/thẻ.
- **Con dấu hanko**: viền 1.5 (lớn: 3), bo ~22%, xoay −8°, chữ Shippori Mincho ExtraBold. Trang trí — ẩn khỏi VoiceOver.

## Icon
Line icon 24, nét 1.8, đầu bo tròn (Figma: trang Assets, 19 icon). Trong code dùng **SF Symbols** weight regular tương đương: arrow.right, chevron.left/right, xmark, checkmark, plus, bookmark, speaker.wave.1, pencil, arrow.uturn.backward, play, trash, lightbulb, info.circle; tab: smallcircle.filled.circle (Today), arrow.counterclockwise (Review), pencil (Journal), book.closed (Notebook), person (Me).

## Components (Figma → SwiftUI)
- **Cơ bản**: Button (Primary/Accent/Secondary × L56/M40/S36), Button On Brand (On Brand/Outline On Brand), Icon Button (Surface 44 · Ghost 48 · Accent 64 · Brand 34), Chip (Level/Status/Success/Prompt/Prompt Selected/Tag), Segment + Segmented Control, Level Pill, Tab Item + Tab Bar (nổi, cách 2 bên 20, cách đáy 28), Toggle, Hanko Seal (Shu/On Brand/On Sun × S/M/L), Session Progress (4 bước), Progress Bar, Repetition Dots, Rating Button (Again/Hard/Good/Easy), Calendar Day.
- **Ghép sẵn**: Top Bar, Brand Header, Word Card, Phrase Card (chữ dọc), Journal Card, Info Note, Stat Card, List Row, Word Row, Settings Row, Selectable Word, Character Tile, Stroke Order Tile, Writing Pad (田字格: kẻ ô, nét mờ, mực, gợi ý nét kế), Manuscript Cell (原稿用紙), Tool Pill, Text Area, Kamon Emblem.

## Logo
"Fude & Hi 筆と日": một nét bút lông (có hất *hane*) dưới mặt trời đỏ. Không có chữ.
- **Logo chính (chốt 2026-11-16): bản nền sáng** — nền Paper `#FFFDF8`, nét bút Ai `#1E2B45`, mặt trời Shu `#B23A30`; bản bo góc có viền Line `#E8E1D3` 0.5%. File: `shoink-logo.svg`, `shoink-logo-rounded.svg`, `shoink-app-icon-1024.png` (vuông, không alpha — App Store), `shoink-logo-rounded-1024/512.png`.
- **Bản tối** (nền Ai + shippo mờ, nét Washi): `shoink-*-dark-*`. Dùng làm app icon ở Dark Mode.
- Cả hai đã gắn vào `Assets.xcassets/AppIcon.appiconset` (Any = sáng, Dark = tối). Tất cả nằm trong `docs/brand/logo/`.
- Figma component `Logo` vẫn có 3 kiểu (App Icon tối, On Light, Mono); "On Light" là logo chính.
