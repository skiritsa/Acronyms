

import UIKit

class CreateAcronymTableViewController: UITableViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var acronymShortTextField: UITextField!
  @IBOutlet weak var acronymLongTextField: UITextField!
  @IBOutlet weak var userLabel: UILabel!
  
  // MARK: - Properties
  var selectedUser: User?
  var acronym: Acronym?
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    acronymShortTextField.becomeFirstResponder()
    populateUser()
  }
  
  func populateUser() {
    let usersRequest = ResourceRequest<User>(resourcePath: "users")
    
    usersRequest.getAll { [weak self] result in
      switch result {
      case . failure:
        let message = "There was an error getting the users"
        ErrorPresenter.showError(message: message, on: self) { _ in
          self?.navigationController?.popViewController(animated: true)
        }
      case .success(let users):
        DispatchQueue.main.async { [weak self] in
          self?.userLabel.text = users[0].name
        }
        self?.selectedUser = users[0]
      }
    }
  }
  
  // MARK: - IBActions
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func save(_ sender: UIBarButtonItem) {
    
    guard let shortText = acronymShortTextField.text, !shortText.isEmpty else {
      ErrorPresenter.showError(message: "You must specify an acronym", on: self)
      return
    }
    
    guard let longText = acronymLongTextField.text, !longText.isEmpty else {
      ErrorPresenter.showError(message: "You must specify a meaning", on: self)
      return
    }
    
    guard let userId = selectedUser?.id else {
      let message = "You must have a user to create an acronym!"
      ErrorPresenter.showError(message: message, on: self)
      return
    }
    
    let acronym = Acronym(
      short: shortText,
      long: longText,
      userID: userId)
    
    ResourceRequest<Acronym>(resourcePath: "acronyms").save(acronym) { [weak self] result in
      switch result {
      case .failure:
        let message = "There was a problem saving the acronym"
        ErrorPresenter.showError(message: message, on: self)
      case .success:
        DispatchQueue.main.async { [weak self] in
          self?.navigationController?
            .popViewController(animated: true)
        }
      }
    }
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func updateSelectedUser(_ segue: UIStoryboardSegue) {
    guard let controller = segue.source as? SelectUserTableViewController else { return }
    
    selectedUser = controller.selectedUser
    userLabel.text = selectedUser?.name
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SelectUserSegue" {
      guard let destination = segue.destination as? SelectUserTableViewController, let user = selectedUser else { return }
      destination.selectedUser = user
    }
  }
}
