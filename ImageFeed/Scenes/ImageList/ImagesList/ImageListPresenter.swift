import Foundation

final class ImageListPresenter: ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imagesListService = ImagesListService.shared

    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }

    func chekFilledList(_ indexPath: IndexPath) {
        if imagesListService.photos.isEmpty || (indexPath.row + 1 == imagesListService.photos.count) {
            fetchPhotosNextPage()
        }
    }

    func setLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike, { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        })
    }
}
