import SwiftUI

public struct ViewOffsetKey: PreferenceKey {
    public typealias Value = CGFloat
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

public struct ScrollViewReader<Content:View> : View {
    let content: () -> Content
    let onScrollOffsetChange: (CGFloat) -> ()
    
    public init(onScrollOffsetChange: @escaping (CGFloat) -> (), @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.onScrollOffsetChange = onScrollOffsetChange
    }

    public var body: some View {
        ScrollView {
            content()
            .background {
                GeometryReader { proxy in
                    let offset = proxy.frame(in: .named("scroll")).minY
                    Color.clear.preference(key: ViewOffsetKey.self, value: offset)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ViewOffsetKey.self) { value in
            self.onScrollOffsetChange(value)
        }
    }
}
