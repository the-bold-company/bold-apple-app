//
//  FloatingPanel.swift
//
//
//  Created by Hien Tran on 19/07/2024.
//

import CoreUI
import SwiftUI

struct FloatingPanel<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                content()
            }
            .frame(width: 400)
            .padding(.all, 40)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: 0xB7F2C0))
    }
}

#Preview {
    WithState(initialValue: "") { $otp in
        FloatingPanel {
            Text("Xác nhận email").typography(.titleScreen)
            Spacing(height: .size12)
            Text("Điền vào ô sau dãy số Mouka vừa gửi bạn qua email ")
                .typography(.bodyLarge)
                .foregroundColor(Color.coreui.forestGreen)
                + Text(verbatim: "dev@mouka.ai")
                .typography(.bodyLargeBold)
                + Text(". ").font(.system(size: 16))
                + Text("Thay đổi")
                .typography(.bodyLargeBold)
                .foregroundColor(Color.coreui.matureGreen)
            Spacing(height: .size40)
            MoukaOTPField(
                text: $otp,
                error: nil
            )
            Spacing(height: .size40)
            Text("Bạn không nhận được? ")
                .font(.system(size: 16))
                + Text("Gửi lại")
                .font(.system(size: 16))
                .foregroundColor(Color.coreui.matureGreen)
                .bold()
        }
    }
    .preferredColorScheme(.light)
}
