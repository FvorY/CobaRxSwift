import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController.navigationItem.backBarButtonItem?.isEnabled = true
        
        let navController = self.navigationController
        navController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        let vc = ListViewController.instantiateXib()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCart(data: [ListCart]) {
        let vc = ListCartViewController.instantiateXib()
        vc.coordinator = self
        vc.listCart = data
        navigationController.pushViewController(vc, animated: false)
    }
    
    func dismiss() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
