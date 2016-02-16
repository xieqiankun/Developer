app.controller('waitCtrl', ['$scope', '$state', '$http', '$timeout', '$mdDialog', 'userState', 'gameState', 'qStack',
function ($scope, $state, $http, $timeout, $mdDialog, userState, gameState, qStack) {
	
	$scope.message = '';
	
	
	$scope.goBack = function () {
        $state.go('menu.main');
    };
		
	var expirationTimeout = null;

    $scope.sendRequest = function () {

        expirationTimeout = $timeout(function () {
            $scope.message = 'Tournament expired.';
            $timeout($scope.goBack, 2000);

        }, 20000);

        var gameRequest = {
            team: gameState.team,
            gameMode: gameState.gameMode
        };

        //callback when game is ready to start
        var callback = function () {
            $state.go('gamePlay.tournament');
        };

        console.log(gameRequest);

        qStack.startGame(gameRequest, callback, function (err) {
            if (err) {
                $timeout.cancel(expirationTimeout);
                $mdDialog.show(
                    $mdDialog.alert()
                        .title('Game Start Error')
                        .content(err)
                        .ok('OK')
                ).then(function () {
                        $scope.goBack();
                    });
            }
        });

    }


	$scope.$on(userState.channel + ':newGameSuccess', function (event, data) {
		
		$timeout.cancel(expirationTimeout);
		
		gameState.serverIp      = data.serverIp;
		gameState.serverPort    = data.serverPort;
		gameState.token         = data.token;
		gameState.teamNum       = data.teamNum;
		gameState.playerNum     = data.playerNum;
		
		if (gameState.gameMode.type === 'async') {
			$state.go('gamePlay.async');
		}
		else if (gameState.gameMode.type === 'asyncResponse') {
			$state.go('gamePlay.asyncResponse');
		}
		else if (gameState.gameMode.type === 'tournament') {

		}
		else {
			$scope.goBack();
		}
	});

	$scope.sendRequest();

	$scope.$on('$destroy', function () {
		$timeout.cancel(expirationTimeout);
	});

}]);