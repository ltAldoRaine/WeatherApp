//
//  AlamofireWrapper.swift
//  WeatherApp
//
//  Created by Beka Gelashvili on 4/22/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import Alamofire

class AlamofireWrapper {

    static func isAPIAvailable(success: @escaping () -> Void, failure: @escaping () -> Void) {
        guard UIApplication.reachability.currentReachabilityStatus() != NotReachable else {
            failure()
            return
        }
        // MARK - We need to check if internet connection is really available, for that we make request to google
        // It will be good if openweatherapi have /status or /ping method
        let url = "https://www.google.com/"
        Alamofire.request(url, method: .get)
            .responseData { response in
                switch response.result {
                case .success:
                    success()
                case .failure(let error):
                    failure()
                    print(error)
                }
        }
    }

}
