import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotoCollectionViewController else {
            fatalError("destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyFilterAction(_ sender: Any) {
        guard let sourceImage = photo.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.photo.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        photo.image = image
        applyFilterButton.isHidden = false
    }
}

