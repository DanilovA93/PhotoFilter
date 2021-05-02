import UIKit
import Photos

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    private var images = [PHAsset]()
    
    //MARK: - lifecycle funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }
    
    //MARK: - overrided funcs
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 100, height: 100),
                             contentMode: .aspectFit,
                             options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
    
    //MARK: - private funcs
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                 options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                
                self?.images.reverse()
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                
            }
        }
    }
}
