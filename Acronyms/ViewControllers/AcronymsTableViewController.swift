

import UIKit

class AcronymsTableViewController: UITableViewController {
  
  // MARK: - Properties
  
  var acronyms: [Acronym] = []
  let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronyms")
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh(nil)
  }
  
  // MARK: - IBActions
  @IBAction func refresh(_ sender: UIRefreshControl?) {
    
    acronymsRequest.getAll { [weak self] acronymResult in
      
      DispatchQueue.main.async {
        sender?.endRefreshing()
      }
      
      switch acronymResult {
      case .failfure:
        ErrorPresenter.showError(message: "There was an error getting the acronyms", on: self)
        
      case .success(let acronyms):
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.acronyms = acronyms
          self.tableView.reloadData()
        }
        
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension AcronymsTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return acronyms.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymCell", for: indexPath)
    let acronym = acronyms[indexPath.row]
    cell.textLabel?.text = acronym.short
    cell.detailTextLabel?.text = acronym.long
    return cell
  }
}
