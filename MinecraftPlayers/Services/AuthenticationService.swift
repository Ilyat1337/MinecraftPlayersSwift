//
//  AuthenticationService.swift
//  MinecraftPlayers
//
//  Created by Ilyat on 2/26/21.
//  Copyright © 2021 Ilyat. All rights reserved.
//

import Firebase

protocol AuthenticationService {
    func signInWithEmail(email: String, password: String, completion: @escaping (String?, Error?) -> Void)
    func signUpWithEmail(email: String, password: String, completion: @escaping (String?, Error?) -> Void)
}

class FirebaseAuthenticationService: AuthenticationService {
    func signInWithEmail(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(res?.user.uid, nil)
        }
    }
    
    func signUpWithEmail(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, error) in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(res?.user.uid, nil)
        }
    }
}
