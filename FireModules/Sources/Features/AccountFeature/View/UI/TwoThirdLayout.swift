import SwiftUI

public struct TwoThirdLayout: Layout {
    let spacing: CGFloat

    public func sizeThatFits(proposal: ProposedViewSize, subviews _: Subviews, cache _: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    public func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        precondition(subviews.count == 2)

        let availableWidth = (bounds.size.width - spacing)

        subviews[0].place(
            at: bounds.origin,
            anchor: .topLeading,
            proposal: .init(width: availableWidth * 2 / 3, height: bounds.size.height)
        )

        subviews[1].place(
            at: CGPoint(x: bounds.maxX, y: bounds.minY),
            anchor: .topTrailing,
            proposal: .init(width: availableWidth / 3, height: bounds.size.height)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        TwoThirdLayout(spacing: 24) {
            VStack {
                Text("Hello, World!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pink)

            VStack {
                Text("Hello, World!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.indigo)
        }
        .border(.blue)
    }
    .frame(maxWidth: .infinity, maxHeight: 100)
    .background(.white)
}
