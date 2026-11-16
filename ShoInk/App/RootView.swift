import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            Text("今日").font(Font.custom("KleeOne-Regular", size: 20))
            Text("木漏れ日").font(Font.custom("ShipporiMincho-Bold", size: 100))
            Text("Today").font(Font.custom("ZenKakuGothicNew-Bold", size: 20))
        }
    }
}

#Preview {
    RootView()
}
