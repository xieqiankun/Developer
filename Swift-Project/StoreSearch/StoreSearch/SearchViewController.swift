//
//  ViewController.swift
//  StoreSearch
//
//  Created by 谢乾坤 on 4/25/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit



class SearchViewController: UIViewController {
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var hasSearched = false
    var isLoading = false
    
    var dataTask: NSURLSessionDataTask?
    
    var searchResults = [SearchResult]()
    
    var landscapeViewController: LandscapeViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        
        tableView.rowHeight = 80
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlWithSearchText(searchText: String, category: Int) -> NSURL {
        
        
        let entityName: String
        
        switch category {
            
        case 1: entityName = "musicTrack"
            
        case 2: entityName = "software"
            
        case 3: entityName = "ebook"
            
        default: entityName = ""
        }
        
        // Be careful
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedSearchText, entityName)
        let url = NSURL(string: urlString)
        return url!
    }
    
    func performStoreRequestWithURL(url: NSURL) -> String? {
        do {
            return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch {
            print("Download Error: \(error)")
            return nil
        }
    }
    
    func parseJSON(data: NSData) -> [String: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData( data, options: []) as? [String: AnyObject]
            } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }

    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult] {
        // 1
        guard let array = dictionary["results"] as? [AnyObject]
            else {
                print("Expected 'results' array")
                return []
        }
        
        var searchResults = [SearchResult]()
        
        // 2
        for resultDict in array {
            // 3
            if let resultDict = resultDict as? [String: AnyObject] {
                // 4
                var searchResult: SearchResult?
                
                if let wrapperType = resultDict["wrapperType"] as? String {
                    switch wrapperType {
                    case "track":
                        searchResult = parseTrack(resultDict)
                    case "audiobook":
                        searchResult = parseAudioBook(resultDict)
                    case "software":
                        searchResult = parseSoftware(resultDict)
                    default:
                        break
                    }
                } else if let kind = resultDict["kind"] as? String where kind == "ebook" {
                    searchResult = parseEBook(resultDict)
                }
                if let result = searchResult {
                    searchResults.append(result)
                }
            }
        }
        
        return searchResults
    }
    
    func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["trackPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult { let searchResult = SearchResult()
        searchResult.name = dictionary["collectionName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["collectionViewUrl"] as! String
        searchResult.kind = "audiobook"
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["collectionPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["price"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["price"] as? Double {
            searchResult.price = price
        }
        if let genres: AnyObject = dictionary["genres"] {
            searchResult.genre = (genres as! [String]).joinWithSeparator(", ")
        }
        return searchResult
    }
    
   
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        performSearch()
        print("Segment changed: \(sender.selectedSegmentIndex)")
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = sender as! NSIndexPath
            let searchResult = searchResults[indexPath.row]
            detailViewController.searchResult = searchResult
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) { performSearch()
    }
    
    func performSearch() {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            dataTask?.cancel()
            tableView.reloadData()
            hasSearched = true
            searchResults = [SearchResult]()
        
            // 1  Create the NSURL object with the search text like before.
            let url = urlWithSearchText(searchBar.text!,category: segmentedControl.selectedSegmentIndex)
            
            // 2    Obtain the NSURLSession object. This grabs the standard “shared” session, which uses a default configuration with respect to caching, cookies, and other web stuff.
            //If you want to use a different configuration – for example, to restrict networking to when Wi-Fi is available but not when there is only cellular access – then you have to create your own NSURLSessionConfiguration and NSURLSession objects. But for this app the default one will be fine.
            
            let session = NSURLSession.sharedSession()
            
            // 3 Create a data task. Data tasks are for sending HTTPS GET requests to the server at url. The code from the completion handler will be invoked when the data task has received the reply from the server.
            
            dataTask = session.dataTaskWithURL(url, completionHandler: { data, response, error in
            // 4
                if let error = error where error.code == -999{
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    if let data = data, dictionary = self.parseJSON(data) {
                        self.searchResults = self.parseDictionary(dictionary)
                        self.searchResults.sortInPlace(<)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hasSearched = false
                        self.isLoading = false
                        self.tableView.reloadData()
                        self.showNetworkError()
                    }
                }
            })
        // 5
            dataTask?.resume()
        }
    }
    
    /*
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            isLoading = true
            tableView.reloadData()
            
            hasSearched = true
            searchResults = [SearchResult]()
            
            //1 This gets a reference to the queue. GCD uses regular functions, not classes and methods, because it is not limited to Swift and can also be used from Objective-C, C++, and even C programs. Most iOS frameworks are object-oriented but GCD isn’t. (We won’t hold that against it.)
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            //2 
            dispatch_async(queue, { 
                
                let url = self.urlWithSearchText(searchBar.text!)
                if let jsonString = self.performStoreRequestWithURL(url), let dictionary = self.parseJSON(jsonString) {
                    self.searchResults = self.parseDictionary(dictionary)
                    self.searchResults.sortInPlace(<)
                    // 3
                    dispatch_async(dispatch_get_main_queue()) {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.showNetworkError()
                }
            })
          
            
            /*
            let url = urlWithSearchText(searchBar.text!)
            print("URL: '\(url)'")
            
            if let jsonString = performStoreRequestWithURL(url) {
                if let dictionary = parseJSON(jsonString) {
                    print("Dictionary \(dictionary)")
                    searchResults = parseDictionary(dictionary)
                    
                    //searchResults.sortInPlace { $0.name.localizedStandardCompare($1.name)== .OrderedAscending }
                    
                    //searchResults.sortInPlace({ result1, result2 in return result1.name.localizedStandardCompare(result2.name) == .OrderedAscending
                    //})
                    
                    searchResults.sortInPlace(<)
                    
                    isLoading = false
                    tableView.reloadData()
                    return
                }

            }
            
            showNetworkError()
            */
        }
    }
 
 */
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0{
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier( TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier( TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            
            cell.configureForSearchResult(searchResult)
            
            
            return cell
        }
    }
    
    
    
    override func willTransitionToTraitCollection( newCollection: UITraitCollection,  withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(
            newCollection, withTransitionCoordinator: coordinator)
        switch newCollection.verticalSizeClass {
        case .Compact:
            showLandscapeViewWithCoordinator(coordinator)
        case .Regular, .Unspecified:
            hideLandscapeViewWithCoordinator(coordinator)
        }
    }
    
    func showLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        // 1 It should never happen that the app instantiates a second landscape view when you’re already looking at one. The pre-condition that landscapeViewController is still nil codifies this requirement and drops the app into the debugger if it turns out that this condition doesn’t hold.
        precondition(landscapeViewController == nil)
            
        // 2 Find the scene with the ID “LandscapeViewController” in the storyboard and instantiate it. Because you don’t have a segue you need to do this manually. This is why you filled in that Storyboard ID field in the Identity inspector.
        landscapeViewController =
            storyboard!.instantiateViewControllerWithIdentifier( "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeViewController {
            
            controller.searchResults = searchResults
            // 3 Set the size and position of the new view controller. This makes the landscape view just as big as the SearchViewController, covering the entire screen.
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            // 4
            view.addSubview(controller.view)
            addChildViewController(controller)
            coordinator.animateAlongsideTransition({ _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
                if self.presentedViewController != nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                }, completion: { _ in
            controller.didMoveToParentViewController(self)
            })
        }
    }
    
    func hideLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeViewController {
            
            coordinator.animateAlongsideTransition({ _ in
                
                controller.view.alpha = 0
                },completion: { _ in
                controller.willMoveToParentViewController(nil)
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
                self.landscapeViewController = nil
            })
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
   
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
}

