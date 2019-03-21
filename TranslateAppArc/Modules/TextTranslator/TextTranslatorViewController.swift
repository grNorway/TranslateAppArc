//
//  TextTranslatorViewController.swift
//  TranslateAppArc
//
//  Created by PS Shortcut on 21/03/2019.
//  Copyright (c) 2019 Panagiotis Siapkaras. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TextTranslatorDisplayLogic: class
{
  //func displaySomething(viewModel: TextTranslator.Something.ViewModel)
    func updateTranslatedText(translatedText: String,error: String?)
}

class TextTranslatorViewController: UIViewController, TextTranslatorDisplayLogic
{
    
    
  var interactor: TextTranslatorBusinessLogic?
  var router: (NSObjectProtocol & TextTranslatorRoutingLogic & TextTranslatorDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = TextTranslatorInteractor()
    let presenter = TextTranslatorPresenter()
    let router = TextTranslatorRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
    //MARK: - Outlets
    
    @IBOutlet weak var FromChooseLangBtn: UIButton!
    @IBOutlet weak var ToChooseLangBtn: UIButton!
    @IBOutlet weak var changeLangFromToBtn: UIButton!
    
    @IBOutlet weak var fromLangLabel: UILabel!
    @IBOutlet weak var toLangLabel: UILabel!
    
    @IBOutlet weak var fromTextToTranslate: UITextView!
    @IBOutlet weak var toTextToTranslate: UITextView!
    @IBOutlet weak var buttonLangViewContainer: UIView!
    
    //MARK: - Properties
    
    
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    interactor?.getTranslation(sourceLang: "En", targetLang: "co", qText: "Hello")
//    let request = TextTranslator.Something.Request()
    //interactor?.doSomething(request: request)
  }
    func updateTranslatedText(translatedText: String,error: String?){
        DispatchQueue.main.async {
            self.toTextToTranslate.text = translatedText
        }
        
        if let error = error {
            print("Error : \(error)")
        }
    }
    
//  func displaySomething(viewModel: TextTranslator.Something.ViewModel)
//  {
//    //nameTextField.text = viewModel.name
//  }
}
