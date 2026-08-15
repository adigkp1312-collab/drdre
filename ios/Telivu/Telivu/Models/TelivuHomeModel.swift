import Combine
import Foundation

enum TelivuVoiceState: Equatable {
    case ready
    case listening

    var stageStatus: String {
        switch self {
        case .ready: "READY"
        case .listening: "LISTENING"
        }
    }

    var stageCaption: String {
        switch self {
        case .ready: "READY WHEN YOU ARE"
        case .listening: "I’M LISTENING · TAKE YOUR TIME"
        }
    }

    var supportCopy: String {
        switch self {
        case .ready: "Speak naturally. Add a photo or report if it helps."
        case .listening: "Speak in your own words. You can pause whenever you need."
        }
    }

    var actionTitle: String {
        switch self {
        case .ready: "TAP TO TALK"
        case .listening: "TAP TO STOP"
        }
    }

    var actionDetail: String {
        switch self {
        case .ready: "English · captions on"
        case .listening: "Listening now"
        }
    }
}

@MainActor
final class TelivuHomeModel: ObservableObject {
    @Published private(set) var voiceState: TelivuVoiceState = .ready
    @Published var notice: String?

    var isListening: Bool { voiceState == .listening }

    func toggleListening() {
        voiceState = isListening ? .ready : .listening
        notice = nil
    }

    func acknowledgeImage() {
        showNotice("IMAGE SELECTED LOCALLY")
    }

    func acknowledgeFile(named name: String) {
        let displayName = name.count > 24 ? String(name.prefix(21)) + "…" : name
        showNotice("SELECTED LOCALLY · \(displayName)")
    }

    func acknowledgeLanguage() {
        showNotice("ENGLISH IS THE DEMO LANGUAGE")
    }

    private func showNotice(_ message: String) {
        notice = message
    }
}
