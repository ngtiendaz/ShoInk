import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        let red = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8) & 0xFF) / 255
        let blue = Double(hex & 0xFF) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Primitives (chỉ dùng trong file này)
private enum ShoPalette {
    static let washi = Color(hex: 0xF5F1E8)
    static let paper = Color(hex: 0xFFFDF8)
    static let paperWarm = Color(hex: 0xF8F4EC)
    static let sumi = Color(hex: 0x1C1C1C)
    static let inkSoft = Color(hex: 0x4F4A43)
    static let stone = Color(hex: 0x6B665E)
    static let muted = Color(hex: 0x8C8579)
    static let ai = Color(hex: 0x1E2B45)
    static let aiTint = Color(hex: 0xE7EAF1)
    static let mist = Color(hex: 0xC9CCD6)
    static let shu = Color(hex: 0xB23A30)
    static let shuDeep = Color(hex: 0x8E2C24)
    static let shuLight = Color(hex: 0xD9604E)
    static let shuTint = Color(hex: 0xF3E3DF)
    static let sunTint = Color(hex: 0xEFD9D3)
    static let kin = Color(hex: 0xB08D57)
    static let line = Color(hex: 0xE8E1D3)
    static let lineStrong = Color(hex: 0xDDD5C6)
    static let divider = Color(hex: 0xEDE7DB)
    static let track = Color(hex: 0xEFE9DD)
}

// MARK: - Semantic (dùng trong toàn app)

struct ShoColors {
    // Background
    let bgApp = ShoPalette.washi
    let bgSurface = ShoPalette.paper
    let bgSurfaceWarm = ShoPalette.paperWarm
    let bgBrand = ShoPalette.ai
    let bgAccent = ShoPalette.shu
    let bgInverse = ShoPalette.sumi
    let bgTrack = ShoPalette.track
    let bgBrandTint = ShoPalette.aiTint
    let bgAccentTint = ShoPalette.shuTint
    let bgSunTint = ShoPalette.sunTint
    let bgInactive = ShoPalette.lineStrong

    // Text
    let textPrimary = ShoPalette.sumi
    let textSecondary = ShoPalette.stone
    let textMuted = ShoPalette.muted
    let textSoft = ShoPalette.inkSoft
    let textOnBrand = ShoPalette.washi
    let textOnBrandSecondary = ShoPalette.mist
    let textGold = ShoPalette.kin
    let textBrand = ShoPalette.ai
    let textAccent = ShoPalette.shu
    let textAccentDeep = ShoPalette.shuDeep
    let textOnAccent = ShoPalette.paper

    // Border
    let borderDefault = ShoPalette.line
    let borderSubtle = ShoPalette.lineStrong
    let borderDivider = ShoPalette.divider
    let borderStrong = ShoPalette.sumi
    let borderBrand = ShoPalette.ai
    let borderGold = ShoPalette.kin
    let borderAccent = ShoPalette.shu
    let borderOnBrand = ShoPalette.washi

    // Icon
    let iconPrimary = ShoPalette.sumi
    let iconSecondary = ShoPalette.stone
    let iconOnBrand = ShoPalette.washi
    let iconAccent = ShoPalette.shu

    // Motif (độ mờ của hoạ tiết đặt ở chỗ dùng, vd. .opacity(0.07))
    let motifSun = ShoPalette.shu
    let motifSunOnBrand = ShoPalette.shuLight
    let motifPatternLight = ShoPalette.ai
    let motifPatternDark = ShoPalette.washi
}

extension Color {
    static let sho = ShoColors()
}

// MARK: - Preview

#Preview {
    let swatches: [(String, Color)] = [
        ("bgApp", .sho.bgApp), ("bgSurface", .sho.bgSurface), ("bgBrand", .sho.bgBrand),
        ("bgAccent", .sho.bgAccent), ("textPrimary", .sho.textPrimary), ("textSecondary", .sho.textSecondary),
        ("textGold", .sho.textGold), ("borderDefault", .sho.borderDefault), ("bgSunTint", .sho.bgSunTint),
    ]
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
        ForEach(swatches, id: \.0) { name, color in
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(height: 56)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.sho.borderDefault))
                Text(name).font(.caption)
            }
        }
    }
    .padding()
}
