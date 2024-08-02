import CasePaths
import SwiftUI

public struct IfCaseLet<Enum, Case, Content, OrElse>: View where Enum: CasePathable, Content: View, OrElse: View {
    let `enum`: Enum
    let casePath: CaseKeyPath<Enum, Case>
    let content: (Case) -> Content
    let orElse: () -> OrElse

    public init(
        enum: Enum,
        casePath: CaseKeyPath<Enum, Case>,
        @ViewBuilder content: @escaping (Case) -> Content,
        @ViewBuilder orElse: @escaping () -> OrElse
    ) {
        self.enum = `enum`
        self.casePath = casePath
        self.content = content
        self.orElse = orElse
    }

    public var body: some View {
        if let `case` = `enum`[case: casePath] {
            content(`case`)
        } else {
            orElse()
        }
    }
}

public extension IfCaseLet where OrElse == EmptyView {
    init(
        enum: Enum,
        casePath: CaseKeyPath<Enum, Case>,
        @ViewBuilder content: @escaping (Case) -> Content
    ) where OrElse == EmptyView {
        self.enum = `enum`
        self.casePath = casePath
        self.content = content
        self.orElse = { EmptyView() }
    }
}

struct IfCaseLet2<Enum, Case1, Case2, Content1, Content2, OrElse>: View where Enum: CasePathable, Content1: View, Content2: View, OrElse: View {
    let `enum`: Enum
    let casePath1: CaseKeyPath<Enum, Case1>
    let casePath2: CaseKeyPath<Enum, Case2>
    let content1: (Case1) -> Content1
    let content2: (Case2) -> Content2
    let orElse: () -> OrElse

    init(
        enum: Enum,
        casePath1: CaseKeyPath<Enum, Case1>,
        @ViewBuilder content1: @escaping (Case1) -> Content1,
        casePath2: CaseKeyPath<Enum, Case2>,
        @ViewBuilder content2: @escaping (Case2) -> Content2,
        @ViewBuilder orElse: @escaping () -> OrElse
    ) {
        self.enum = `enum`
        self.casePath1 = casePath1
        self.content1 = content1
        self.casePath2 = casePath2
        self.content2 = content2
        self.orElse = orElse
    }

    var body: some View {
        if let case1 = `enum`[case: casePath1] {
            content1(case1)
        } else if let case2 = `enum`[case: casePath2] {
            content2(case2)
        } else {
            orElse()
        }
    }
}
