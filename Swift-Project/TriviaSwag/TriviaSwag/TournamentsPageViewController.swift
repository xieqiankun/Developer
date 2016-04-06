//
//  TournamentPageViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

class TournamentsPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var tournamentViewControllers = [UIViewController]()
    
    var embeddingViewController: TableContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = embeddingViewController
        dataSource = self
        
        instantiateViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func instantiateViewController(){
        
        var currentPage = embeddingViewController!.pageControl.currentPage
        if currentPage < 0 {
            currentPage = 1
        }
        
        let storyboardID = "TournamentsTableID"
        
        let expiredViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardID)
        (expiredViewController as! gStackTournamentListProtocol).tournamentStatus = .Expired
        
        let nowViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardID)
        (nowViewController as! gStackTournamentListProtocol).tournamentStatus = .Active
        
        let upcomingViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardID)
        (upcomingViewController as! gStackTournamentListProtocol).tournamentStatus = .Upcoming
        
        tournamentViewControllers = [expiredViewController!,nowViewController!,upcomingViewController!]
        
        setViewControllers([tournamentViewControllers[currentPage]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    }
    
    //MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = tournamentViewControllers.indexOf(viewController)!
        
        if currentIndex > 0 {
            return tournamentViewControllers[currentIndex-1]
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = tournamentViewControllers.indexOf(viewController)!
        
        if currentIndex < tournamentViewControllers.count - 1 {
            return tournamentViewControllers[currentIndex+1]
        }
        return nil
    }
    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return tournamentViewControllers.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 0 //Is this right??
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
