//
//  SignUpView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/23/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var nickname: String = ""
    @State var occupation: String = Player.OccupationType.survival.rawValue
    @State var favouriteMob: String = Player.MobType.zombie.rawValue
    
    @State var favouriteServerAddress: String = ""
    @State var privilege: String = Player.PrivilegeType.player.rawValue
    
    @State var realworldName: String = ""
    @State var country: String = ""
    @State var city: String = ""
    @State var age: String = ""
    @State var color: Color = .black
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    HStack {
                        Spacer()
                        signUpViewModel.avatarImage
                            .interpolation(.none)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 150)
                            .cornerRadius(10)
                        Spacer()
                    }
                    
                        
                }
                
                Section(header: Text("Credentials")) {
                    TextField("Email address", text: $email)
                    TextField("Password", text: $password)
                }
                
                Section(header: Text("Ingame")) {
                    TextField("Nickname", text: $nickname, onCommit: {
                        signUpViewModel.nicknameTextFieldCommit(nickname: nickname)
                    })
                    Picker(selection: $occupation, label: Text("Occupation")) {
                        ForEach(Player.OccupationType.allCases, id: \.self.rawValue) {
                            Text($0.rawValue)
                        }
                    }
                    Picker(selection: $favouriteMob, label: Text("Favourite mob")) {
                        ForEach(Player.MobType.allCases, id: \.self.rawValue) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Favourite server")) {
                    TextField("Server address", text: $favouriteServerAddress)
                    Picker(selection: $privilege, label: Text("Privilege")) {
                        ForEach(Player.PrivilegeType.allCases, id: \.self.rawValue) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Real worl")) {
                    TextField("Country", text: $country)
                    TextField("City", text: $city)
                    TextField("Age", text: $age)
                }
                

                      
                Section {
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Text("Sign Up")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .frame(width: UIScreen.main.bounds.width - 120)
//                            .padding()

                    }
                    //.background(Color(.green))
                    //.clipShape(Capsule())
                    Spacer()
                }
                }

                
                //.padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            // }
            //.listStyle(InsetGroupedListStyle())
            .listStyle(GroupedListStyle())
            //.navigationBarHidden(true)
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
