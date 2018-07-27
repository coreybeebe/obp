//
//  NetworkService.swift
//  LifesaverOBP
//
//  Created by corey on 7/23/18.
//  Copyright © 2018 Lifesaver. All rights reserved.
//

import Foundation


struct NetworkService {
    
    
    //  MARK: - Private Properties
    private static let _instance = NetworkService()
    
    
    //  MARK: - Public Getter
    static var instance: NetworkService { return _instance }
    

    //  MARK: - Completion Typealias
    typealias Token = (_ token: String?, _ errorMessage: String?) -> Void
    typealias Accounts = (_ accounts: [Account]?, _ errorMessage: String?) -> Void
    typealias Transactions = (_ accounts: [Transaction]?, _ errorMessage: String?) -> Void
    
    
    //  MARK: - Public API
    func retrieveAccessToken(username: String, password: String, completion: Token?) {
        
        let url = URL(string: "\(BaseEndpoint.citizens.environment)\(EndPoint.directLogin.component)")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Content-Length": "0",
            "Authorization" : directLoginAuthorization(username, password)
        ]

        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error { completion?(nil, error.localizedDescription); return }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode != 201 {
                print("The server returned status code \(response.statusCode).")
            }
            
            if let data = data {

                do {
                    
                    let decoder = JSONDecoder()
                    let accessTokenObject = try decoder.decode(AccessToken.self, from: data)

                    completion?(accessTokenObject.token, nil)
                
                } catch let error as NSError {
                    
                    print("The Network Service will exit with JSON serialization error:", error.localizedDescription)
                    
                    if response.statusCode != 404 {
                        let dataError = "Error from network data object: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)"
                        completion?(nil, dataError)
                    
                    } else {
                        let error = "404 - Bad request."
                        completion?(nil, error)
                    }
                }
            }
            
        }.resume()
    }
    
    
    func retrieveAccounts(withToken token: String, completion: Accounts?) {
    
        let url = URL(string: "\(BaseEndpoint.citizens.environment)\(EndPoint.accountsAtAllBanks.component)")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization" : authorization(accessToken: token)
        ]
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error { print(error.localizedDescription); return }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode != 201 {
                print("The server returned status code \(response.statusCode).")
            }
            
            if let data = data {
                
                print(String(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!))
                
                do {

                    let decoder = JSONDecoder()
                    let accountsDTO = try decoder.decode(AccountsDTO.self, from: data)
                    
                    let accounts = accountsDTO.accounts
                    
                   completion?(accounts, nil)

                } catch let error as NSError {

                    print("The Network Service will exit with JSON serialization error:", error.localizedDescription)

                    if response.statusCode != 404 {
                        let dataError = "Error from network data object: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)"
                        completion?(nil, dataError)

                    } else {
                        let error = "404 - Bad request."
                        completion?(nil, error)
                    }
                }
            }
            
        } .resume()
    }
    
    
    func retrieveTransactions(withBankID id: String, accessToken token: String, completion: Transactions?) {
        
        let url = URL(string: "\(BaseEndpoint.citizens.environment)\(EndPoint.transactions(id).component)")
        print(String(describing: url))
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization" : authorization(accessToken: token)
        ]
        
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error { print(error.localizedDescription); return }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode != 200, response.statusCode != 201 {
                print("The server returned status code \(response.statusCode).")
            }
            
            if let data = data {
                
                do {
                    
                    let decoder = JSONDecoder()
                    let transactionsDTO = try decoder.decode(TransactionsDTO.self, from: data)
                    
                    let transactions = transactionsDTO.transactions
                    
                    completion?(transactions, nil)
                    
                } catch let error as NSError {
                    
                    print("The Network Service will exit with JSON serialization error:", error.localizedDescription)
                    
                    if response.statusCode != 404 {
                        let dataError = "Error from network data object: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)"
                        completion?(nil, dataError)
                        
                    } else {
                        let error = "404 - Bad request."
                        completion?(nil, error)
                    }
                }
            }
            
            } .resume()
        
        
        
//        "https://citizensbank.openbankproject.com/obp/v2.1.0/my/banks/cb.44.us.cb/accounts/b73579ec-a6d0-4c68-9442-f25f65ab4700/transactions"
//        -H 'Cookie: JSESSIONID=17ndfpl0wl8eu564gy3a2i6yb'
//        -H 'Authorization: DirectLogin token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIiOiIifQ.tsQ4uvy9nrNGVUnbSuS_FxSdEObcY-LDYgvGlrgCMxg"'
//        -H 'Content-Type: application/json'
    }
    
    
    private func directLoginAuthorization(_ username: String, _ password: String) -> String {
        return "DirectLogin username=\(username), password=\(password), consumer_key=\(APIKey.susanConsumerKey.key)"
    }
    
    private func authorization(accessToken: String) -> String {
        
        return "DirectLogin token=\(accessToken)"
    }
}


