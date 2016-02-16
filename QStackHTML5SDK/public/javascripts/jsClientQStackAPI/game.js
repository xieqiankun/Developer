/**
 * Created by PurpleGatorLaptop2 on 8/17/15.
 */


function Game(ip, port, token, team, player){

    this.token = token;
    this.ip     = ip;
    this.port   = port;
    this.team   = team;
    this.player = player;

};

Game.prototype.setHandlerAndStart = function(handler){

    var socket = this.socket;

    //closure
    var game = this;


    this.socket = new Primus('http://' + this.ip + ':' + this.port, {'ping': 5000});

    var wrapCallback = function (callback) {
        var wrappedCallback = angular.noop;

        if (callback) {
            wrappedCallback = function () {
                var args = arguments;
                $rootScope.$apply(function () {
                    callback.apply(socket, args);
                });
            };
        }
        return wrappedCallback;
    };

    this.socket.on('open', function () {
        game.socket.write(game.token);
    });
    this.socket.on('data', handler);
}


Game.prototype.getLatency = function(){
    return this.socket['latency'];
};

Game.prototype.writeToSocket = function(data){
    if(this.socket){
        this.socket.write(data);
    }else{
        console.log('no active socket');
    }
};

Game.prototype.endGame = function(){
    this.socket.end();
    this.socket = null;
}