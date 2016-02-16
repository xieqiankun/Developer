/**
 * Created by PurpleGatorLaptop2 on 8/10/15.
 */

function QStack(req) {

    this.serverURL      = "http://UserServerLB-672243361.us-west-2.elb.amazonaws.com";
    //this.serverURL      = "http://localhost:3000";
    this.appKey         = null;
    this.authToken      = null;
    this.gameName       = null;
    this.appId          = null;
    this.game           = null;
    this.displayName    = null;
    this.avatar         = null;

    this.openRoute = '/qstack';
    this.authRoute = '/qstacks';

    this.gameStartCallback = null;

    this.events = ['newGameSuccess', 'newGameFail', 'teamFormationSuccess', 'teamFormationFail',
        'teamInvite', 'pusher:member_added', 'friendRequestAccepted', 'unfriended', 'newInboxReceived', 'friendRequestReceived'];

    this.callbacks = {};

    if (!req.appKey || !req.appId) {
        console.log('missing all requirements for qStack initiation');
    }
    if (req.appId) {
        this.appId = req.appId;
    }
    if (req.appKey) {
        this.appKey = req.appKey;
    }

    this.isInitalized = this.appKey && this.appId;

    this.pusher = null;
    this.authorization = {};
    this.authToken = "none";
}

QStack.prototype.setUserInformation = function(req){

    console.log('setting information');
    console.log(req);
    if(req.avatar){
        this.avatar = req.avatar;
    }

    if(req.displayName){
        this.displayName = req.displayName
    }


}

/**
 * returns back whether the qStack object has been initalized
 * @returns {boolean|*}
 */
QStack.prototype.isInitialized = function () {
    return this.isInitalized;
};

/***
 * This method registers the qStack instance to the qStack server for authorization
 * It returns the chat channel, various game modes and auth tokens
 *
 * @param callback
 */
QStack.prototype.register = function (callback) {
    var details = {
        route       : '/register',
        type        : 'apiRegister',
        failType    : 'apiRegisterFail',
        successType : 'apiRegisterSuccess'
    };

    var message = {
        private : false,
        payload: {appId: this.appId, appKey: this.appKey}
    };

    var qStack = this;  //closure captured variable

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in request');
            console.log(err);
            return callback("Unable to connect to qStack");
        }

        qStack.authToken        = response.payload.token;
        qStack.channel          = response.payload.channel;
        qStack.authorization    = response.payload.authorization;

        console.log('channel = ' + qStack.channel);
        qStack.pusher = new QStackPusher();

        qStack.pusher.connect(qStack.appId, qStack.channel, "None Yet");
        qStack.pusher.subscribe(qStack.channel, qStack.events, function (err) {
            console.log('registered pusher');
            callback(err);
        });
    });
};

/**
 * Sets the location of the user to the server
 * @param location
 */
QStack.prototype.setLocation = function (location) {
    if (location.lat && location.long) {
        this.location   = location;
        this.region     = location.region;
        this.country    = location.region;
    }

    var details = {
        route   : '/location',
        type    : 'setUserLoc',
        failType : 'setUserLocFail',
        successType : 'setUserLocSuccess'
    };

    var payload = {
        region  : req.region,
        country : req.country,
        lat     : req.lat,
        long    : req.long
    };

    var message = {
        payload: payload,
        private: true
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.payload);
    });
};

/**
 * This sends a game request message to the qStack server, success means we wait for a message
 * to tell us which game server to connect to
 * @param req - contains game Mode object
 * @param callback
 */
QStack.prototype.startGame = function (req, gameStartCallback, callback) {
    if (!this.authToken) {
        callback(new Error(1, "Not Authorized, please register qStack Instance"));
    }

    this.gameStartCallback = gameStartCallback;

    var details = {
        route   : '/startgame',
        type    : 'clientStartGame',
        failType : 'startGameFail',
        successType : 'startGameSuccess'
    };

    var message = {
        payload: {gameMode : req.gameMode},
        private: true
    };

    if(req.gameMode != "versus"){
        message.payload.teams = [{displayName : this.displayName, channel : this.channel, avatar : this.avatar}];
    }

    //closure
    var qStack = this;
    var startCallback = function(data){
        qStack.game = new Game(data.serverIp, data.serverPort, data.token, data.teamNum, data.teamNum, data.playerNum);
        qStack.gameStartCallback();
    };

    var failGameCallback    = function(err, data){
        console.log('game failed to start');
        console.log(err);
        console.log(data);
    };

    this.pusher.addCallback('newGameSuccess', startCallback);
    this.pusher.addCallback('newGameFail', failGameCallback);

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.payload);
    });
};

