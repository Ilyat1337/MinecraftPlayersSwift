//
//  SignInView.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                VStack{
                    Text("Sign In")
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                        .padding([.top,.bottom], 20)
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Email address")
                            
                            HStack{
                                TextField("Enter Your Email address", text: $viewModel.email)
                            }
                            
                            Divider()
                        }
                        .padding(.bottom, 15)
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                            
                            SecureField("Enter Your Password", text: $viewModel.password)
                            
                            Divider()
                        }
                    }
                    .padding(.horizontal, 6)
                    
                    Button(action: viewModel.signIn) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width - 120)
                            .padding()
                    }
                    .background(Color(.green))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                    
                }
                .padding()
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
                }
                
                VStack{
                    HStack(spacing: 8) {
                        Text("Don't Have An Account ?")
                            .foregroundColor(Color.gray)
                        
                        Button(action: {
                            viewModel.showSignUpView.toggle()
                        }) {
                            Text("Sign Up")
                        }
                    }
                    .padding(.top, 25)
                    
                }
                .sheet(isPresented: $viewModel.showSignUpView) {
                    //SignUp(show: self.$show)
                }
            }
        }
        .onAppear() {
            print("Sign in appear!")
        }
        .onDisappear() {
            print("Sign in disappear!")
        }       
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SignInViewModel(FirebaseAuthenticationService(), LoggedUserStore())
        SignInView()
            .environmentObject(viewModel)
    }
}