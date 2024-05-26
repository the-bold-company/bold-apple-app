import SwiftUI

public struct FireNavBar<Leading, Center, Trailing>: View where Leading: View, Center: View, Trailing: View {
    private let leading: () -> Leading
    private let center: () -> Center
    private let trailing: () -> Trailing

    public init(
        @ViewBuilder leading: @escaping () -> Leading,
        @ViewBuilder center: @escaping () -> Center,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.leading = leading
        self.center = center
        self.trailing = trailing
    }

    public init(@ViewBuilder leading: @escaping () -> Leading) where Center == EmptyView, Trailing == EmptyView {
        self.init(leading: leading, center: { EmptyView() }, trailing: { EmptyView() })
    }

    public init(@ViewBuilder center: @escaping () -> Center) where Leading == EmptyView, Trailing == EmptyView {
        self.init(leading: { EmptyView() }, center: center, trailing: { EmptyView() })
    }

    public init(@ViewBuilder trailing: @escaping () -> Trailing) where Leading == EmptyView, Center == EmptyView {
        self.init(leading: { EmptyView() }, center: { EmptyView() }, trailing: trailing)
    }

    public init(@ViewBuilder leading: @escaping () -> Leading, @ViewBuilder center: @escaping () -> Center) where Trailing == EmptyView {
        self.init(leading: leading, center: center, trailing: { EmptyView() })
    }

    public init(@ViewBuilder leading: @escaping () -> Leading, @ViewBuilder trailing: @escaping () -> Trailing) where Center == EmptyView {
        self.init(leading: leading, center: { EmptyView() }, trailing: trailing)
    }

    public init(@ViewBuilder center: @escaping () -> Center, @ViewBuilder trailing: @escaping () -> Trailing) where Leading == EmptyView {
        self.init(leading: { EmptyView() }, center: center, trailing: trailing)
    }

    public var body: some View {
        HStack {
            HStack {
                leading()
                Spacer()
                Rectangle()
                    .frame(width: 0, height: 0)
            }
            .frame(idealWidth: .infinity)

            center()
                .layoutPriority(1000)

            HStack {
                Rectangle()
                    .frame(width: 0, height: 0)
                Spacer()
                trailing()
            }
            .frame(idealWidth: .infinity)
        }
    }
}
