

import UIKit

class UsersTableViewController: UITableViewController {

  // MARK: - Properties
  var users: [User] = []

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
extension UsersTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
    cell.textLabel?.text = user.name
    cell.detailTextLabel?.text = user.username
    return cell
  }
}
