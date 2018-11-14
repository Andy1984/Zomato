import UIKit

class FavouriteViewController: UIViewController {
    var tableView:RestaurantTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favourite"
        self.tableView = RestaurantTableView(frame: self.view.frame)
        view.addSubview(tableView)
        tableView.restaurants = ZomatoFavouriteManager.manager().favouriteRestaurants
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(addFavourite(notification:)), name: ZomatoAddFavouriteNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFavourite(notification:)), name: ZomatoRemoveFavouriteNotification, object: nil)
    }
    
    @objc func removeFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? Restaurant else {
            return
        }
        guard let id = rest.id else {
            return
        }
        guard let indexPath = tableView.getIndexPathToRemove(id: id) else {
            return
        }
        self.tableView.restaurants.remove(at: indexPath.row)
        self.tableView.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        //Hide bug of DZNEmptyDataSet
        if self.tableView.restaurants.count == 0 {
            self.tableView.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func addFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? Restaurant else {
            return
        }
        self.tableView.restaurants.append(rest)
        self.tableView.reloadData()

    }
}
