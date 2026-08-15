import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct TelivuHomeView: View {
    @StateObject private var model = TelivuHomeModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isFileImporterPresented = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TelivuTopBar(languageAction: model.acknowledgeLanguage)

                VStack(spacing: 0) {
                    TelivuSessionMetadata()
                    TelivuCompanionPanel(state: model.voiceState).padding(.top, TelivuSpacing.content)
                    TelivuEditorialIntro()

                    if let attachment = model.attachment {
                        TelivuAttachmentSummary(attachment: attachment, selectedPhoto: $selectedPhoto, remove: model.removeAttachment) {
                            isFileImporterPresented = true
                        }
                    }

                    if model.showsResponse { TelivuResponseRegion() }
                    TelivuStatusRegion(copy: model.statusCopy)
                }
                .padding(.horizontal, TelivuLayout.horizontalInset)
                .padding(.top, TelivuSpacing.large)
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) { actionRegion }
        .background(TelivuColor.paper.ignoresSafeArea())
        .foregroundStyle(TelivuColor.ink)
        .fileImporter(isPresented: $isFileImporterPresented, allowedContentTypes: [.pdf, .image], allowsMultipleSelection: false) { result in
            if case let .success(urls) = result, let file = urls.first { model.acknowledgeFile(named: file.lastPathComponent) }
        }
        .onChange(of: selectedPhoto) { _, item in
            if item != nil { model.acknowledgeImage() }
        }
    }

    private var actionRegion: some View {
        VStack(spacing: TelivuSpacing.small) {
            HStack(spacing: TelivuSpacing.xs) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) { TelivuAttachmentAction(kind: .image) }
                    .buttonStyle(TelivuFlatPressStyle()).accessibilityLabel("Add image")

                TelivuVoiceAction(state: model.voiceState, action: model.advanceVoiceState)

                Button { isFileImporterPresented = true } label: { TelivuAttachmentAction(kind: .file) }
                    .buttonStyle(TelivuFlatPressStyle()).accessibilityLabel("Add file")
            }
            TelivuSafetyNote()
        }
        .padding(.horizontal, TelivuLayout.horizontalInset)
        .padding(.top, TelivuSpacing.small)
        .padding(.bottom, TelivuSpacing.xs)
        .background(TelivuColor.paper)
        .overlay(alignment: .top) { Rectangle().fill(TelivuColor.lineSubtle).frame(height: 1) }
    }
}

#Preview("iPhone 15") { TelivuHomeView().preferredColorScheme(.light) }
#Preview("Accessibility text") { TelivuHomeView().environment(\.dynamicTypeSize, .accessibility3).preferredColorScheme(.light) }
