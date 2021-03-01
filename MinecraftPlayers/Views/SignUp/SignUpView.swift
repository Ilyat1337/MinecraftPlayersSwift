//
//  SignUpView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/23/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        viewModel.avatarImage
                            .interpolation(.none)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 150)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                
                Section(header: Text("Credentials")) {
                    TextField("Email address", text: $viewModel.email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                }
                
                Section(header: Text("Ingame")) {
                    TextField("Nickname", text: $viewModel.nickname, onEditingChanged: { isEditStart in
                        if !isEditStart {
                            viewModel.loadAvatarForNickname(nickname: viewModel.nickname)
                        }
                    })
                    Picker(selection: $viewModel.occupation, label: Text("Occupation")) {
                        ForEach(Player.OccupationType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Picker(selection: $viewModel.favouriteMob, label: Text("Favourite mob")) {
                        ForEach(Player.MobType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Favourite server")) {
                    TextField("Server address", text: $viewModel.favouriteServerAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Picker(selection: $viewModel.privilege, label: Text("Privilege")) {
                        ForEach(Player.PrivilegeType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Real world")) {
                    TextField("Name", text: $viewModel.realworldName)
                    TextField("Country", text: $viewModel.country)
                    TextField("City", text: $viewModel.city)
                    TextField("Age", text: $viewModel.age)
                }
                
                Section {
                    HStack {
                        Spacer()
                        if viewModel.isSigningUp {
                            ProgressView()
                        } else {
                            Button(action: viewModel.signUp) {
                                Text("Sign Up")
                            }
                        }
                        Spacer()
                    }
                }
            }
            .disabled(viewModel.isSigningUp)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: DependencyFactory.shared.getSignUpViewModel())
    }
}
