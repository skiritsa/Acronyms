

import UIKit

class CategoriesTableViewController: UITableViewController {

  // MARK: - Properties
  var categories: [Category] = []

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
    DispatchQueue.main.async {
      sender?.endRefreshing()
    }
  }
}

// MARK: - UITableViewDataSource
extension CategoriesTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categories[indexPath.row].name
    return cell
  }
}
