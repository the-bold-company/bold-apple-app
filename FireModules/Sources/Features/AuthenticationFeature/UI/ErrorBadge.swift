import CoreUI
import SwiftUI

struct ErrorBadge: View {
    let errorMessage: String?
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.init(hex: 0xEF4444))
            Text(errorMessage ?? "")
                .typography(.bodyDefault)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: 0xEF4444).opacity(0.1))
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: 0xEF4444), lineWidth: 1)
        }
        .isHidden(hidden: errorMessage == nil)
    }
}

#Preview {
    VStack(spacing: 16) {
        ErrorBadge(errorMessage: nil)
        ErrorBadge(errorMessage: "Oops! Đã xảy ra sự cố khi đăng kỳ. Hãy thử lại sau một chút.")
        ErrorBadge(errorMessage: "PreSignUp failed with error Error: Cannot find module 'pre-sign-up'\nRequire stack:\n- /var/runtime/index.mjs.")
    }
    .padding()
    .preferredColorScheme(.light)
}
