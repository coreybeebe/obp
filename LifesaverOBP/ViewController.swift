//
//  ViewController.swift
//  LifesaverOBP
//
//  Created by corey on 7/23/18.
//  Copyright © 2018 Lifesaver. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let username = "coreysusername"
    let password = "#Dionysus11"
    
    let username1 = "Susan.Us.44"
    let password1 = "X!28b651f8"
    
    let username2 = "Robert.Us.44"
    let password2 = "X!252b3849"
    
    let username3 = "Anil.Us.44"
    let password3 = "X!aaa38f55"
    
    let username4 = "Ellie.Us.44"
    let password4 = "X!0c896c15"
    
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.instance.retrieveAccessToken(username: username1, password: password1) { (token, error) in
            
            if let error = error { print(error) }
            guard let token = token else { return }
            self.accessToken = token
            
            NetworkService.instance.retrieveAccounts(withToken: token) { (accounts, error) in
                
                if let error = error { print(error) }
                guard let accounts = accounts else { return }
                
                for account in accounts {
                    
                    if let id = account.id {
                        
                        NetworkService.instance.retrieveTransactions(withBankID: id, accessToken: token) {
                            (transactions, error) in
                            
                            if let error = error { print(error); return }q
                            guard let transactions = transactions else { return }
                            
                            for transaction in transactions {
                                
                                print(transaction.details?.value!)
                            }
                        }
                    }
                }
            }
        }
    }
}
