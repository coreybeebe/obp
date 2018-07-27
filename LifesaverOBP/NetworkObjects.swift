//
//  NetworkObjects.swift
//  LifesaverOBP
//
//  Created by corey on 7/23/18.
//  Copyright © 2018 Lifesaver. All rights reserved.
//

import Foundation


//  MARK: - ENDPOINTS
let baseEndpoint = "https://citizensbank.openbankproject.com/"


enum BaseEndpoint {
    
    case sandbox
    case citizens
    
    var environment: String {
        
        switch self {
            
        case .sandbox: return "https://apisandbox.openbankproject.com/"
        case .citizens: return "https://citizensbank.openbankproject.com/"
        }
    }
}


enum EndPoint {
    
    case directLogin
    case accountsAtAllBanks
    case transactions(String)
    
    var component: String {
        
        switch self {
            
        case .directLogin: return "my/logins/direct"
        case .accountsAtAllBanks: return "obp/v3.0.0/my/accounts"
        case .transactions(let bankID): return "obp/v2.1.0/my/banks/cb.44.us.cb/accounts/\(bankID)/transactions"
        
        }
    }
}



//  MARK: - API KEYS

enum APIKey {
    
    case coreyConsumerKey
    case coreyConsumerSecret
    case robertConsumerKey
    case susanConsumerKey
    
    var key: String {
        
        switch self {
            
        case .coreyConsumerKey: return "1tpfr3lcoyvid2vb1zzkvsj3uzpf1mfm4r3bwkk5"
        case .coreyConsumerSecret: return "w5qihjmecpf01rojxv333gcivl2xgqdxu4alicaa"
        case .robertConsumerKey: return "rguxbfjoynfmydwt3553dtwf0mcxdkeyzrmadd0q"
        case .susanConsumerKey: return "52tfl5be31bczhpewdoe2v2rjx3mpbf4z0qy1oqx"
        
        }
    }
}


enum ConsumerKey {
    
    case corey
    case robert
    case susan
    case anil
    case ellie
    
    var key: String {
        
        switch self {
            
        case .corey: return "1tpfr3lcoyvid2vb1zzkvsj3uzpf1mfm4r3bwkk5"
        case .robert: return "rguxbfjoynfmydwt3553dtwf0mcxdkeyzrmadd0q"
        case .susan: return ""
        case .anil: return ""
        case .ellie: return ""
        
        }
    }
}



//  MARK: - DATA TRANSFER MODELS

struct AccessToken: Codable {
    
    let token: String
}

struct AccountsDTO: Codable {

    let accounts: [Account]?
}

struct Account: Codable {
    
    let id: String?
    let label: String?
    let bankID: String?
    let accountType: String?
    let accountRoutings: [AccountRouting]?
    let views: [View]?
    
    private enum CodingKeys: String, CodingKey {
        
        case bankID = "bank_id"
        case accountType = "account_type"
        case accountRoutings = "account_routings"
        case id, label, views
    }
}

struct AccountRouting: Codable {
    
    let scheme: String?
    let address: String?
}

struct View: Codable {
    
    let id: String?
    let shortName: String?
    let description: String?
    let isPublic: Bool?
    
    private enum CodingKeys: String, CodingKey {
        
        case shortName = "short_name"
        case isPublic = "is_public"
        case id, description
    }
}



struct TransactionsDTO: Codable {

    let transactions: [Transaction]?
}


struct Transaction: Codable {
    
    let id: String?
    let account: TransactionAccount?
    let counterparty: TransactionCounterparty?
    let details: TransactionDetails?
}


struct TransactionAccount: Codable {
    
    let id: String?
    let holders: [TransactionHolder]?
    let number: String?
    let kind: String?
    let iban: String?
    let swiftBIC: String?
    let bank: TransactionBank?
    
    private enum CodingKeys: String, CodingKey {
        
        case swiftBIC = "swift_bic"
        case id, holders, number, kind, iban, bank
    }
}

typealias TransactionCounterparty = TransactionAccount

struct TransactionHolder: Codable {
    
    let name: String?
    let isAlias: Bool?
}

struct TransactionBank: Codable {
    
    let nationalIdentifier: String?
    let name: String?
}



struct TransactionDetails: Codable {
    
    let type: String?
    let description: String?
    let posted: String?
    let completed: String?
    let newBalance: Amount?
    let value: Amount?
    
}


struct Amount: Codable {
    
    let currency: String?
    let amount: String?
}

//{"transactions":
//    [
//        {"id":"1ba9acba-a442-418a-97c3-7f0585ab2a67",
//        "account":
//            {
//              "id":"dba2fd94-0c24-4635-a7f2-2a2b9ef91042",
//              "holders":
//                [
//                    {"name":"Susan.Us.44",
//                    "is_alias":false}
//                ],
//            "number":"14410835194",
//            "kind":"CURRENT PLUS",
//            "IBAN":"CB12 1234 5123 4514 4108 3519 477",
//            "swift_bic":null,
//            "bank":
//                {
//                    "national_identifier":null,
//                    "name":"Citizen Bank"
//                }
//
//            },
//         "counterparty":
//              {
//               "id":"KGfk1QSoEiuB0yKc4ud3dGr0Y43Lzs5bs1KWjxCMmd8",
//               "holder":
//                    {"name":"BP"},
//                "number":"dba2fd94-0c24-4635-a7f2-2a2b9ef91042",
//                "kind":null,
//                "IBAN":null,
//                "swift_bic":null,
//                "bank":
//                      {
//                          "national_identifier":null,
//                           "name":"cb.44.us.cb"
//
//                      }
//                },
//           "details":
//              {
//                "type":"10218",
//                "description":"Filling station",
//                "posted":"2017-12-30T20:12:21Z",
//                "completed":"2017-12-30T20:12:21Z",
//                 "new_balance":
//                     {
//                      "currency":"USD",
//                        "amount":"5578.07"

//                      },
//                    "value":
//                        {
//                          "currency":"USD",
//                          "amount":"-27.70"
//
//                          }
//
//    }}


