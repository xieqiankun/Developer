//
//  TableContainerViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 4/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

var currentActiveTableStatus: gStackTournamentStatus = gStackTournamentStatus.Active

class TableContainerViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var imageLable: UIImageView!
    
    @IBOutlet weak var viewBar: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var embeddedPageViewController: TournamentsPageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Page Control
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        
        setPageTitle()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var titleName = "Active"
    func setColorsAndTitleText(){
        
        switch pageControl.currentPage {
        case 1:
            titleName = "Active"
        case 0:
            titleName = "Expired"
        case 2:
            titleName = "Upcoming"
        default:
            break
        }
    }
    
    func setPageDotColor(){
        
        switch pageControl.currentPage {
        case 1:
            pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        case 0:
            pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        case 2:
            pageControl.currentPageIndicatorTintColor = UIColor.yellowColor()
        default:
            break
        }
        
    }
    
    
    func setPageTitle(){
        
        setColorsAndTitleText()
        
        let image = UIImage(named: titleName)
        self.imageLable.image = image
        
        
        //viewBar.addSubview(pageControl)
        
    }
    
    // MARK:- UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentViewController = pageViewController.viewControllers![0]
        
        let currentIndex = (pageViewController as! TournamentsPageViewController).tournamentViewControllers.indexOf(currentViewController)!
        
        pageControl.currentPage = currentIndex
        
        setPageTitle()
        setPageDotColor()
        

        let index = pageControl.currentPage
        
        switch index {
        case 0:
            currentActiveTableStatus = gStackTournamentStatus.Expired
        case 1:
            currentActiveTableStatus = gStackTournamentStatus.Active
        default:
            currentActiveTableStatus = gStackTournamentStatus.Upcoming
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let embeddedViewController = segue.destinationViewController as? TournamentsPageViewController where segue.identifier == "EmbedTournamentTableSegue" {
            
            embeddedViewController.embeddingViewController = self
            embeddedPageViewController = embeddedViewController
        }
    }
    
}
