import UIKit
import Photos
import RxSwift

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    private var photos = [PHAsset]()
    
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }
    
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
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell",
                                                            for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("PhotoCollectionViewCell not found")
        }
        
        let asset = self.photos[indexPath.row]
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAssets = self.photos[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAssets,
                                              targetSize: CGSize(width: 300, height: 300),
                                              contentMode: .aspectFit,
                                              options: nil) { [weak self] (photo, info) in
            guard let info = info else {
                return
            }
            
            let isDegradedPhoto = info["HPImageResultIsDegradedKey"] as! Bool
            
            if let photo = photo {
                self?.selectedPhotoSubject.onNext(photo)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - private funcs
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                 options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.photos.append(object)
                }
                
                self?.photos.reverse()
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                
            }
        }
    }
}
