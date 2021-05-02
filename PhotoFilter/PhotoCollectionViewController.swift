import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }

    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                
            } else {
                
            }
        }
    }
}
