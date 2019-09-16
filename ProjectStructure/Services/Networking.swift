//
//  Networking.swift
//  ProjectStructure
//
//  Created by Krishna Soni on 02/08/19.
//  Copyright © 2019 Krishna Soni. All rights reserved.
//

import Foundation
import Alamofire

var APIURL:String        =   "http://192.168.1.162/sevenchats_mul/backend/api/v1/"

//MARK:- ---------Networking -

typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?, _ data: Data?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void

class Networking: NSObject {
    
    // API Base url seup
    var BASEURL:String {
        
        guard APIURL.count > 0 else {
            return "http://wrongurl"
        }
        
        if (!APIURL.hasSuffix("/")) {
            return APIURL + "/"
        }
        
        return "http://wrongurl"
    }
    
    var headers:[String: String] {
        return ["Authorization" : "Bearer 123456789","Content-Type" : "application/json", "Accept-Language" : "en", "language":"1","Accept" : "application/json"]
    }
    
    private let arrSuccessStatus: [Int] = [200, 201, 401]
    
    
    var loggingEnabled = true
    var activityCount = 0
    var backroundSession = URLSessionConfiguration.background(withIdentifier: "com.socialmedia.app.backgroundtransfer")
    public var backgroundSessionManager : SessionManager!
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    
    override init() {
        super.init()
        backroundSession.timeoutIntervalForResource = (60 * 10)
        backgroundSessionManager = Alamofire.SessionManager(configuration: backroundSession)
    }
    
}


//MARK:- --------- Api Methods -

extension Networking {
    
    /*
     // The way to pass the additional data in header. Use this before calling the api from service file.
     
     var header = Networking.sharedInstance.headers
     header["name"] = "krishna"
     */
    
    // Api Service
    func apiService(
        apiTag tag: String? = nil,
        param parameters: [String: AnyObject]?,
        apiMethod method: HTTPMethod,
        success : ClosureSuccess?,
        failure:ClosureError?,
        internalheaders: HTTPHeaders? = nil
        ) -> URLSessionTask? {
        
        var url: String = BASEURL
        
        // If api tag is there then append it with base url
        if let `tag` = tag {
            url = url + tag
        }
        
        let uRequest = SessionManager.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: internalheaders ?? headers
        )
        
        self.handleResponseStatus(
            uRequest: uRequest,
            success: success,
            failure: failure
        )
        
        return uRequest.task
    }
    
    // Api Service for media
    func POST(
        param parameters:[String: AnyObject]?,
        tag:String?,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        success:ClosureSuccess?,
        failure:ClosureError?
        ) -> Void {
        
        SessionManager.default.upload(multipartFormData: { [weak self] (multipart) in
            
            guard let _ = self, let `parameters` = parameters else {
                return
            }
            
            multipartFormData(multipart)
            
            for (key, value) in parameters {
                multipart.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        },  to: (BASEURL + (tag ?? "")), method: .post , headers: headers) { [weak self] (encodingResult) in
            
            guard let `self` = self else {
                return
            }
            
            switch encodingResult {
                
            case .success(let uRequest, _, _):
                
                self.handleResponseStatus(
                    uRequest: uRequest,
                    success: success,
                    failure: failure
                )
                
            case .failure(let encodingError):
                print("encodingError ====>>>> \(encodingError)")
                break
            }
            
        }
    }
}

//MARK:- --------- Response Handler -
extension Networking {
    
    fileprivate func handleResponseStatus(
        uRequest:DataRequest ,
        success : ClosureSuccess?,
        failure:ClosureError?
        ) {
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON {[weak self] (response) in
            
            guard let `self` = self else {
                return
            }
            
            self.logging(response: response)
            
            if response.result.error == nil, let subResponse = response.response, self.arrSuccessStatus.contains(subResponse.statusCode) {
                
                guard let `success` = success, let task = uRequest.task else {
                    return
                }
                
                success(
                    task,
                    response.result.value as AnyObject,
                    response.data
                )
                
            } else {
                
                guard let `failure` = failure, let task = uRequest.task else {
                    return
                }
                
                if response.result.error != nil {
                    
                    failure(
                        task,
                        nil,
                        response.result.error as NSError?
                    )
                    
                } else {
                    
                    guard let dict = response.result.value as? [String : AnyObject],
                        let statusCode = dict["status"] as? Int,
                        let message = dict["message"] as? String
                        else {
                            return failure(
                                uRequest.task!,
                                nil,
                                nil
                            )
                    }
                    
                    let error = NSError(
                        domain: "",
                        code: statusCode,
                        userInfo: dict
                    )
                    
                    failure(
                        task,
                        message,
                        error
                    )
                }
            }
        }
    }
    
    fileprivate func logging(request req:Request?) -> Void {
        
        if (loggingEnabled && req != nil) {
            
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
            
            print("API Request: \(printableString)")
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void {
        
        if (loggingEnabled && (res != nil)) {
            
            if (res?.result.error != nil) {
                
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
}

//TODO: Refactor later.
extension Networking {
    
    /*
     - Always call below methods from each api function to verify your response (I prefere Success/Error model to check api status along with api calling).
     - Update below methods with Model as per api response.
     */
    
    /*
     func checkResponseStatusAndShowAlert(showAlert:Bool, responseobject: AnyObject?, strApiTag:String) -> Bool {
     
     if let meta = responseobject?.value(forKey: CJsonMeta) as? [String : Any] {
     
     switch meta.valueForInt(key: CJsonStatus) {
     case CStatusZero:
     return true
     
     case CStatusFour:
     return true
     
     case CStatusTen : //register from admin
     return true
     
     case CStatus200 : //register from admin
     return true
     
     default:
     if showAlert {
     let message = meta.valueForString(key: CJsonMessage)
     GCDMainThread.async {
     CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: nil)
     }
     }
     }
     }else {
     if let status = responseobject?.value(forKey: "status") as? Int{
     if status == 401{
     let token = (CUserDefaults.value(forKey: UserDefaultDeviceToken)) as? String ?? ""
     if !token.isBlank{
     appDelegate.logOut()
     }
     }
     }
     }
     
     return false
     }
     
     func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void {
     
     if showAlert && errorMessage != nil {
     CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMessage!, btnOneTitle: CBtnOk, btnOneTapped: nil)
     }
     
     print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
     }
     */
}
