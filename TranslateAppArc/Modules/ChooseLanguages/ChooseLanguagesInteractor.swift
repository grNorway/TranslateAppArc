//
//  ChooseLanguagesInteractor.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 22/03/2019.
//  Copyright (c) 2019 Panagiotis Siapkaras. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChooseLanguagesBusinessLogic
{
  //func doSomething(request: ChooseLanguages.Something.Request)
    func getLanguages()
    
}

protocol ChooseLanguagesDataStore
{
  var languages: [Language] { get set }
}

class ChooseLanguagesInteractor: ChooseLanguagesBusinessLogic, ChooseLanguagesDataStore
{
    var languages: [Language] = []
    
  var presenter: ChooseLanguagesPresentationLogic?
  var worker: ChooseLanguagesWorker?
  
  
  // MARK: Do something
  
    func getLanguages() {
        worker = ChooseLanguagesWorker()
        worker?.getLanguages(url: GoogleClient.Endpoints.getLanguages.url, responseType: ChooseLanguages.LanguagesModel.Response.self, completion: { (response, error) in
            
            if let error = error as NSError?{
                print("Error Get Languages: \(error)")
                self.presenter?.presentLanguages(languages: [], error: error)
            }else{
                if let response = response{
                    self.languages = response.data.languages
                    self.presenter?.presentLanguages(languages: self.languages, error: nil)
                }
                
            }
            
        })
    }
    
//  func doSomething(request: ChooseLanguages.Something.Request)
//  {
//    worker = ChooseLanguagesWorker()
//    worker?.doSomeWork()
//
//    let response = ChooseLanguages.Something.Response()
//    presenter?.presentSomething(response: response)
//  }
}
