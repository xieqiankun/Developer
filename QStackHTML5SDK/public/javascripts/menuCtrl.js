

app.controller('menuCtrl', ['$scope', '$state', '$mdDialog', '$window', 'userState', 'gameState', '$localstorage', 'qStack',  function($scope, $state, $mdDialog, $window, userState, gameState, $localstorage, qStack) {
	$scope.userState = userState;

	userState.update(function(err){
		$scope.displayName  = userState.displayName;
		$scope.userAvatar   = userState.avatar;
		$scope.cashBalance  = userState.cashBalance;
	});
	
	$scope.goToHome = function(){
		$state.go('menu.main');
	};

	$scope.logout = function() {
		qStack.end();
		$window.location.reload();
	};
}]);

app.controller('menuMainCtrl', ['$scope', '$state', '$http', '$mdDialog', 'userState', 'gameState', 'qStack', function($scope, $state, $http, $mdDialog, userState, gameState, qStack) {
	
	var tournaments = [];
	$scope.futureTournaments = [];
	$scope.pastTournaments = [];
	$scope.currentTournaments = [];
	
	function activeText(tournament) {
        	
		var timeDiff = (new Date(tournament.startTime).getTime() - Date.now());
		if(timeDiff < 0){
			timeDiff = (new Date(tournament.stopTime).getTime() - Date.now());
		}
		
		var minutes = Math.floor(timeDiff / 60000);
		var hours = Math.floor(minutes / 60);
		var days = Math.floor(hours / 24);

		hours = hours - (days * 24);
		minutes = minutes - (days * 24 * 60) - (hours * 60);
		return [days, hours, minutes];
	}
	
	function futureText(tournament) {
		var tilStart = (new Date(tournament.startTime).getTime() - Date.now());
		var unit = '';
		if (tilStart < 3600000) {
			tilStart = Math.round(tilStart / 60000);
			unit = 'Mins';
		}
		else if(tilStart < 3600000 * 24){
			tilStart = Math.round(10 * tilStart / 3600000) / 10;
			unit = 'Hours';
		}
		else{
			tilStart = Math.round(10 * tilStart / 3600000 / 24) / 10;
			unit = 'Days';
		}
		var tLength = (new Date(tournament.stopTime).getTime() - new Date(tournament.startTime).getTime());
		var tLengthH = Math.round(tLength / 3600000);
		return {'numbers': [tilStart, tLengthH], 'unit': unit};
	}
	
	function pastText(tournament) {
		var tilStart = (Date.now() - new Date(tournament.stopTime).getTime());
		var unit = '';
		if (tilStart < 3600000) {
			tilStart = Math.round(tilStart / 60000);
			unit = 'Mins';
		}
		else if(tilStart < 3600000 * 24){
			tilStart = Math.round(10 * tilStart / 3600000) / 10;
			unit = 'Hours';
		}
		else{
			tilStart = Math.round(10 * tilStart / 3600000 / 24) / 10;
			unit = 'Days';
		}
		return {'numbers': [tilStart], 'unit': unit};
	}
	
	
	$scope.refresh = function () {
        tournaments = [];
        $scope.futureTournaments = [];
        $scope.pastTournaments = [];
        $scope.currentTournaments = [];


        //this is hard coded, change these values to get local tournaments for that area

        var request = {
            lat: 41.83,  //latitude
            long: -87.68,
            region: "Illinois",
            country: "United States"
        };

        qStack.getInstance().getActiveTournaments(request, function (err, tournaments) {

            if (err) {
                console.log(err);
                $mdDialog.show(
                    $mdDialog.alert()
                        .title('Connection Error')
                        .content('We are unable to load tournaments. Please check your internet connection and try again.')
                        .ok('OK')
                );
            } else {
                console.log('getting those tournaments');
                console.log(tournaments);

                for (var i = 0; i < tournaments.length; i++) {
                    var o = tournaments[i];
                    if (new Date(o.stopTime).getTime() < Date.now()) {
                        o['pastText'] = pastText(o);
                        $scope.pastTournaments.push(o);
                    }
                    else if (new Date(o.startTime).getTime() > Date.now()) {
                        o['futureText'] = futureText(o);
                        $scope.futureTournaments.push(o);
                    }
                    else {
                        o['activeText'] = activeText(o);
                        $scope.currentTournaments.push(o);
                    }
                }
            }

            $scope.$digest();
            $scope.checkSplashTournament();
        });
    };
    
    $scope.checkSplashTournament = function() {
    	if(userState.splashTournament){
			for(var i = 0; i < $scope.currentTournaments.length; i++){
				if($scope.currentTournaments[i].uuid == userState.splashTournament){
					userState.splashTournament = null;
					$scope.startTournament($scope.currentTournaments[i]);
					break;
				}
			}
    	}
    };

	$scope.hiScoreData = [];
	$scope.detailTourn = {};
	
	$scope.fetchLeaderboard = function (selectedTournament, ev) {
		$scope.detailTourn = JSON.parse(JSON.stringify(selectedTournament));
		var prizes = [];
		var len = $scope.detailTourn.prizes.length;


        if(len > 0){
            var temp = $scope.detailTourn.prizes[0];
            temp['first'] = 1;
            for (var i = 1; i < len; ++i) {
                if (temp.name !== $scope.detailTourn.prizes[i].name) {
                    temp['last'] = i;
                    prizes.push(temp);
                    temp = $scope.detailTourn.prizes[i];
                    temp['first'] = i + 1;
                }
            }
            temp['last'] = len;
            prizes.push(temp);
        }

		$scope.detailTourn.prizesNew = prizes;

        //Gets the leaderboard, num is the max size of leaderboard
        var request = {uuid: selectedTournament.uuid, num: 100};

        qStack.getInstance().getLeaderboard(request, function(err, leaderboard){
            if(err){
                $mdDialog.show(
                    $mdDialog.alert()
                        .title('Connection Error')
                        .content('We are unable to load leaderboard. Please check your internet connection and try again.')
                        .ok('OK')
                );
            }

            $scope.hiScoreData = leaderboard;

            for (var i = 0; i < $scope.hiScoreData.length; ++i) {
                $scope.hiScoreData[i].rank = i + 1;
                $scope.hiScoreData[i].correctTime = $scope.hiScoreData[i].correctTime / (1000 * $scope.hiScoreData[i]['numCorrect']);
            }

            $mdDialog.show({
                templateUrl: '/partials/leaderboard.html',
                parent: angular.element(document.body),
                targetEvent: ev,
                scope: $scope,
                preserveScope: true,
                clickOutsideToClose: true
            });
        });
	};
	
	$scope.closeLeaderboardPopup = function() {
        $mdDialog.hide(); 
    };
	
	$scope.ordinal = function (placeNum) {
		var div = placeNum / 10;
		if (div != 1) {
			if (placeNum % 10 === 1) {
				return "st";
			}
			if (placeNum % 10 === 2) {
				return "nd";
			}
			if (placeNum % 10 === 3) {
				return "rd";
			}
		}
		return "th";
	};
	
	$scope.startTournament = function (selectedTournament, ev) {
		if(selectedTournament.buyin && (selectedTournament.buyin > userState.balance)){
			var confirm = $mdDialog.confirm()
				.title('Not Enough Balance')
				.content('You do not have enough balance to pay the entry fee of this tournament. Please deposit.')
				.ariaLabel('Not Enough Balance')
				.ok('OK')
				.cancel('Cancel')
				.targetEvent(ev);
			$mdDialog.show(confirm).then(function() {
				$state.go('menu.deposit');
			}, function() {
			});
			return;
		}
		
		gameState.tournamentPlaying = selectedTournament;
		
		gameState.gameMode = {
			type: 'tournament',
			category: '',
			wager: 0,
			asyncChallenge: null
		};
		gameState.team = [];
		
		gameState.gameMode.uuid     = selectedTournament.uuid;
		gameState.gameMode.zone     = selectedTournament.questions.zone;
		gameState.gameMode.category = selectedTournament.questions.category;
		$state.go('gameWait');
	};

	$scope.goToChallenge = function () {
		$state.go('menu.challenge');
	};

	$scope.myName = userState.displayName;

    //refresh the tournaments
    $scope.refresh();
}]);


app.controller('menuResultCtrl', ['$scope', '$state', 'userState', 'gameState', function($scope, $state, userState, gameState) {

    $scope.winOrLose = '';
    $scope.selectedMessage = {};
    $scope.gameType = gameState.gameMode.type;

    $scope.goHome = function(){
        $state.go('menu.main');
    };

    $scope.getStats = function (message, teamNum) {
        var numOfCorrect = 0;
        var averageTime = 0;
        for(var i = 0; i < message.teamScores[teamNum].length; i++){
            if(message.teamScores[teamNum][i] > 0){
                numOfCorrect ++;
                averageTime += message.teamAnswersTime[teamNum][i];
            }
        }

        if(numOfCorrect > 0){
            averageTime = averageTime/numOfCorrect;
        }

        return {
            numOfCorrect: numOfCorrect,
            averageTime: (averageTime / 1000).toFixed(2)
        };
    };

    if(gameState.gameMode.type === 'tournament'){
        $scope.selectedMessage = gameState.gameResult;
        $scope.selectedMessage.sender = userState.displayName;
        $scope.selectedMessage.teamAvatars = [[userState.avatar], []];
        $scope.winOrLose = gameState.tournamentPlaying.name;
    }

}]);
