//
//  GameOverViewController.swift
//  TriviaSwag
//
//  Created by 谢乾坤 on 6/4/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

import UIKit

protocol RestartGame:class {
    func restartGame()
}

class GameOverViewController: UIViewController{

    weak var restartDelegate: RestartGame?
    
    var tournament: gStackTournament!
    var questions: [gStackGameQuestion]!
    var answers: [gStackGameCorrectAnswer]!
    var numOfCorrect: Int = 0
    var numOfQuestion: Int = 0
    var totalTime: Double = 0.0
    
    let animationTime = 5.0
    
    var leaderboard: gStackTournamentLeaderboard? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) {
                if self.leaderboard != nil {
                    self.addLeadersInTenScreen()
                }
            }
        }
    }
    
    @IBOutlet weak var constrain: NSLayoutConstraint!
    //1 st
    @IBOutlet weak var firstScreen: UIView!
    @IBOutlet weak var spinner: UIImageView!
    @IBOutlet weak var avatarGIF: UIImageView!
    @IBOutlet weak var correctNum: UILabel!
    
    
    //2 st
    @IBOutlet weak var tenScreen: UIView!
    
    @IBOutlet weak var place1: UIView!
    @IBOutlet weak var place2: UIView!
    @IBOutlet weak var place3: UIView!
    @IBOutlet weak var place4: UIView!
    
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var title_rank: UILabel!
    @IBOutlet weak var title_player: UILabel!
    @IBOutlet weak var title_correct: UILabel!
    @IBOutlet weak var title_time: UILabel!
    @IBOutlet weak var title_score: UILabel!
    @IBOutlet weak var title_prize: UILabel!

    
    @IBOutlet weak var rank_1: UILabel!
    @IBOutlet weak var player_1: UILabel!
    @IBOutlet weak var correct_1: UILabel!
    @IBOutlet weak var time_1: UILabel!
    @IBOutlet weak var score_1: UILabel!
    @IBOutlet weak var avatar_1: UIImageView!
    @IBOutlet weak var avatarView_1: UIView!


    @IBOutlet weak var rank_2: UILabel!
    @IBOutlet weak var player_2: UILabel!
    @IBOutlet weak var correct_2: UILabel!
    @IBOutlet weak var time_2: UILabel!
    @IBOutlet weak var score_2: UILabel!
    @IBOutlet weak var avatar_2: UIImageView!
    @IBOutlet weak var avatarView_2: UIView!

    
    @IBOutlet weak var rank_3: UILabel!
    @IBOutlet weak var player_3: UILabel!
    @IBOutlet weak var correct_3: UILabel!
    @IBOutlet weak var time_3: UILabel!
    @IBOutlet weak var score_3: UILabel!
    @IBOutlet weak var avatar_3: UIImageView!
    @IBOutlet weak var avatarView_3: UIView!

    
    @IBOutlet weak var rank_4: UILabel!
    @IBOutlet weak var player_4: UILabel!
    @IBOutlet weak var correct_4: UILabel!
    @IBOutlet weak var time_4: UILabel!
    @IBOutlet weak var score_4: UILabel!
    @IBOutlet weak var avatar_4: UIImageView!
    @IBOutlet weak var avatarView_4: UIView!

    //practice
    @IBOutlet weak var practiceScreen: UIView!
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("did deinit game over screen")
    }

    let strokeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : kMainScreenLeaderboardFillColor,
        NSStrokeWidthAttributeName : -2.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupFirstScreen()
        if tournament.isPractice {
            setupPracticeScreen()
            tenScreen.hidden = true
        } else {
            setupTenScreen()
            practiceScreen.hidden = true
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameOverViewController.refresh), name: gStackFetchTournamentLeaderboardName, object: nil)
        
    }
    
    func refresh() {
        
        if let lb = gStackCacheDataManager.sharedInstance.getLeaderboard(tournament){
            self.leaderboard = lb
        }
    }
    
    func setupFirstScreen() {
        
        avatarGIF.image = UIImage.gifWithName("Win-BlueMonster")
        let text = "\(numOfCorrect)/\(numOfQuestion) CORRECT !"

        correctNum.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
        
    }
    
    func setupTenScreen(){
        tournamentName.attributedText = NSAttributedString(string: tournament.name!, attributes:strokeTextAttributes)
        title_rank.attributedText = NSAttributedString(string: "RANK", attributes: strokeTextAttributes)
        title_time.attributedText = NSAttributedString(string: "AVG.TIME", attributes: strokeTextAttributes)
        title_prize.attributedText = NSAttributedString(string: "PRIZE", attributes: strokeTextAttributes)
        title_score.attributedText = NSAttributedString(string: "SCORE", attributes: strokeTextAttributes)
        title_player.attributedText = NSAttributedString(string: "PLAYER", attributes: strokeTextAttributes)
        title_correct.attributedText = NSAttributedString(string: "CORRECT", attributes: strokeTextAttributes)
        
    }
    func setupPracticeScreen() {
        
    }

    
    override func viewDidLayoutSubviews() {
        avatarView_1.layer.cornerRadius = avatarView_1.bounds.width / 2
        avatarView_1.layer.borderColor = UIColor.blackColor().CGColor
        avatarView_1.layer.borderWidth = 2
        
        avatarView_2.layer.cornerRadius = avatarView_2.bounds.width / 2
        avatarView_2.layer.borderColor = UIColor.blackColor().CGColor
        avatarView_2.layer.borderWidth = 2
        
        avatarView_3.layer.cornerRadius = avatarView_3.bounds.width / 2
        avatarView_3.layer.borderColor = UIColor.blackColor().CGColor
        avatarView_3.layer.borderWidth = 2
        
        avatarView_4.layer.cornerRadius = avatarView_4.bounds.width / 2
        avatarView_4.layer.borderColor = UIColor.blackColor().CGColor
        avatarView_4.layer.borderWidth = 2
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(animationTime, delay: 0, options: [], animations: {
            self.spinner.transform = CGAffineTransformRotate(self.spinner.transform, CGFloat(M_PI_2))
            }, completion: {
            (true) in
            self.constrain.constant = self.view.bounds.width
        })
        
        UIView.animateWithDuration(1, delay: animationTime + 0.1, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        delay(1.5) {
//            gStackFetchLeaderboardForTournament(self.tournament, completion: { [weak self] (error, leaderboard) in
//                if let strongSelf = self {
//                    strongSelf.leaderboard = leaderboard
//                }
//            })
            gStackCacheDataManager.sharedInstance.getLeaderboard(self.tournament)
        }
        

    }
    
    
    func addLeadersInTenScreen() {
        
        if let lead = leaderboard where lead.rank != -1{

            let leaders = lead.leaders
            
            switch leaders.count {
            case 0:
                place1.alpha = 0
                place2.alpha = 0
                place3.alpha = 0
            case 1:
                place1.alpha = 1
                place2.alpha = 0
                place3.alpha = 0
                setupLeaderboard(1,rank: lead.rank, leaders: leaders)
            case 2:
                place1.alpha = 1
                place2.alpha = 1
                place3.alpha = 0
                setupLeaderboard(2,rank: lead.rank , leaders: leaders)
            default:
                setupLeaderboard(3,rank: lead.rank , leaders: leaders)
            }
            
        }
        
        
    }
    
    func setupLeaderboard(num:Int, rank: Int, leaders: [gStackTournamentLeader]){

        var isFirstThree = false
        for index in 0 ..< num {
            let leader = leaders[index]
            switch index {
            case 0:
                rank_1.attributedText = NSAttributedString(string: "1.", attributes: strokeTextAttributes)
                player_1.attributedText = NSAttributedString(string: leader.displayName!, attributes: strokeTextAttributes)
                let time = String(leader.correctTime!.doubleValue)
                time_1.attributedText = NSAttributedString(string: time, attributes: strokeTextAttributes)
                let correct = String(leader.correct!.integerValue)
                correct_1.attributedText = NSAttributedString(string: correct, attributes: strokeTextAttributes)
                let score = String(leader.correct!.integerValue)
                score_1.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
            case 1:
                rank_2.attributedText = NSAttributedString(string: "2.", attributes: strokeTextAttributes)
                player_2.attributedText = NSAttributedString(string: leader.displayName!, attributes: strokeTextAttributes)
                let time = String(leader.correctTime!.doubleValue)
                time_2.attributedText = NSAttributedString(string: time, attributes: strokeTextAttributes)
                let correct = String(leader.correct!.integerValue)
                correct_2.attributedText = NSAttributedString(string: correct, attributes: strokeTextAttributes)
                let score = String(leader.correct!.integerValue)
                score_2.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
            case 2:
                rank_3.attributedText = NSAttributedString(string: "3.", attributes: strokeTextAttributes)
                player_3.attributedText = NSAttributedString(string: leader.displayName!, attributes: strokeTextAttributes)
                let time = String(leader.correctTime!.doubleValue)
                time_3.attributedText = NSAttributedString(string: time, attributes: strokeTextAttributes)
                let correct = String(leader.correct!.integerValue)
                correct_3.attributedText = NSAttributedString(string: correct, attributes: strokeTextAttributes)
                let score = String(leader.correct!.integerValue)
                score_3.attributedText = NSAttributedString(string: score, attributes: strokeTextAttributes)
            default:
                break
            }
         
            if let user = triviaCurrentUser {
                if user.displayName == leader.displayName{
                    isFirstThree = true
                }
            }
        }
        
        if isFirstThree {
            place4.alpha = 0
        } else {
            rank_4.attributedText = NSAttributedString(string:"\(String(rank)).", attributes: strokeTextAttributes)
            if let user = triviaCurrentUser {
                player_4.attributedText = NSAttributedString(string:user.displayName!, attributes: strokeTextAttributes)
            } else {
                player_4.attributedText = NSAttributedString(string:"Temp Player" , attributes: strokeTextAttributes)
            }
            time_4.attributedText = NSAttributedString(string: String(totalTime), attributes: strokeTextAttributes)
            correct_4.attributedText = NSAttributedString(string: String(numOfCorrect), attributes: strokeTextAttributes)
            score_4.attributedText = NSAttributedString(string: String(numOfCorrect), attributes: strokeTextAttributes)
        }
    }
    
    // try this
    func getUncachedImage (named name : String) -> UIImage?
    {
        if let imgPath = NSBundle.mainBundle().pathForResource(name, ofType: nil)
        {
            return UIImage(contentsOfFile: imgPath)
        }
        return nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close() {
        performSegueWithIdentifier("unwind", sender: nil)
    }
    
    
    var isAllowRestart = false
    @IBAction func restart() {
        restartDelegate?.restartGame()
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    @IBAction func login() {
        performSegueWithIdentifier("login", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