QStack.prototype.setGameHandler = function(handler){

    if(!this.game){
        console.log('no game has started');
        return;
    }

    this.game.setHandlerAndStart(handler);
}

/**
 * This method gets the various game modes available in this qStack version
 * @param callback
 */
QStack.prototype.getGameModes = function (callback) {
    if (!this.authToken) {
        callback(new Error(1, "Not Authorized, please register qStack Instance"));
    }

    var details = {
        route       : '/getgamemodes',
        type        : 'getModes',
        failType    : 'getModesFail',
        successType : 'getModesSuccess'
    };

    var message = {
        payload: {},
        private: true
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.payload.body);
    });
};

/**
 * This method gets the game ticker that needs to be scrolled by the UI
 * @param callback
 */
QStack.prototype.getGameTicker = function (callback){
    if (!this.authToken) {
        callback(new Error(1, "Not Authorized, please register qStack Instance"));
    }

    var details = {
        route       : '/getPrizeTicker',
        type        : 'getPrizeTicker',
        failType    : 'getPrizeTickerFail',
        successType : 'getPrizeTickerSuccess'
    };

    var message = {
        payload: {},
        private: true
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response);
    });
};

QStack.prototype.loginFacebook = function(req, callback){
    if (!this.authToken) {
        callback(new Error(1, "Not Authorized, please register qStack Instance"));
    }

    var details = {
        route   :   '/loginfacebook',
        type    :   'clientFacebookLogin',
        failType :  'facebookLoginFail'
    };

    var message = {
        payload: {accessToken : req.accessToken, fbId : req.facebookId},
        private: true
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response);
    });
};

QStack.prototype.checkVersion = function(req, callback){
    if (!this.authToken) {
        callback(new Error(1, "Not Authorized, please register qStack Instance"));
    }

    var details = {
        route   :   '/version',
        type    :   'version',
        failType :  'versionFail',
        successType : 'versionSuccess'
    };

    var message = {
        payload: {accessToken : req.accessToken, fbId : req.facebookId},
        private: true
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response);
    });
};

QStack.prototype.getLeaderboard= function (req, callback) {
    if(!req.uuid){
        console.log('no uuid in request');
        callback("no tournament uuid in the request");
    }

    var details = {
        route   :   "/gettournaments",
        type    :   "clientGetTournamentLeaderboard",
        failType :  "getTournamentLeaderboardFail"
    };

    var message = {
        private: true,
        payload: {uuid : req.uuid}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get tournaments request');
            console.log(message);
            console.log(err);
            callback(err);
        }

        console.log('getting a leaderboard');
        console.log(response);


        callback(null, response);

    });
};

QStack.prototype.getPrizeTicker = function(req, callback){
    var details = {
        route       : '/getPrizeTicker',
        type        : "getPrizeTicker",
        failType    : "getPrizeTickerFail",
        successType : "getPrizeTickerSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get leaderboard request');
            console.log(request);
            console.log(err);
        }

        if (response.type === successType) {
            callback(null, response.body);
        } else {
            if (response.type === failType) {
                callback(response.payload.error);
            } else {
                throw new Error(0, "Generic Error");
            }
        }
    });
};

QStack.prototype.getCategories = function (req, callback) {

    var details = {
        route       : "/getcategories",
        type        : "clientGetCategories",
        failType    : "getCategoriesFail",
        successType : "getCategoriesSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getActiveTournaments = function (req, callback) {
    var details = {
        route       : "/gettournaments",
        type        : "clientGetActiveTournaments",
        failType    : "getActiveTournamentsFail",
        successType : "getActiveTournamentsSuccess"
    };

    var message = {
        private: true,
        payload: {location : {long : req.long, lat : req.lat, region : req.region, country : req.country}}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }

        if(response.payload){
            console.log(response.payload.tournaments);
            callback(null, response.payload.tournaments);
        }else{
            callback(null, response);
        }
    });
};

