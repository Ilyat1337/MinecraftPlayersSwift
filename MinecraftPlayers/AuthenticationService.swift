//
//  AuthenticationService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Firebase

protocol AuthenticationService {
    func signInWithEmail(email: String, password : String, completion: @escaping (Error?, String?)->Void)
    func signUpWithEmail(email: String, password: String,completion: @escaping (Error?, String?)->Void)
}

class FirebaseAuthenticationService: AuthenticationService {
    func signInWithEmail(email: String, password : String, completion: @escaping (Error?, String?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                completion(err, nil)
                return
            }
            
            completion(nil, res?.user.uid)
        }
    }
    
    func signUpWithEmail(email: String, password: String,completion: @escaping (Error?, String?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                completion(err, nil)
                return
            }
            
            completion(nil, res?.user.uid)
        }
    }
}
