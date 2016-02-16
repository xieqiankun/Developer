
var app = angular.module('qStack SDK', ['ui.router', 'ngMaterial', 'angularMoment']);


app.config(['$stateProvider', '$urlRouterProvider', '$compileProvider',
function($stateProvider, $urlRouterProvider, $compileProvider){
	$compileProvider.debugInfoEnabled(false);
	
	
	$urlRouterProvider.otherwise('/');


    //we start with the splash screen using the / url.

	$stateProvider
		.state('splash', {
			url: '/',
			templateUrl: 'partials/splash.html',
			controller: 'splashCtrl'
		})
		.state('init', {
			templateUrl: 'partials/init.html',
			controller: 'initCtrl'
		})
		.state('menu', {
			templateUrl: 'partials/menu.html',
			controller: 'menuCtrl',
			abstract: true
		})
		.state('menu.main', {
			views: {
                'menuContent': {
                    'templateUrl': 'partials/menuMain.html',
                    'controller': 'menuMainCtrl'
                }
            }
		})
        .state('menu.profile', {
            views: {
                'menuContent': {
                    'templateUrl': 'partials/menuProfile.html',
                    'controller': 'menuProfileCtrl'
                }
            }
        })
        .state('menu.feedback', {
            views: {
                'menuContent': {
                    'templateUrl': 'partials/menuFeedback.html',
                    'controller': 'menuFeedbackCtrl'
                }
            }
        })
        .state('menu.gameResult', {
            views: {
                'menuContent': {
                    'templateUrl': 'partials/menuGameResult.html',
                    'controller': 'menuResultCtrl'
                }
            }
        })
        .state('gameWait', {
            templateUrl: 'partials/gameWait.html',
            controller: 'waitCtrl'
        })
        .state('gamePlay', {
			templateUrl: 'partials/gamePlay.html',
			controller: 'gamePlayCtrl',
			abstract: true
		})
		.state('gamePlay.tournament', {
            templateUrl: 'partials/gamePlayAsync.html'
        })
}]);




