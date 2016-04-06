//
//  HomeViewController.swift
//  Trivios Tournaments
//
//  Created by Evan Bernstein on 7/28/15.
//  Copyright (c) 2015 Purple Gator. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDelegate {
    
    var embeddedPageViewController: TournamentsPageViewController?
    
    var pageControl = UIPageControl()
    
    @IBOutlet var localFilterButton: UIButton!
    @IBOutlet var favoritesFilterButton: UIButton!
    @IBOutlet var codeFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Page control
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.currentPageIndicatorTintColor = kPageControlCurrentPageTintColor
        pageControl.pageIndicatorTintColor = kPageControlTintColor
        
        
        setPageTitle()
        
        
        //User Management
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUserStatus", name: "UserStatusChanged", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        checkUserStatus()
    }
    
    
    var unselectedBackgroundColor = kActiveTournamentsUnselectedBackgroundColor
    var unselectedTextColor = kActiveTournamentsUnselectedTextColor
    var selectedBackgroundColor = kActiveTournamentsSelectedBackgroundColor
    var selectedTextColor = kActiveTournamentsSelectedTextColor
    var titleText = "Active Tournaments"
    func setColorsAndTitleText() {
        switch pageControl.currentPage {
        case 1:
            titleText = "Active Tournaments"
            unselectedBackgroundColor = kActiveTournamentsUnselectedBackgroundColor
            unselectedTextColor = kActiveTournamentsUnselectedTextColor
            selectedBackgroundColor = kActiveTournamentsSelectedBackgroundColor
            selectedTextColor = kActiveTournamentsSelectedTextColor
        case 0:
            titleText = "Expired Tournaments"
            unselectedBackgroundColor = kExpiredTournamentsUnselectedBackgroundColor
            unselectedTextColor = kExpiredTournamentsUnselectedTextColor
            selectedBackgroundColor = kExpiredTournamentsSelectedBackgroundColor
            selectedTextColor = kExpiredTournamentsSelectedTextColor
        case 2:
            titleText = "Upcoming Tournaments"
            unselectedBackgroundColor = kUpcomingTournamentsUnselectedBackgroundColor
            unselectedTextColor = kUpcomingTournamentsUnselectedTextColor
            selectedBackgroundColor = kUpcomingTournamentsSelectedBackgroundColor
            selectedTextColor = kUpcomingTournamentsSelectedTextColor
        default:
            break
        }

    }
    
    
    
    func setPageTitle() {
        setColorsAndTitleText()
        
        navigationController?.navigationBar.tintColor = unselectedBackgroundColor
        
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.textColor = unselectedBackgroundColor
        titleLabel.sizeToFit()
        
        let padding = CGFloat(5.0)
        let titleView = UIView(frame: CGRectMake(0, 0, titleLabel.frame.width, titleLabel.frame.height+padding+pageControl.frame.height))
        titleView.addSubview(titleLabel)
        titleView.addSubview(pageControl)
        pageControl.center = CGPointMake(titleView.frame.width / 2, titleLabel.frame.height+padding+pageControl.frame.height/2)
        
        navigationItem.titleView = titleView
                
        tabBarController?.tabBar.tintColor = unselectedBackgroundColor
        
        for button in [localFilterButton,favoritesFilterButton,codeFilterButton] {
            button.backgroundColor = unselectedBackgroundColor
            button.setImageTintColor(unselectedTextColor, forState: UIControlState.Normal)
        }
    }
    
    
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers![0]
        
        let currentIndex = (pageViewController as! TournamentsPageViewController).tournamentViewControllers.indexOf(currentViewController)!
        pageControl.currentPage = currentIndex
        
        setPageTitle()
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let embeddedViewController = segue.destinationViewController as? TournamentsPageViewController where segue.identifier == "EmbedSegue" {
            embeddedViewController.embeddingViewController = self
            embeddedPageViewController = embeddedViewController
        }
    }
    
    
    
    @IBAction func filterSelected(sender: UIButton) {
        if sender.selected {
            sender.selected = false
        }
        else {
            sender.selected = true
        }
        
        if codeFilterButton.selected {
            if sender == codeFilterButton {
                localFilterButton.selected = false
                favoritesFilterButton.selected = false
            }
            else {
                codeFilterButton.selected = false
            }
        }
        
        var filter = gStackTournamentFilter.None
        

        if localFilterButton.selected {
            filter = .Local
        }
        else if codeFilterButton.selected {
            filter = .Code
        }
        
        if let currentTournamentsViewController = embeddedPageViewController?.viewControllers!.first as? gStackTournamentListProtocol {
            currentTournamentsViewController.tournamentFilter = filter
            currentTournamentsViewController.refreshTournaments()
        }
        
        //Colors
        if sender.selected == false {
            sender.backgroundColor = unselectedBackgroundColor
            sender.setImageTintColor(unselectedTextColor, forState: .Normal)
        } else {
            sender.backgroundColor = selectedBackgroundColor
            sender.setImageTintColor(selectedTextColor, forState: .Normal)
        }
    }
    
    
    
    //MARK: - Layout Control
    @IBAction func changeToGrid() {
        embeddedPageViewController?.layoutStyleIsTable = false
        
        let changeToTableButton = UIBarButtonItem(image: UIImage(named: "ListIcon"), style: .Plain, target: self, action: #selector(HomeViewController.changeToTable))
        navigationItem.setRightBarButtonItem(changeToTableButton, animated: true)
    }
    
    @IBAction func changeToTable() {
        embeddedPageViewController?.layoutStyleIsTable = true
        
        let changeToGridButton = UIBarButtonItem(image: UIImage(named: "GridIcon"), style: .Plain, target: self, action: "changeToGrid")
        navigationItem.setRightBarButtonItem(changeToGridButton, animated: true)
    }
}
