//
//  PlayerEdit.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/9/21.
//

import SwiftUI

fileprivate enum SheetMode {
    case video, image, location
}

fileprivate class SheetConfig: ObservableObject {
    var mode: SheetMode = .image
    @Published var show: Bool = false
    
    func show(mode: SheetMode){
        self.mode = mode
        self.show = true
    }
}

fileprivate struct CircleButton: View {
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
        }
        .frame(width: 20, height: 20)
        .background(Color.gray)
        .foregroundColor(.white)
        .clipShape(Circle())
    }
}

struct PlayerEdit: View {
    @Environment(\.presentationMode) var isShowingEdit
    @EnvironmentObject private var settings: SettingsStore
    @StateObject private var sheetConfig = SheetConfig()
    @ObservedObject var viewModel: PlayerEditViewModel

    init(viewModel: PlayerEditViewModel, player: Binding<Player>) {
        self.viewModel = viewModel
        viewModel.onViewCreated(player: player)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header:
                        Text("Ingame")
                            .font(.custom(settings.fontName, size: settings.fontSize * 0.75))
                ) {
                    TextField("Nickname", text: $viewModel.nickname, onEditingChanged: { isEditStart in
//                        if !isEditStart {
//                            viewModel.loadAvatarForNickname(nickname: viewModel.nickname)
//                        }
                    })
                    Picker(selection: $viewModel.occupation, label: Text("Occupation")) {
                        ForEach(Player.OccupationType.allCases, id: \.self) { occupation in
                            ImageWithText(occupation.rawValue, occupation.rawValue)
                        }
                    }
                    Picker(selection: $viewModel.favouriteMob, label: Text("Favourite mob")) {
                        ForEach(Player.MobType.allCases, id: \.self) { mobType in
                            ImageWithText(mobType.rawValue, mobType.rawValue)
                        }
                    }
                }
                
                Section(
                    header:
                        Text("Favourite server")
                            .font(.custom(settings.fontName, size: settings.fontSize * 0.75))
                ) {
                    TextField("Server address", text: $viewModel.favouriteServerAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Picker(selection: $viewModel.privilege, label: Text("Privilege")) {
                        ForEach(Player.PrivilegeType.allCases, id: \.self) {
                            Text(LocalizedStringKey($0.rawValue))
                        }
                    }
                }
                
                Section(
                    header:
                        Text("Real world")
                            .font(.custom(settings.fontName, size: settings.fontSize * 0.75))
                ) {
                    TextField("Name", text: $viewModel.realworldName)
                    TextField("Country", text: $viewModel.country)
                    TextField("City", text: $viewModel.city)
                    TextField("Age", text: $viewModel.age)
                }
                
                Section(
                    header:
                        HStack {
                            Text("Location")
                                .font(.custom(settings.fontName, size: settings.fontSize * 0.75))
                            Spacer()
                            HStack {
                                CircleButton(imageName: "plus", action: { sheetConfig.show(mode: .location) })
                                    .padding(.trailing, 5)                                
                                CircleButton(imageName: "minus", action: viewModel.resetLocation)
                            }
                        }
                ) {
                    TextField("Latitude", text: $viewModel.latitude)
                        .disabled(true)
                    TextField("Longitude", text: $viewModel.longitude)
                        .disabled(true)
                }
                
                Section(header: Text("Images")) {
                    ForEach(0..<viewModel.displayedImages.count, id: \.self) { i in
                        Image(uiImage: viewModel.displayedImages[i].image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .cornerRadius(7)
                    }
                    .onDelete { deletedImagesIndexes in
                        viewModel.handleRemoveImage(deletedImagesIndexes: deletedImagesIndexes)
                    }
                }
                
                Section{
                    HStack {
                        Spacer()
                        Button(action: { sheetConfig.show(mode: .image) }) {
                            Text("Add image")
                        }
                        Spacer()
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        if ((viewModel.isPlayerHasSavedVideo && !viewModel.isSavedVideoShouldBeDeleted) || viewModel.newVideoLocalURL != nil) {
                            Button(action: viewModel.handleDeleteVideoButtonClick) {
                                Text("Delete video")
                            }
                        } else {
                            Button(action: { sheetConfig.show(mode: .video) }) {
                                Text("Add video")
                            }
                        }
                        Spacer()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Edit", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: { isShowingEdit.wrappedValue.dismiss() } ) {
                        Text("Cancel")
                    },
                trailing:
                    HStack {
                        if viewModel.isPlayerUpdating {
                            ProgressView()
                        } else {
                            Button(action: viewModel.handleUpdatePlayerButtonClick) {
                                Text("Save")
                            }
                        }
                    }
            )
        }
        .sheet(isPresented: $sheetConfig.show) {
            switch sheetConfig.mode {
            case .image:
                ImagePicker(cb: viewModel.addImage)
            case .video:
                VideoPicker(videoURL: $viewModel.newVideoLocalURL)
            case .location:
                LocationPicker(coordinateRegion: $viewModel.coordinateRegion)
                    .onDisappear(perform: { viewModel.updateLocationText() })
            }
        }
    }
}



struct PlayerEdit_Previews: PreviewProvider {
    static var previews: some View {
        PlayerEdit(viewModel: DependencyFactory.shared.getPlayerEditViewModel(), player: .constant(getPlayerForPreview()))
            .environmentObject(getResetSettings())
    }
}
