import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    private var images = [PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }

    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
//                self?.collectionView.reloadData()
                print(self?.images)
            } else {
                
            }
        }
    }
}
