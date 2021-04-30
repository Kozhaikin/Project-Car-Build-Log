//
//  ViewController.swift
//  Project Car Build Log
//
//  Created by Nick Abel on 4/19/21.
//

import UIKit

// Main page; page view controller (separate file from each page)
class ViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        // sets page 1 as first view controller
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newPageViewController(pageNum: 1),
                self.newPageViewController(pageNum: 2),
                self.newPageViewController(pageNum: 3)]
    }()
    
    private func newPageViewController(pageNum: Int) ->UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Page \(pageNum)")
    }


}

extension ViewController: UIPageViewControllerDataSource {
    
    // Tells program what the previous page is
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    } // end pageViewController with viewControllerBefore
    
    // Tells program what the next page is
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
        
    } // end pageViewController with viewControllerAfter
    
}

