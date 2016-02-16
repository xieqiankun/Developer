/**
 * This is the game play controller, probably the most improtant controller for those looking to create a trivia game with this
 * SDK.  Here we show how to set up a callback handler to handle all incoming messages from our game server
 */

app.controller('gamePlayCtrl', ['$scope', '$state', '$interval', '$timeout', '$http', 'userState', 'gameState', 'qStack',
function ($scope, $state, $interval, $timeout, $http, userState, gameState, qStack) {
	
	if(gameState.tournamentPlaying.style == "shootout"){
		$scope.showBracket = true;
	}
	$scope.timerBar = 0;
	$scope.timerClock = '';
	$scope.questionNum = -1;
	$scope.question = ' ';
	$scope.answers = [];
	$scope.buttonStyles = [];
	$scope.gameLength = 0;
	$scope.questionNumTransition = '';
	$scope.roundText = '';

	$scope.showTransition = false;
	$scope.showQuestion = false;
	$scope.showAnswers = false;
	
	
	var timeout = null;
	var timeout2 = null;
	var buttonEffectTimeout = null;
	var inAnsweringWindow = false;
	var gameLength = -1;

	$scope.teamNames = [];
    $scope.teamAvatars = [];
    $scope.teamScores = null;
    $scope.teamScoreSum = [];
    $scope.teamProgress = [0];
    $scope.numberOfCorrect = 0;
    $scope.totalTime = 0;
    $scope.myName = userState.displayName;
    $scope.myAvatar = userState.avatar;
    $scope.teamAlive = [];
    $scope.round2TeamNames = ["TBD", "TBD", "TBD", "TBD"];
    $scope.round2TeamAvatars = ["imgs/random.png", "imgs/random.png", "imgs/random.png", "imgs/random.png"];
    $scope.round2TeamAlive = [0, 0, 0, 0];
    $scope.round3TeamNames = ["TBD", "TBD"];
    $scope.round3TeamAvatars = ["imgs/random.png", "imgs/random.png"];
    $scope.round3TeamAlive = [0, 0];
    

    //removes the special characters from the question
	var dbParse = function (s) {
		return s.split("<q>").join('"').split("<s>").join("'");
	};


    /**
     * This is the most important part of the qStack, handling the incoming trivia events, every major event is handled, and the appropriate
     * UI element is updated and changed.
     *
     * Pay careful attention to that everything is an array.  This is by design so there is a chance for teams of various sizes
     * playing other teams of various sizes in
     *
     * @param data the data coming off the socket connection through the qStack API
     */
    var eventHandler = function(data){

        console.log("Incoming data from socket");
        console.log(JSON.stringify(data));

        if (data === 'Socket Authentication Expired'){
            //An error that should never happen with an authenticated version of the qStack API
           // console.log("Exception that shouldn't happen");
            $state.go('menu.main');
        }
        else if (data.type === 'gameError') {
            //A generic game error that only happens when the game server has lost connection to the qStack API
           // console.log("Game Error");
            $state.go('menu.main');
        }else if (data.type === 'startRound'){
            console.log("Round " + data.payload.round + " is about to start");
            $scope.questionNum = -1;  // reset the question num
            $scope.numberOfCorrect = 0;
            $scope.totalTime = 0;
            
            $scope.roundText = 'Round ' + data.payload.round;

            //this is your team num for this round
            gameState.teamNum = data.payload.teamNum;

        }else if (data.type === 'roundResult'){
            //the round we check to see if we won otherwise we have lost and

            if(data.payload.win){
                console.log('you won this round!');
            }else{
                console.log('you lost :(');
            }
        }
        else if (data.type === 'sendPlayerInfo') {
            //gets the names and avatars of ever user that is in this game, in this example it is just one player
            //and one avatar, but this can expand to x number of users
            $scope.teamNames = data.payload.teamNames;
            $scope.teamAvatars = data.payload.teamAvatars;
            for (var i = 0; i < $scope.teamNames.length; i++) {
                $scope.teamScoreSum.push(0);
            }
        }
        else if (data.type === 'otherGameFinished'){
            console.log('there are ' + data.payload.gamesRemaining + " left in this round");
            $scope.teamAlive = data.alive;
            
            for(var i = 0; i < $scope.teamAlive.length; i = i + 2){
            	if($scope.teamAlive[i] + $scope.teamAlive[i + 1] == 1){
            		var num = 0;
            		if ($scope.teamAlive[i + 1] == 1){
            			num = 1;
            		}
            		$scope.round2TeamNames[i/2] = $scope.teamNames[i + num][0];
            		$scope.round2TeamAvatars[i/2] = $scope.teamAvatars[i + num][0];
            		$scope.round2TeamAlive[i/2] = 1;
            	}
            	else{
            		$scope.round2TeamAlive[i/2] = 0;
            	}
            }
            for(var i = 0; i < $scope.teamAlive.length; i = i + 4){
            	if($scope.teamAlive[i] + $scope.teamAlive[i + 1] + $scope.teamAlive[i + 2]+ $scope.teamAlive[i + 3] == 1){
            		var num = 0;
            		if ($scope.teamAlive[i + 1] == 1){
            			num = 1;
            		}
            		else if($scope.teamAlive[i + 2] == 1){
            			num = 2;
            		}
            		else if($scope.teamAlive[i + 3] == 1){
            			num = 3;
            		}
            		$scope.round3TeamNames[i/4] = $scope.teamNames[i + num][0];
            		$scope.round3TeamAvatars[i/4] = $scope.teamAvatars[i + num][0];
            		$scope.round3TeamAlive[i/4] = 1;
            	}
            	else{
            		$scope.round3TeamAlive[i/4] = 0;
            	}
            }
        }
        else if (data.type === 'sendQuestion' && data.payload.questionNum > $scope.questionNum) {

            //This is when we receive the question from the server, the conditionals at the top verify that the
            //questions are coming in the right order

            $scope.buttonStyles = [];
            $scope.showTransition = true;

            gameLength = data.payload.gameLength;
            $scope.gameLength = gameLength;
            $scope.questionNum = data.payload.questionNum;

            //update the scores
            if (!$scope.teamScores) {
                $scope.teamScores = [];
                for (var i = 0; i < $scope.teamNames.length; i++) {
                    var curTeamScores = [];
                    for (var j = 0; j < data.payload.gameLength; j++) {
                        curTeamScores.push(0);
                    }
                    $scope.teamScores.push(curTeamScores);
                }
            }

            //updates the UI to the show the right question number
            if ($scope.questionNum === gameLength - 1) {
                $scope.questionNumTransition = 'Last Question';
            }
            else {
                $scope.questionNumTransition = 'Question ' + ($scope.questionNum + 1) + ' of ' + $scope.gameLength;
            }

            //miss the question, update the button
            if (buttonEffectTimeout) {
                $timeout.cancel(buttonEffectTimeout);
                buttonEffectTimeout = null;
            }

            $timeout(function () {
                //between question show and answer show
                $scope.showTransition = false;
            }, 2000);
            $timeout(function () {

                //have to parse the questions and remove our special characters
                $scope.question = dbParse(data.payload.question);
                for (var i = 0; i < data.payload.answers.length; i++) {
                    $scope.answers[i] = dbParse(data.payload.answers[i]);
                    $scope.buttonStyles[i] = '';
                }
                $scope.buttonStyles = [];
                $scope.showQuestion = true;
            }, 2500);
            timeout2 = $timeout(function () {
                inAnsweringWindow = true;
                $scope.showAnswers = true;

                //Update game clock
                var howManySeconds = Math.floor(data.payload.timer / 1000);
                $scope.timerClock = howManySeconds;
                timerStep = 100 / howManySeconds;
                $scope.timerBar = 100;
                timeout = $interval(function () {
                    $scope.timerBar -= timerStep;
                    $scope.timerClock--;
                }, 1000, howManySeconds);
            }, 4000);

        }
        else if (data.type === 'updateScore' && data.payload.questionNum == $scope.questionNum) {

            //update the scores
            $scope.teamScores = data.payload.teamScores;

            for (var i = 0; i < $scope.teamScores.length; i++) {
                var sum = 0;
                for (var j = 0; j < $scope.teamScores[i].length; j++) {
                    sum += $scope.teamScores[i][j];
                }
                $scope.teamScoreSum[i] = Math.round(sum);
            }

            //check to see if we are answering, this will always be true in this example, but for multiple teams
            //it you would update their scores differently

            if (data.payload.teamNum === gameState.teamNum) {
                inAnsweringWindow = false;

                if (data.payload.rightOrWrong === true) {
                    $scope.buttonStyles[data.payload.answerNumber] = 'btn-right animated pulse';
                    $scope.numberOfCorrect++;
                    $scope.totalTime += data.payload.teamAnswersTime[0][data.payload.questionNum];
                }
                else {
                    $scope.buttonStyles[data.payload.answerNumber] = 'btn-wrong animated pulse';
                }
            }
        }
        else if (data.type === 'correctAnswer' && data.payload.questionNum == $scope.questionNum) {
            //question is now over and we show it on the UI

            $interval.cancel(timeout);
            $scope.timerBar = 0;
            $scope.timerClock = '';
            $scope.teamProgress[0] = Math.round(($scope.questionNum + 1) * 100 / gameLength );

            inAnsweringWindow = false;
            if ($scope.teamScores[gameState.teamNum][$scope.questionNum] === 0) {
                $scope.buttonStyles[data.payload.correctAnswer] = 'btn-right';
            }

            buttonEffectTimeout = $timeout(function () {
                $scope.showQuestion = false;
                $scope.showAnswers = false;
                $scope.buttonStyles = [];
            }, 2200);

        }
        else if (data.type === 'gameResult') {

            //the game is finished, and we can play again now!
            $interval.cancel(timeout);
            $timeout.cancel(timeout2);

            $scope.timerBar = 0;
            $scope.timerClock = '';

            $scope.showQuestion = false;
            $scope.showAnswers = false;
            
            if($scope.teamAlive[0] + $scope.teamAlive[1] + $scope.teamAlive[2] + $scope.teamAlive[3] == 1){
            	$scope.round3TeamAlive[1] = 0;
            	$scope.round2TeamAlive[2] = 0;
            	$scope.round2TeamAlive[3] = 0;
            	$scope.teamAlive[4] = 0;
            	$scope.teamAlive[5] = 0;
            	$scope.teamAlive[6] = 0;
            	$scope.teamAlive[7] = 0;
            }
            else{
            	$scope.round3TeamAlive[0] = 0;
            	$scope.round2TeamAlive[0] = 0;
            	$scope.round2TeamAlive[1] = 0;
            	$scope.teamAlive[0] = 0;
            	$scope.teamAlive[1] = 0;
            	$scope.teamAlive[2] = 0;
            	$scope.teamAlive[3] = 0;
            }
            
            $scope.roundText = "Winner";
            gameState.gameResult = data.payload;
            $timeout(function () {
                $state.go('menu.gameResult');
            }, 4000);
        }else{

            console.log('--unhandled message---');

        }
        $scope.$digest();
    };


    /**
     * This is the entry point to starting a game, this is where the qStack tells the servers that we are
     * ready for some trivia questions!
     */
    qStack.getInstance().setGameHandler(eventHandler);

	var preventTooManyClicks = false;

    /**
     * Function to handle the
     * @param answerNum
     */
    $scope.submitAnswer = function (answerNum) {
		if (inAnsweringWindow === true) {
			if (!preventTooManyClicks) {
                var request = {
                    'questionNum'   : $scope.questionNum,
                    'answer'        : answerNum,
                    'time'          : Date.now()
                };

                qStack.getInstance().submitAnswer(request);

				preventTooManyClicks = true;
				$timeout(function () {
					preventTooManyClicks = false;
				}, 800)
			}
		}
	};

	$scope.$on('$destroy', function () {
		$interval.cancel(timeout);
		$timeout.cancel(timeout2);
		qStack.getInstance().endGame();
	});
}]);
