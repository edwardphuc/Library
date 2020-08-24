

import UIKit
import Photos

@available(iOS 10.0, *)
@available(iOS 13.0, *)
class ListAlbumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var listAlbum = NSArray()
    let activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listAlbum = NSArray.init()
        setupUI()
        authorized()
    }
    
    func authorized() {
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        PHPhotoLibrary.requestAuthorization{(status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.fetchdata()
                case .denied, .notDetermined, .restricted:
                    self.showAlertSetting()
                default:
                    break
                }
            }
        }
    }
    
    func showAlertSetting() {
        let alertController = UIAlertController (title: "Accept to photo", message: "Go to Settings?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupUI() {
        self.title = "Library"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
    }
    
    func fetchdata() {
        //myActivityIndicator.center = self.mycollectionview.center
        let manager = LibraryManager()
        manager.getListAlbum{(result) in
            self.listAlbum = result
            //print(result.count)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

}
@available(iOS 10.0, *)
@available(iOS 13.0, *)
extension ListAlbumViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! AlbumCell
        cell.setupUI(album: listAlbum[indexPath.row] as! AlbumModel)
//        let image = listalbum[indexPath.row] as! AlbumModel
//        print(image.collection.localIdentifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumdetail = AlbumDetailViewController()
        albumdetail.delegate = self
        albumdetail.album = listAlbum[indexPath.row] as? AlbumModel
        albumdetail.modalPresentationStyle = .fullScreen
        self.present(albumdetail , animated: true)
    }
    
}

@available(iOS 10.0, *)
@available(iOS 13.0, *)
extension ListAlbumViewController: UICollectionViewDelegateFlowLayout{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

@available(iOS 13.0, *)
extension ListAlbumViewController: AlbumDetailViewControllerDelegate {
    func reload() {
        self.fetchdata()
        self.tableView.reloadData()
    }
}
