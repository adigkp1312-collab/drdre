import SwiftUI
import UIKit

enum TelivuColor {
    static let ink = Color(red: 0, green: 0, blue: 0)
    static let graphite = Color(red: 94 / 255, green: 94 / 255, blue: 94 / 255)
    static let paper = Color(red: 247 / 255, green: 247 / 255, blue: 247 / 255)

    static let lineSubtle = graphite.opacity(0.18)
    static let lineDefault = graphite.opacity(0.32)
    static let paperQuiet = paper.opacity(0.70)
}

enum TelivuSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let small: CGFloat = 12
    static let standard: CGFloat = 16
    static let content: CGFloat = 20
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

enum TelivuFont {
    private static var editorialName: String {
        UIFont(name: "Bodoni 72", size: 17) != nil ? "Bodoni 72" : "Didot"
    }

    private static var technicalName: String {
        UIFont(name: "Monaco", size: 14) != nil ? "Monaco" : "Menlo"
    }

    static func editorial(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom(editorialName, size: size, relativeTo: style)
    }

    static func technical(_ size: CGFloat, relativeTo style: Font.TextStyle = .caption) -> Font {
        .custom(technicalName, size: size, relativeTo: style)
    }

    static let wordmark = technical(15, relativeTo: .headline)
    static let label = technical(11, relativeTo: .caption)
    static let micro = technical(10, relativeTo: .caption2)
    static let screenTitle = editorial(32, relativeTo: .title)
    static let body = editorial(17, relativeTo: .body)
    static let compactBody = editorial(15, relativeTo: .body)
}

enum TelivuLayout {
    static let horizontalInset: CGFloat = 20
    static let minimumTarget: CGFloat = 44
    static let attachmentHeight: CGFloat = 56
    static let voiceActionWidth: CGFloat = 88
    static let companionHeight: CGFloat = 215
}

struct TelivuFlatPressStyle: ButtonStyle {
    let inverse: Bool

    init(inverse: Bool = false) {
        self.inverse = inverse
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.82 : 1)
            .background(configuration.isPressed ? (inverse ? TelivuColor.paper.opacity(0.12) : TelivuColor.ink.opacity(0.06)) : Color.clear)
    }
}

extension View {
    func telivuTechnicalLabel() -> some View {
        font(TelivuFont.micro)
            .textCase(.uppercase)
            .tracking(0.45)
    }
}
