// The Swift Programming Language
// https://docs.swift.org/swift-book


// public struct RepeatPeriodPickerView: View {
//    @Binding var repeatPeriod: RepeatPeriod
//    @Binding var repeatN: Int
//
//    private static let numberData = Array(1 ..< 30).map { "\($0)" }
//    private static let periodData = RepeatPeriod.allCases.map { $0.text }
//
//    // 使用计算属性来同步 selections 和绑定的 repeatPeriod 与 repeatN
//    private var selections: Binding<[Int]> {
//        Binding(
//            get: {
//                [repeatN - 1, repeatPeriod.rawValue]
//            },
//            set: {
//                repeatN = $0[0] + 1
//                repeatPeriod = RepeatPeriod(rawValue: $0[1]) ?? .daily
//            }
//        )
//    }
//
//    public init(repeatPeriod: Binding<RepeatPeriod>, repeatN: Binding<Int>) {
//        _repeatPeriod = repeatPeriod
//        _repeatN = repeatN
//    }
//
//    public var body: some View {
//        MultiComponentPickerView(data: [RepeatPeriodPickerView.numberData, RepeatPeriodPickerView.periodData], selections: selections)
//    }
// }
