import CoreText
import Foundation

enum FontRegistrar {

    static func registerAll() {
        let urls = Bundle.main.urls(
            forResourcesWithExtension: "ttf",
            subdirectory: nil
        )

        guard let urls else {
            print("Không tìm thấy font nào.")
            return
        }
        for url in urls {
            var error: Unmanaged<CFError>?
            let ok = CTFontManagerRegisterFontsForURL(
                url as CFURL,
                .process,
                &error
            )
            let cfError = error?.takeRetainedValue()
            if !ok {
                print(url.lastPathComponent)
                print(cfError.hashValue)
            }
        }

    }
}