QStack.prototype.getTournaments = function (req, callback) {
    var details = {
        route       : "/gettournaments",
        type        : "getUserTournaments",
        failType    : "getUserTournamentsFail",
        successType : "getUserTournamentsSuccess"
    };

    var message = {
        private: true,
        payload: {location : {long : req.long, lat : req.lat, region : req.region, country : req.country}}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }

        if(response.tournaments){
            callback(null, response.tournaments);
        }else{
            callback(null, response);
        }
    });
};

QStack.prototype.getIAPItems = function (req, callback) {
    var details = {
        route       : "/getpurchaseitems",
        type        : "clientGetItems",
        failType    : "clientGetItemsFail",
        successType : "clientGetItemsSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.signup = function (req, callback) {
    var details = {
        route       : "/signup",
        type        : "clientSignUp",
        failType    : "signUpFail",
        successType : "signUpSuccess"
    };

    if(!req.displayName){
        console.log('no username for signup');
        return callback("Please select a user name");
    };

    if(req.email){
        console.log('no email for signup');
        return callback("No email for signup");
    };

    if(req.password){
        console.log('no password for signup');
        return callback("no password given")
    };

    var payload = {
        referralCode    : req.referralCode,
        displayName     : req.displayName,
        password        : req.password,
        email           : req.email
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.requestResetPassword = function (req, callback) {
    var details = {
        route       : "/reset",
        type        : "clientRequestReset",
        failType    : "resetFail"
    };

    if(!req.email){
        callback('Need email for reset');
        return;
    }

    var message = {
        private: true,
        payload: {email : req.email}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.resetPassword      = function(req, callback){
    var details = {
        route       : "/reset",
        type        : "clientResetPassword",
        failType    : "resetFail"
    };

    if(!req.email){
        callback('Need email for reset');
        return;
    }

    var message = {
        private: true,
        payload: {email : req.email}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

/**
 * Verify the email if it is in use or not
 * @param req
 * @param callback
 */
QStack.prototype.verifyEmail        = function(req, callback){

    var details = {
        route       : "/verifyemail",
        type        : "verifyEmail",
        failType    : "verifyFail",
        successType : "verifySuccess"
    };

    if(!req.email){
        callback('Need email for verification check');
        return;
    }

    var message = {
        private: true,
        payload: {email : req.email}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });

};

/**
 * Gets the user profile
 * @param req
 * @param callback
 * @returns {*}
 */
QStack.prototype.getProfile         = function(req, callback){

    var details = {
        route       : "/getprofile",
        type        : "clientRequestProfile",
        failType    : "requestProfileFail",
        successType : "requestProfileSuccess"
    };

    if(!req.email){
        callback('Need email for verification check');
        return;
    }

    var message = {
        private: true,
        payload: {email : req.email}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.linkToFacebook     = function (req, callback) {
    var details = {
        route       : "/linkfacebook",
        type        : "clientLinkFacebook",
        failType    : "linkFacebookFail",
        successType : "linkFacebookSuccess"
    };

    if(!req.email){
        callback('Need email for verification check');
        return;
    }

    var payload = {
        fbId : req.fbId,
        fbEmail : req.fbEmail,
        accessToken : req.accessToken
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.redeemEggs         = function (req, callback) {
    var details = {
        route       : "/redeem",
        type        : "redeemEggs",
        failType    : "redeemEggsFail",
        successType : "redeemEggsSuccess"
    };

    var payload = {
        itemId  : req.itemId
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getFriends         = function(req, callback){

    var details = {
        route       : "/getfriends",
        type        : "clientGetFriends",
        failType    : "getFriendsFail",
        successType : "getFriendsSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
}

QStack.prototype.getUserInfo        = function(req, callback){

    var details = {
        route       : "/getuserinfo",
        type        : "getUserInfo",
        failType    : "clientGetUserInfoFail"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.setUserAddress     = function(req, callback){

    var details = {
        route       : "/useraddress",
        type        : "setUserData",
        failType    : "setUserAddressFail",
        successType : "setUserDataSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.setAvatar          = function(req, callback){

    var details = {
        route       : "/avatar",
        type        : "setUserAva",
        failType    : "setUserAvaFail",
        successType : "setUserAvaSuccess"
    };

    var payload = {
        avatar : req.avatar
    }

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.setUserStatus      = function(req, callback){

    var details = {
        route       : "/userstatus",
        type        : "setUserData",
        failType    : "setUserAddressFail",
        successType : "setUserDataSuccess"
    };

    if(!req.status){
        console.log("no status given");
        return callback("No Status!");
    }

    var message = {
        private: true,
        payload: {status : req.status}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getGameMessage = function(req, callback){

    var details = {
        route       : "/getgamemessage",
        type        : "getGameMessage",
        failType    : "getGameMessageFail",
        successType : "getGameMessageSuccess"
    };

    var message = {
        private: true,
        payload: {status : req.status}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.teamInviteResponse = function(req, callback) {

    var details = {
        route: "/teaminviteresponse",
        type: "clientTeamInviteResponse",
        failType: "teamInviteResponseFail",
        successType: "teamInviteResponseFail"
    };
    //TODO Fix this!
    var payload = {};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getInbox = function(req, callback) {

    var details = {
        route: "/getinbox",
        type: "clientGetInbox",
        failType: "getInboxFail",
        successType: "getInboxSuccess"
    };

    var payload = {};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.searchForUsers = function(req, callback) {

    var details = {
        route: "/searchforusers",
        type: "clientUsersSearch",
        failType: "searchUsersFail",
        successType: "searchUsersSuccess"
    };

    var payload = {searchName : req.searchName};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.friendRequest = function(req, callback) {

    var details = {
        route: "/requestfriend",
        type: "clientRequestFriend",
        failType: "requestFriendFail",
        successType: "requestFriendSuccess"
    };

    if(!req.recipientName){
        return callback('No recipientName in request');
    }

    var payload = {recipientName : req.recipientName};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.answerFriendRequest = function(req, callback) {

    var details = {
        route: "/answerfriendrequest",
        type: "clientRequestFriend",
        failType: "requestFriendFail",
        successType: "requestFriendSuccess"
    };

    if(!req.recipientName){
        return callback('No recipientName in request');
    }

    var payload = {token : req.token};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.unfriend = function(req, callback) {

    var details = {
        route: "/unfriend",
        type: "clientUnfriend",
        failType: "unfriendFail",
        successType: "unfriendSuccess"
    };

    if(!req.displayName){
        return callback('No Friend DisplayName in Request');
    }

    var payload = {friendName : req.displayName, friendChannel: req.friendChannel};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.sendMessage = function(req, callback) {

    var details = {
        route: "/sendmessage",
        type: "clientSendMessage",
        failType: "sendMessageFail",
        successType: "sendMessageSuccess"
    };

    if(!req.recipientName){
        return callback('No recipientName in request');
    }

    if(!req.message){
        return callback('No message in request');
    }

    var payload = {recipientName : req.recipientName, message : req.message};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.deleteMessage = function(req, callback) {

    var details = {
        route: "/deletemessage",
        type: "clientDeleteMessage",
        failType: "deleteMessageFail",
        successType: "deleteMessageSuccess"
    };

    if(!req.messageType){
        return callback('No messageType in request');
    }

    if(!req.messageId){
        return callback('No messageId in request');
    }

    var payload = {messageId: req.messageId, messageType : req.messageType};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.deleteOutgoingChallenge = function(req, callback) {

    var details = {
        route: "/deleteMessage",
        type: "clientDeleteMessage",
        failType: "deleteMessageFail",
        successType: "deleteMessageSuccess"
    };

    if(!req.challengeId){
        return callback('No challenege ID in request');
    }

    var payload = {challengeId : req.challengeId};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.setOutgoingChallengeRead = function(req, callback){

    var details = {
        route: "/markread",
        type: "clientMarkRead",
        failType: "markReadFail",
        successType: "markReadSuccess"
    };

    if(!req.challengeId){
        return callback('No challenege ID in request');
    }

    var payload = {
        challengeId :   req.challengeId,
        messageType :   "outgoingAsyncChallenge"};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.setFinishedChallengeRead = function (req, callback){

    var details = {
        route: "/markread",
        type: "clientMarkRead",
        failType: "markReadFail",
        successType: "markReadSuccess"
    };

    if(!req.challengeId){
        return callback('No challenege ID in request');
    }

    var payload = {
        challengeId :   req.challengeId,
        messageType :   "finishedAsyncChallenge"};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.markInboxRead           = function (req, callback){
    var details = {
        route: "/markread",
        type: "clientMarkRead",
        failType: "markReadFail",
        successType: "markReadSuccess"
    };

    if(!req.messageId){
        return callback('No messageId in request');
    }

    var payload = {
        messageId :   req.messageId};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(request);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.makeInAppPurchase      = function (req, callback){
    var details = {
        route: "/inapppurchase",
        type: "clientPurchase",
        failType: "clientPurchaseFail",
        successType: "clientPurchaseSuccess"
    };

    if(!req.receipt){
        return callback('No receipt in request');
    }

    if(!req.type){
        return callback('No type in request');
    }

    var payload = {
        type    : req.type,
        receipt : req.receipt};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.flagQuestion      = function (req, callback){
    var details = {
        route: "/flagquestion",
        type: "flagQuestion",
        failType: "flagQuestionFail",
        successType: "flagQuestionSuccess"
    };

    if(!req.questionBody){
        return callback('No question body in request');
    }

    if(!req.zone){
        return callback('No zone in request');
    }

    var payload = {
        zone            : req.zone,
        category        : req.category,
        questionBody    : req.questionBody,
        reason          : req.reason};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.endGame = function(){
    this.game.endGame();
}

QStack.prototype.addFavoriteTournament     = function (req, callback){
    var details = {
        route: "/favoritetournament",
        type: "addFavoriteTournament",
        failType: "favoriteTournamentFail",
        successType: "favoriteTournamentSuccess"
    };

    if(!req.uuid){
        return callback('no tournament uuid in request');
    }

    var payload = {
        uuid    : req.uuid};

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.unfavoriteTournament       = function (req, callback){
    var details = {
        route: "/favoritetournament",
        type: "unfavoriteTournament",
        failType: "favoriteTournamentFail",
        successType: "favoriteTournamentSuccess"
    };

    if(!req.uuid){
        return callback('no tournament uuid in request');
    }

    var payload = {
        uuid    : req.uuid
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getScratcher           = function (req, callback){
    var details = {
        route: "/scratcher",
        type: "getScratcher",
        failType: "getScratcherFail",
        successType: "getScratcherSuccess"
    };

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.redeemScratcher    = function (req, callback){
    var details = {
        route: "/favoritetournament",
        type: "redeemScratcher",
        failType: "redeemScratcherFail",
        successType: "redeemScratcherSuccess"
    };

    if(!req.uuid){
        return callback('no tournament uuid in request');
    }

    var message = {
        private: true,
        payload: {}
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.submitQuestion    = function (req, callback){
    var details = {
        route: "/submitquestion",
        type: "submitQuestion",
        failType: "submitQuestionFail",
        successType: "submitQuestionSuccess"
    };

    if(!req.zone){
        return callback("No Zone in question request");
    }else if(!req.category){
        return callback("No category in user submit request");
    }else if(!req.question){
        return callback("No question in user submit request");
    }else if(!req.answers) {
        return callback("No answers in users submit request");
    }

    var payload = {
        zone        : req.zone,
        category    : req.category,
        question    : req.question,
        answers     : req.answers
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.changePassword   = function (req, callback){
    var details = {
        route: "/changepass",
        type: "changePassword",
        failType: "changePasswordFail",
        successType: "changePasswordSuccess"
    };

    if(!req.passwordOld){
        return callback("No Old Password in request");
    }else if(!req.password){
        return callback("No new password in request");
    }

    var payload = {
        passwordOld : req.passwordOld,
        password    : req.password
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.registerPush   = function (req, callback){
    var details = {
        route       : "/registerpush",
        type        : "registerPush",
        failType    : "registerPushFail",
        successType : "registerPushSuccess"
    };

    if(!req.platform){
        return callback("No platform in request");
    }else if(!req.token){
        return callback("No token in request");
    }

    var payload = {
        plat    : req.platform,
        token   : req.token
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.unregisterPush   = function (req, callback){
    var details = {
        route: "/unregisterpush",
        type: "unregisterPush",
        failType: "unregisterPushFail",
        successType: "unregisterPushSuccess"
    };

    if(!req.platform){
        return callback("No platform in request");
    }

    var payload = {
        plat    : req.platform
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.pushSettings  = function (req, callback){
    var details = {
        route: "/pushsettings",
        type: "changePushSettings",
        failType: "changePushSettingFail",
        successType: "changePushSettingSuccess"
    };

    if(!req.pushSettings){
        return callback("No push setting in request");
    }

    var payload = {
        pushSettings : req.pushSettings
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.sendChatMessage  = function (req, callback){
    var details = {
        route: "/sendchatmessage",
        type: "clientSendChatMessage",
        failType: "sendChatMessageFail",
        successType: "sendChatMessageSuccess"
    };

    if(!req.tournamentID){
        return callback("No tournament id in request");
    }

    if(!req.displayName){
        return callback("No display name in request");
    }

    if(req.avatar){
        return callback("No avatar in request");
    }

    if(req.messageBody){
        return callback("No message in request");
    }

    var payload = {
        tournamentID    : req.tournamentID,
        displayName     : req.displayName,
        mesageBody      : req.messageBody,
        pushSettings    : req.pushSettings
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getChatMessages  = function (req, callback){
    var details = {
        route: "/getchatmessages",
        type: "clientSendChatMessage",
        failType: "sendChatMessageFail",
        successType: "sendChatMessageSuccess"
    };

    if(!req.tournamentID){
        return callback("No tournament id in request");
    }

    var payload = {
        tournamentID    : req.tournamentID
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.declineAsyncChallenge  = function (req, callback){

    var details = {
        route       : "/declineAsyncChallenge",
        type        : "clientDeclineAsyncChallenge",
        failType    : "declineAsyncChallengeFail",
        successType : "declineAsyncChallengeSuccess"
    };

    if(!req.tournamentID){
        return callback("No tournament id in request");
    }

    var payload = {
        tournamentID    : req.tournamentID
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};

QStack.prototype.getOpenAsyncChallenges  = function (req, callback){
    var details = {
        route       : "/getOpenAsyncChallenges",
        type        : "clientGetOpenAsyncChallenges",
        failType    : "getOpenAsyncChallengesFail",
        successType : "getOpenAsyncChallengesSuccess"
    };

    if(!req.tournamentID){
        return callback("No tournament id in request");
    }

    var payload = {
        tournamentID    : req.tournamentID
    };

    var message = {
        private: true,
        payload: payload
    };

    this.sendRequest(details, message, function (err, response) {
        if (err) {
            console.log('error in get ' + details.route + ' request');
            console.log(details);
            console.log(message);
            console.log(err);

            return callback(err);
        }
        callback(null, response.body.payload);
    });
};


QStack.prototype.submitAnswer = function (req) {

    if(req.questionNum == null){
        console.log('need questionNum to answer question');
        return;
    }

    if(req.answer == null){
        console.log('need answer to answer question');
    }

    if(req.time == null){
        console.log('need time to answer question');
    }

    var msg = {
        type : 'clientSubmitAnswer',
        payload : req
    }
    this.game.writeToSocket(msg);
};


QStack.prototype.requestParser = function(data){


};

QStack.prototype.end            = function(){
    this.pusher.end();
}

QStack.prototype.sendRequest = function(details, message, callback) {

    if (message.private) {
        message.route = this.authRoute + details.route;
        message.authToken = this.authToken;
    } else {
        message.route = this.openRoute + details.route;
    }

    message.type = details.type;



    if (message.type && message.payload) {
        var requestBody = {
            type: message.type,
            payload: JSON.stringify(message.payload)
        };

        var parser = function (data) {
            if (data.status === 200) {



                console.log("---incoming data---");
                console.log(data.responseJSON);
                console.log("-------------------");

                if(data.responseJSON.type === message.successType){
                    callback(null, data.responseJSON)
                }else if(data.responseJSON.type === message.failType){
                    callback("Error", data.responseJSON.error)
                }else{
                    callback(null, data.responseJSON);
                }

            } else if (data.status === 400) {
                callback("Invalid Route!")
            } else {
                callback("Error status code: " + data.status);
            }
        };

        var req = {
            url: this.serverURL + message.route,
            type: "POST",
            data: JSON.stringify(requestBody),
            contentType: "application/json",
            complete: parser
        };

        if (message.private) {
            if (!message.authToken) {
                console.log(message.authToken);
                return callback("Private route requested with out authorization token");
            } else {
                req.headers = {'Authorization': message.authToken};
            }
        }


        console.log('---OUTGOING REQUEST----');
        console.log(req);
        console.log('-----------------------');

        $.ajax(req);
    }
    else {
        console.log('no message to be sent ' + message);
        callback();
    }
};