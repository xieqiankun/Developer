/**
 * Controller that just goes to the main menu
 */
app.controller('setup', ['$scope', '$state', '$mdToast', 'qStack', function($scope, $state, $mdToast, qStack){
    $state.go('menu.main');
}]);


/**
 * The splash screen controller, although no longer a splash screen we grab the tournaments using the qStack so even someone
 * that is not registered or signed in can see what the game is like
 */
app.controller('splashCtrl', ['$scope', '$state', '$http', '$mdDialog', '$mdToast', '$localstorage', 'userState', 'qStack', function($scope, $state, $http, $mdDialog, $mdToast, $localstorage, userState, qStack) {
	
	/*

	This controller connects to the qStack and displays the 3 different types of tournaments
	future, past, and current

	 */

    var tournaments = [];
	$scope.futureTournaments = [];
	$scope.pastTournaments = [];
	$scope.currentTournaments = [];



    //This is where you would connect to the qStack, the first thing you do in your app, or at the minimum
    //a second before you need it because it requires a few handshakes for security reasons
    $scope.qStackRegistration =  function(callback) {
        qStack.connect(function (err, qStackInstance) {
            if (err) {
                console.log(err);
                console.log("Error connecting to qStack");
            } else {
                //we have an active qStack instance, we can get tournaments, leaderboards, start games, and much, much more that
                //is not showcased in the SDK.  For more available features, contact james@purplegator.net
                console.log('connected to the qStack');
                if(callback){
                    callback();
                }
            }
        });
    };


    //just fixing the text for display
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


    /**
     * Refreshes the tournaments from the qStack
     */
	$scope.refresh = function () {
		tournaments = [];
		$scope.futureTournaments = [];
		$scope.pastTournaments = [];
		$scope.currentTournaments = [];


        var request = {
            lat: 41.83,  //latitude
            long: -87.68,
            region: "Illinois",
            country: "United States"
        };

        /**
         * The call to the qStack to get your tournaments
         */
		qStack.getInstance().getActiveTournaments(request, function(err, tournaments){

            if(err){
                console.log(err);
            }else {


                console.log('i am here with tournaments!!!');
                console.log(tournaments);
                //the tournaments are returned as an array.  If you would like a full Schema of the tournament objects
                //you may email me at james@purplegator.net and I can get you a JSON datagram.
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

            //out of scope for angular so we force the update
            $scope.$digest();
        });
    };

    //check to see if we have already have a
    if($scope.qStack){
        $scope.refresh();
    }else{
        $scope.qStackRegistration(function(){
            $scope.refresh();
        })
    }

	$scope.hiScoreData = [];
	$scope.detailTourn = {};


    /**
     * Gets the leaderboard for the selected tournament
     *
     * @param selectedTournament the selected tournament
     * @param ev the targeted event for the dialog
     */
	$scope.fetchLeaderboard = function (selectedTournament, ev) {
		$scope.detailTourn = JSON.parse(JSON.stringify(selectedTournament));


        var prizes = [];
		var len = $scope.detailTourn.prizes.length;
		var temp = $scope.detailTourn.prizes[0];

        if(temp != null || typeof temp != "undefined"){

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
            $scope.detailTourn.prizesNew = prizes;
        }


        //request the leaderboard using qStack
        var request = {
            uuid    : selectedTournament.uuid,
            num     : 100  //the max size of the leaderboard, can be up to 5000, but we don't recommend anything more than 500
        };

        qStack.getInstance().getLeaderboard(request, function(err, leaderboard){
            if(err){
                $mdDialog.show(
                    $mdDialog.alert()
                        .title('Connection Error')
                        .content('We are unable to load leaderboard. Please check your internet connection and try again.')
                        .ok('OK')
                );

            }else{
                //give angular the leaderboard
                $scope.hiScoreData = leaderboard;

                for (var i = 0; i < $scope.hiScoreData.length; ++i) {
                    $scope.hiScoreData[i].rank = i + 1;
                    $scope.hiScoreData[i].correctTime = $scope.hiScoreData[i].correctTime / (1000 * $scope.hiScoreData[i]['numCorrect']);
                }
                //show the leaderboard
                $mdDialog.show({
                    templateUrl: '/partials/leaderboard.html',
                    parent: angular.element(document.body),
                    targetEvent: ev,
                    scope: $scope,
                    preserveScope: true,
                    clickOutsideToClose: true
                });
            }
        });
	};
	
	$scope.closeLeaderboardPopup = function() {
        $mdDialog.hide(); 
    };

    /**
     * To correctly display the place numbers, good for a while, needs to be expanded
     * @param placeNum  the place
     * @returns {string} return
     */
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

    /**
     *
     * @param loginOrSignUp
     */
	$scope.goToSignIn = function(loginOrSignUp) {
		userState.loginOrSignUp = loginOrSignUp;
		$state.go('init');	
	};
	
	$scope.startTournament = function(tournamentId, loginOrSignUp){
		userState.splashTournament = tournamentId;
		$scope.goToSignIn(loginOrSignUp);
	};
    
    var initialize = function () {
		$mdToast.show(
			$mdToast.simple()
			.content('Logging On')
			.position('top right')
		);
		
		userState.update(function(err){
			if(err){
			}
			else{
				$mdToast.hide();
				$state.go('menu.main');
			}
		});
    };
}]);



app.controller('initCtrl', ['$scope', '$state', '$http', '$mdDialog', '$mdToast', '$localstorage', 'userState', 'qStack', function($scope, $state, $http, $mdDialog, $mdToast, $localstorage, userState, qStack) {
	
	$scope.loginOrSignUp = userState.loginOrSignUp;
	
	$scope.userInput = {
        displayName: '',
        email: '',
        emailConfirm: '',
        password: '',
        passwordConfirm: '',
        validate: '',
        referralCode: ''
    };

    $scope.avatars = userState.avatarList;
    $scope.selectedAvatarNumber = Math.floor(Math.random() * $scope.avatars.length);
    
    $scope.showAvatarPopup = function(ev){
    	$mdDialog.show({
    		templateUrl: '/partials/changeAvatar.html',
    		parent: angular.element(document.body),
    		targetEvent: ev,
    		scope: $scope,
    		preserveScope: true
    	});
    };
    $scope.userSelectAvatar = function (num) {
        $scope.selectedAvatarNumber = num;
        $mdDialog.cancel();
    };
    $scope.closeAvatarPopup = function() {
        $mdDialog.hide(); 
    };
    $scope.cancelAvatarPopup = function() {
    	$mdDialog.cancel();
    };

    var initialize = function () {
        $mdToast.show(
            $mdToast.simple()
                .content('Logging On')
                .position('top right')
        );


        console.log('intializing');
        userState.update(function(){
            $mdToast.hide();
            $state.go('menu.main');
        });

    };

	$scope.userLogin = function () {

        console.log('user logging in');
        initialize();

        //Set User Games
        userState.displayName = $scope.userInput.email;
        qStack.getInstance().setUserInformation({displayName : userState.displayName, avatar : userState.avatar})

    };
}]);






