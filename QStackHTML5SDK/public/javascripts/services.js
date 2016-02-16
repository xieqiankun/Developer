app.factory('userState', ['$http', function ($http) {
	
	var avatarList = [
        'imgs/b1.png',
        'imgs/b2.png',
        'imgs/b3.png',
        'imgs/b4.png',
        'imgs/b5.png',
        'imgs/b6.png',
        'imgs/b7.png',
        'imgs/b8.png',
        'imgs/b9.png',
        'imgs/b10.png',
        'imgs/b11.png',
        'imgs/b12.png',
        'imgs/b13.png',
        'imgs/b14.png',
        'imgs/b15.png',
        'imgs/b16.png',
        'imgs/b17.png',
        'imgs/b18.png',
        'imgs/b19.png',
        'imgs/b20.png',
        'imgs/b21.png'
    ];
	
    return {
    	avatarList: avatarList,
    	loginOrSignUp: 0,
        _id: '',
        displayName: '',
        channel: '',
        avatar: avatarList[Math.floor(Math.random()*avatarList.length)],
        cashBalance: -1,
        splashTournament: null,

        update: function (callback) {
        	var userState = this;

            //This is where to update your user information database

            callback(null);
        }
        
    };
}]);


app.factory('gameState', function () {
    return {
        team: [],
        gameMode: {
            type: '',
            uuid: '',
            zone: '',
            category: '',
            asyncChallenge: ''
        },

        serverIp: '',
        serverPort: 0,
        token: '',
        teamNum: 0,
        playerNum: 0,
        
        tournamentPlaying: {},
        firstHalfGame: {},
		gameResult: {},
		
		
        signedOnElsewhere: false
    };
});


app.factory('qStack', ["$rootScope", "userState", function($rootScope, userState){
    var qStack = null;

    var appId       = 308189542;
    var publicKey   = "/o3I3goKCQ==";

    //this factory connects to the qStack API
    return {
        connect : function(callback){

            //appId and appKey are required
            var connectionOptions = {
                appId       : appId,
                appKey      : publicKey,
                gameName    : "Ruby Seven Trivia"
            };

            qStack = new QStack(connectionOptions);
            qStack.register(function(err){
                console.log('connected to the qStack');
                callback(err, qStack);
            });
        },
        startGame : function(gameRequest, gameCallback, callback){
            qStack.startGame(gameRequest, gameCallback, callback)  ;
        },
        getInstance : function(){

            if(!qStack){
                console.log('qStack not initiated');
            }

            return qStack;
        }
    }
}]);


app.factory('$localstorage', ['$window', function ($window) {
    return {
        set: function (key, value) {
            $window.localStorage.setItem(key, value);
        },
        get: function (key) {
            return $window.localStorage.getItem(key);
        },
        remove: function (key) {
            $window.localStorage.removeItem(key);
        },
        setObject: function (key, value) {
            $window.localStorage[key] = JSON.stringify(value);
        },
        getObject: function (key) {
            var r = $window.localStorage[key];
            if (r) {
                return JSON.parse(r);
            }
            else {
                return null;
            }
        }
    }
}]);




