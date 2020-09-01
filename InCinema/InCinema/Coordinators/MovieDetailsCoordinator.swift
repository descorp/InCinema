//
//  MovieDetailsCoordinator.swift
//  InCinema
//
//  Created by Vladimir Abramichev on 25/10/2018.
//  Copyright © 2018 Vladimir Abramichev. All rights reserved.
//

import Foundation
import MDBProvider

class MovieDetailsCoordinator: Coordinator, CoordinatorDelegate {
    
    private let viewModel: MovieViewModel
    private let origin: CGRect
    
    init(viewModel: MovieViewModel,
         origin: CGRect,
         withViewController viewController: UIViewController,
         andParentCoordinator parentCoordinator: Coordinator?) {
        self.viewModel = viewModel
        self.origin = origin
        super.init(withRootController: viewController, andParentCoordinator: parentCoordinator)
    }
    
    override func start() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
        else { return }
        
        let viewController = MovieDetailsView(viewModel: viewModel)
        viewModel.viewDelegate = viewController
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self

        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    override func finish() {
        guard
            let navigationController =  (rootViewController as? UINavigationController)
        else { return }
        
        navigationController.isNavigationBarHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func viewModelDidThrowError(_ viewModel: ViewModel, error: Error?) {
    }

}

extension MovieDetailsCoordinator : UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DissmissAnimation(originalFrame: origin, backdropImage: viewModel.posterImage ?? UIImage())
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ShowAnimation(originalFrame: origin, backdropImage: viewModel.posterImage ?? UIImage())
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        nil
    }
}

final class Transition: UIPresentationController {

}

final class ShowAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let originalFrame: CGRect
    private let backdropImage: UIImage

    internal init(originalFrame: CGRect, backdropImage: UIImage) {
        self.originalFrame = originalFrame
        self.backdropImage = backdropImage
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toShow = transitionContext.viewController(forKey: .to) else { return }

        let snapshot = UIImageView(image: backdropImage)
        snapshot.contentMode = .scaleAspectFit

        let containerView = transitionContext.containerView

        containerView.addSubview(toShow.view)
        containerView.addSubview(snapshot)

        snapshot.frame = originalFrame
        snapshot.alpha = 0
        toShow.view.frame = containerView.frame
        toShow.view.alpha = 0

        UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33) {
                snapshot.alpha = 1
                snapshot.center = containerView.center
            }

            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                snapshot.frame = transitionContext.finalFrame(for: toShow)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
                toShow.view.alpha = 1
                snapshot.alpha = 0
            }
        }, completion: { finished in
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}

final class DissmissAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let originalFrame: CGRect
    private let backdropImage: UIImage

    internal init(originalFrame: CGRect, backdropImage: UIImage) {
        self.originalFrame = originalFrame
        self.backdropImage = backdropImage
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toShow = transitionContext.viewController(forKey: .from) else { return }

        let snapshot = UIImageView(image: backdropImage)
        snapshot.contentMode = .scaleAspectFit
        snapshot.alpha = 0

        let containerView = transitionContext.containerView

        containerView.addSubview(snapshot)

        UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33) {
                toShow.view.alpha = 0
                snapshot.alpha = 1
            }

            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33) {
                snapshot.frame = self.originalFrame
            }

            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33) {
                snapshot.alpha = 0
            }
        }, completion: { finished in
            snapshot.removeFromSuperview()
            toShow.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}

