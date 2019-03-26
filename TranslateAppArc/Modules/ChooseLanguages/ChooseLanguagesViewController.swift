//
//  ChooseLanguagesViewController.swift
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

protocol ChooseLanguageViewControllerDelegate  {
    func updateControllerWithChanges(fromSelectedLanguage : Language?,toSelectedlanguage: Language?,languages:[Language]?)
}

protocol ChooseLanguagesDisplayLogic: class
{
  //func displaySomething(viewModel: ChooseLanguages.Something.ViewModel)
    func displayLanguages(languages: [Language],error:Error?)
}

class ChooseLanguagesViewController: UIViewController, ChooseLanguagesDisplayLogic
{
  var interactor: ChooseLanguagesBusinessLogic?
  var router: (NSObjectProtocol & ChooseLanguagesRoutingLogic & ChooseLanguagesDataPassing)?

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
    let interactor = ChooseLanguagesInteractor()
    let presenter = ChooseLanguagesPresenter()
    let router = ChooseLanguagesRouter()
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
      if let router = router{
        router.perform(selector, with: segue)
      }
    }
  }
    
    //MARK: - Outlets
    
    @IBOutlet weak var fromChooseLangBtn: UIButton!
    @IBOutlet weak var toChooseLangBtn: UIButton!
    @IBOutlet weak var buttonLangViewContainer : UIView!
    @IBOutlet weak var fromTableView: UITableView!
    @IBOutlet weak var toTableView: UITableView!
    
    //MARK: - Properties
    var languages : [Language]?
    var fromSelectedLanguage : Language?
    var toSelectedLanguage : Language?
    var delegate : ChooseLanguageViewControllerDelegate?
    var buttonTag : Int?
    
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    setupUI()
    setupButtonsContainer(container: buttonLangViewContainer)
    setupTitleForChooseLanguageButtons()
    
  }

  //Populate tableViews
    
    func displayLanguages(languages: [Language], error: Error?) {
        guard error == nil else{
            //Present Alert Controller
            print("Error Getting the languages : \(String(describing: error?.localizedDescription))")
            return
        }
        
        self.languages = languages
        self.fromTableView.reloadData()
        self.toTableView.reloadData()
    }
    
    //MARK: -Actions
    @IBAction func fromLanguageButton(_ sender: UIButton?) {
        buttonsAppearance(buttonSelected: fromChooseLangBtn, buttonReleased: toChooseLangBtn)
        fromTableView.isHidden = false
        toTableView.isHidden = true
    }
    
    @IBAction func toLanguageButton(_ sender: UIButton?) {
        buttonsAppearance(buttonSelected: toChooseLangBtn, buttonReleased: fromChooseLangBtn)
        fromTableView.isHidden = true
        toTableView.isHidden = false
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.updateControllerWithChanges(fromSelectedLanguage: fromSelectedLanguage ?? nil, toSelectedlanguage: toSelectedLanguage ?? nil, languages: languages ?? nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions
    
    private func setupUI(){
        if languages == nil {
            interactor?.getLanguages()
        }
        
        guard let buttonTag = buttonTag else{
            return
        }
        
        if buttonTag == 0 {
            fromLanguageButton(nil)
        }else{
            toLanguageButton(nil)
        }
        
    }
    
    private func setupTitleForChooseLanguageButtons(){
        
        if let fromSelectedLanguage = fromSelectedLanguage{
            fromChooseLangBtn.setTitle(fromSelectedLanguage.name, for: .normal)
        }
        
        if let toSelectedLanguage = toSelectedLanguage{
            toChooseLangBtn.setTitle(toSelectedLanguage.name, for: .normal)
        }
        
    }
    
}

extension ChooseLanguagesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let languages = languages else {
            print("Problem")
            return
        }
        if tableView == fromTableView{
            guard let fromCell = tableView.cellForRow(at: indexPath) else { return }
            fromCell.accessoryType = .checkmark
            fromCell.textLabel?.textColor = UIColor(red: 242/256, green: 76/256, blue: 92/256, alpha: 1)
            fromSelectedLanguage = languages[indexPath.row]
            fromChooseLangBtn.setTitle(fromSelectedLanguage?.name, for: .normal)
        }else{
            guard let toCell = tableView.cellForRow(at: indexPath) else { return }
            toCell.accessoryType = .checkmark
            toCell.textLabel?.textColor = UIColor(red: 242/256, green: 76/256, blue: 92/256, alpha: 1)
            toSelectedLanguage = languages[indexPath.row]
            toChooseLangBtn.setTitle(toSelectedLanguage?.name, for: .normal)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView == fromTableView{
            guard let fromCell = tableView.cellForRow(at: indexPath) else { return }
            fromCell.accessoryType = .none
            fromCell.textLabel?.textColor = .black
            fromSelectedLanguage = nil
        }else{
            guard let toCell = tableView.cellForRow(at: indexPath) else { return }
            toCell.accessoryType = .none
            toCell.textLabel?.textColor = .black
            toSelectedLanguage = nil
        }
        
    }
    
}

extension ChooseLanguagesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let languages = languages{
            return languages.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let languages = languages {
            if tableView == fromTableView {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "fromLanguageCell", for: indexPath)
                
                let languageName = languages[indexPath.row].name
                cell.textLabel?.text = languageName
                
                return cell
                
            }else { //toTableView
                let cell = tableView.dequeueReusableCell(withIdentifier: "toLanguageCell", for: indexPath)
                
                let languageName = languages[indexPath.row].name
                cell.textLabel?.text = languageName
                
                return cell
            }
        }else{
            return UITableViewCell()
        }
        
    }
    
    
}
