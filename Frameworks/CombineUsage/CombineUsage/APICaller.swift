//
//  APICaller.swift
//  CombineUsage
//
//  Created by Yusuf Can Bircan on 8.04.2023.
//

import Foundation
import Combine

class APICaller {
    static let shared = APICaller()
    
    func fetchCompanies() -> Future<[String], Error> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                promixe(.success(["Apple", "Facebook", "Google", "Spotify"]))
            }
        }
    }
}
