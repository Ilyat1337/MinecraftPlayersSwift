//
//  PlayerEdit.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 3/9/21.
//

import SwiftUI

enum SheetMode{
    case video, image
}

class SheetConfig: ObservableObject{
    @Published var mode: SheetMode?
    @Published var show: Bool = false
    
    func show(mode: SheetMode){
        self.mode = mode
        self.show = true
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
    
    func onAddVideoClick() {
        sheetConfig.show(mode: .video)
    }
    
    func onAddImageClick() {
        sheetConfig.show(mode: .image)
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
                        Text("Location")
                            .font(.custom(settings.fontName, size: settings.fontSize * 0.75))
                ) {
                    TextField("Latitude", text: $viewModel.latitude)
                    TextField("Longitude", text: $viewModel.longitude)
                }
                
                Section(header: Text("Images")) {
                    ForEach(0..<viewModel.displayedImages.count, id: \.self){i in
                        Image(uiImage: viewModel.displayedImages[i].image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .cornerRadius(7)
                    }
                    .onDelete{ deletedImagesIndexes in viewModel.handleRemoveImage(deletedImagesIndexes: deletedImagesIndexes)}
                    
                }
                
                Section{
                    HStack {
                        Spacer()
                        Button(action: onAddImageClick) {
                            Text("Add image")
                        }
                        Spacer()
                    }
                }
                
                Section{
                    if (viewModel.isSavedVideoShouldBeDeleted) {
                        Text("Saved video will be deleted...")
                    }
                    HStack {
                        Spacer()
                        if ((viewModel.isPlayerHasSavedVideo && !viewModel.isSavedVideoShouldBeDeleted) || viewModel.newVideoLocalURL != nil) {
                            Button(action: viewModel.handleDeleteVideoButtonClick) {
                                Text("Delete video")
                            }
                        } else {
                            Button(action: onAddVideoClick) {
                                Text("Add video")
                            }
                        }
                        Spacer()
                    }
                }
                
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: viewModel.handleUpdateAuthorButtonClick) {
                            Text("Save")
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
                    Button(action: viewModel.handleUpdateAuthorButtonClick) {
                        Text("Save")
                    }
            )
        }
        .sheet(isPresented: $sheetConfig.show) {
            if (sheetConfig.mode == .image) {
                ImagePicker(cb: viewModel.addImage)
            } else if (sheetConfig.mode == .video) {
                VideoPicker(videoURL: $viewModel.newVideoLocalURL)
            } else {
                EmptyView()
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
