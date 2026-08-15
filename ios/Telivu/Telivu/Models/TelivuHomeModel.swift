import Combine
import Foundation

enum TelivuVoiceState: Equatable {
    case ready
    case listening
    case processing
    case responseReady

    var panelStatus: String {
        switch self {
        case .ready, .responseReady: "READY"
        case .listening: "LISTENING"
        case .processing: "PROCESSING"
        }
    }

    var panelCaption: String {
        switch self {
        case .ready: "READY WHEN YOU ARE"
        case .listening: "I’M LISTENING · TAKE YOUR TIME"
        case .processing: "YOUR WORDS STAY VISIBLE"
        case .responseReady: "READY FOR WHAT COMES NEXT"
        }
    }

    var actionTitle: String {
        switch self {
        case .ready: "TAP TO TALK"
        case .listening: "STOP"
        case .processing: "SHOW RESPONSE"
        case .responseReady: "SPEAK AGAIN"
        }
    }

    var actionAccessibilityLabel: String {
        switch self {
        case .ready: "Tap to talk"
        case .listening: "Stop listening"
        case .processing: "Show response"
        case .responseReady: "Speak again"
        }
    }

    var statusCopy: String {
        switch self {
        case .ready: "TAP TO TALK · ENGLISH · CAPTIONS ON"
        case .listening: "LISTENING · TAP STOP WHEN YOU ARE DONE"
        case .processing: "VOICE NOTE SAVED · PREPARING A PLAIN-ENGLISH RESPONSE"
        case .responseReady: "RESPONSE READY · YOU CAN ADD MORE CONTEXT"
        }
    }

    var next: TelivuVoiceState {
        switch self {
        case .ready, .responseReady: .listening
        case .listening: .processing
        case .processing: .responseReady
        }
    }
}

enum TelivuAttachmentKind: Equatable {
    case image
    case file

    var label: String { self == .image ? "IMAGE" : "FILE" }
}

struct TelivuAttachment: Equatable {
    let kind: TelivuAttachmentKind
    let name: String
}

@MainActor
final class TelivuHomeModel: ObservableObject {
    @Published private(set) var voiceState: TelivuVoiceState = .ready
    @Published private(set) var attachment: TelivuAttachment?
    @Published private(set) var statusOverride: String?

    var statusCopy: String { statusOverride ?? voiceState.statusCopy }
    var isListening: Bool { voiceState == .listening }
    var showsResponse: Bool { voiceState == .responseReady }

    func advanceVoiceState() {
        voiceState = voiceState.next
        statusOverride = nil
    }

    func acknowledgeImage() {
        attachment = TelivuAttachment(kind: .image, name: "IMAGE SELECTED LOCALLY")
        statusOverride = "ATTACHMENT ADDED LOCALLY · TAP TO TALK WHEN READY"
    }

    func acknowledgeFile(named name: String) {
        attachment = TelivuAttachment(kind: .file, name: clippedName(name))
        statusOverride = "ATTACHMENT ADDED LOCALLY · TAP TO TALK WHEN READY"
    }

    func removeAttachment() {
        attachment = nil
        statusOverride = "ATTACHMENT REMOVED · TAP TO TALK WHEN READY"
    }

    func acknowledgeLanguage() {
        statusOverride = "ENGLISH IS THE DEMO LANGUAGE"
    }

    private func clippedName(_ name: String) -> String {
        name.count > 25 ? String(name.prefix(22)) + "…" : name
    }
}
