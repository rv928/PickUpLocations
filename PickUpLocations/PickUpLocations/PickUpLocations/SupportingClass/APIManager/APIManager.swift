//
//  APIManager.swift


import Foundation
import Alamofire
import SwiftyJSON

public class APIManager {
    
    var manager = Alamofire.SessionManager.default
    let printResponse: Bool = true
    var endpoint: String = ""
    var method: HTTPMethod = .get
    static var host: String = "https://api-staging.pmlo.co"
    
    static var uris: [endpointType:String] = [
        .fetchPickUpLocations:"/v3/pickup-locations/",
    ]
    
    public enum endpointType: String {
        case fetchPickUpLocations = "fetchPickUpLocations"
        
        func method() -> HTTPMethod {
            switch self {
            case .fetchPickUpLocations:
                return .get
            }
        }
    }
    
    class func initEndpoints() {
        var api: [String:String] = [:]
        if let apiInConfig = Bundle.main.object(forInfoDictionaryKey: "api") as? [String:String] {
            api = apiInConfig
        }
        for (key,val) in api {
            if key == "host" {
                host = val
            } else if let endpointKey = endpointType(rawValue: key) {
                uris[endpointKey] = val
            }
        }
    }
    
    let headersCommon: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    init(endpoint: APIManager.endpointType, timeoutIntervalForRequest: TimeInterval = 30, timeoutIntervalForResource: TimeInterval = 30) {
        self.endpoint = APIManager.uris[endpoint] ?? ""
        self.method = endpoint.method()
        self.createSessionManager(timeoutIntervalForRequest: timeoutIntervalForRequest,timeoutIntervalForResource: timeoutIntervalForResource)
    }
    
    func createSessionManager(timeoutIntervalForRequest: TimeInterval, timeoutIntervalForResource: TimeInterval) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest // seconds
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        self.manager = SessionManager(configuration: configuration)
    }
    
    public func call(parameters: [String : AnyObject]?,
                     headersAdditional: [String : String]?,
                     encoding: ParameterEncoding?,
                     fail: @escaping (_ httpStatus: Int?, _ errorCode: String?) -> (),
                     success: @escaping (_ data: JSON) -> ()) {
        self.networkOperation(method: self.method,
                              parameters: parameters,
                              headersAdditional: headersAdditional,
                              encoding: encoding,
                              fail: fail,
                              success: success)
    }
    
    private func networkOperation(method useMethod: HTTPMethod,
                                  parameters: [String : AnyObject]?,
                                  headersAdditional: [String : String]?,
                                  encoding: ParameterEncoding?,
                                  isRequiredAccessToken: Bool = true,
                                  fail: @escaping (_ httpStatus: Int?, _ errorCode: String?) -> (), success: @escaping (_ data: JSON) -> ()) {
        self.networkOperation(method: useMethod, parameters: parameters, headersAdditional: headersAdditional, encoding: encoding, isRequiredAccessToken: isRequiredAccessToken,
                              fail: { (httpStatus, errorCode, data) in
                                fail(httpStatus, errorCode)
        }, success: success)
    }
    
    private func networkOperation(method useMethod: HTTPMethod,
                                  parameters: [String : AnyObject]?,
                                  headersAdditional: [String : String]?,
                                  encoding: ParameterEncoding?,
                                  isRequiredAccessToken: Bool = true,
                                  fail: @escaping (_ httpStatus: Int?, _ errorCode: String?, _ json: JSON) -> (),
                                  success: @escaping (_ data: JSON) -> ()) {
        
        var headers = headersCommon
        
        var requestEncoding: ParameterEncoding
        
        if encoding != nil {
            requestEncoding = encoding!
        } else {
            requestEncoding = JSONEncoding.default
        }
        
        var url = APIManager.host + endpoint
        
        var params: [String:AnyObject]?
        
        switch useMethod {
        case .get:
            var apiParams = ""
            for (key, name) in parameters! {
                apiParams = apiParams + key + "=" + "\(name)" + "&"
            }
            if apiParams.hasSuffix("&") {
                apiParams = String(apiParams.dropLast())
            }
            if apiParams != "" {
                url = "\(url)?\(apiParams)"
            }
        default:
            params = parameters
        }
        
        if headersAdditional != nil {
            for (k, v) in headersAdditional! {
                headers[k] = v
            }
        }
        
        if self.printResponse {
            print("________________________________________________________")
            print("url:   \(url)")
            print("method:  \(method)")
            print("headers:   \(headers)")
            print("params:   \(params ?? [:])")
        }
        
        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.handleFailResponse(response: nil, data: nil) { (httpStatus, errorCode, json) in
                fail(httpStatus, errorCode, json)
            }
            return
        }
        
        self.manager.request(urlEncoded, method: useMethod, parameters: params, encoding: requestEncoding, headers: headers).validate().responseJSON { (response) in
            
            switch response.result {
            case let .success(value):
                print(value)
                
                if response.response?.statusCode == 200 {
                    self.handleSuccessResponse(response: response.response, data: value, dictionary: { (json) in
                        success(json)
                    })
                } else {
                    self.handleFailResponse(response: response, data: value, dictionary: { (httpStatus, errorCode, json) in
                    })
                }
            case let .failure(error):
                print(error)
                self.handleFailResponse(response: response, data: response.result, dictionary: { (httpStatus, errorCode, json) in
                })
            }
        }
    }
    
    private func handleSuccessResponse(response: HTTPURLResponse?, data: Any, dictionary: (_ json: JSON) -> ()) {
        let json: JSON = JSON(data)
        if self.printResponse {
            print("response:   \(json)")
        }
        dictionary(json)
    }
    
    private func handleFailResponse(response: DataResponse<Any>?, data: Any?, dictionary: (_ httpStatus: Int?, _ errorCode: String?, _ json: JSON) -> ()) {
        let json: JSON = JSON(data as Any)
        var errorCode: String? = json["code"].stringValue
        var errorMsg = ""
        if errorCode?.count == 0 {
            if let error = response?.error as NSError? {
                errorCode = "\(error.code)"
                errorMsg = error.localizedDescription
            } else {
                errorCode = nil
            }
        }
        if self.printResponse {
            var statusCode = ""
            if let code = response?.response?.statusCode {
                statusCode = "\(code)"
            }
            var errCode = ""
            if let code = errorCode {
                errCode = code
            }
            print("httpStatus:   \(statusCode)")
            print("errorCode:   \(errCode)")
            if errorMsg != "" {
                print("errorMsg:   \(errorMsg)")
            }
            print("response:   \(json)")
        }
        dictionary(response?.response?.statusCode, errorCode, json)
    }
}
