//
//  EventsService.swift
//  Febrewary
//
//  Created by Matthew Dias on 6/29/19.
//  Copyright © 2019 Matt Dias. All rights reserved.
//

import Foundation

struct EventsService {
    var client: ServiceClient
    
    init(client: ServiceClient = ServiceClient()) {
        self.client = client
    }
    
    func getAllEventsForCurrentUser(completionHandler: @escaping (Result<[Event], Error>) -> Void) {
        let url = URLBuilder(endpoint: .eventsForCurrentUser).buildUrl()
        
        client.get(url: url) { result in
            switch result {
            case .success(let json):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                    let events = try? decoder.decode([Event].self, from: data) else {
                        print("bad data")
                        return
                }
                completionHandler(.success(events))
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
