/**
 * Created by PurpleGatorLaptop2 on 8/17/15.
 */

function QStackPusher(){
    this.pusher = null;
    this.callbacks = {};
}

QStackPusher.prototype.connect          = function(appId, channel, displayName){
    var appKey = '4779f1bf61be1bc819da';

    var options = {
        encrypted: true,
        auth: {
            headers: {
                _id: appId,
                displayName: displayName,
                personalChannel: channel
            }
        },
        authTransport: 'ajax',
        authEndpoint: 'http://localhost:3001/pusher/auth'
    };

    if (!this.pusher) {
        this.pusher = new Pusher(appKey, options);
    }
}

QStackPusher.prototype.subscribe        = function(channelName, eventNames, callback){
    if (!this.pusher) {
        console.log('no pusher object');
        return;
    }

    var channel = this.pusher.channel(channelName) || this.pusher.subscribe(channelName);

    channel.bind('pusher:subscription_error', function (data) {
        console.log(channelName + 'pusher error' + data);
    });

    //  console.log('subscribing to ' + channelName);

    var callbacks = this.callbacks
    for (var i = 0; i < eventNames.length; i++) {
        (function (index) {
            //  console.log('binding to ' + eventNames[index]);
//TODO fix this
            callbacks[eventNames[index]] = function(data){
                callbacks[data.event](data);
            };

            channel.bind(eventNames[index], callbacks[eventNames[index]]);

            if(i===eventNames.length-1){
                callback();
            }

        })(i);
    }


}

QStackPusher.prototype.unsubscribe      = function(channelName){
    this.pusher.unsubscribe(channelName);
}

QStackPusher.prototype.getStatus        = function(friend, callback){
    var channel = this.pusher.channel(friend.channel);

    if (!channel) {
        console.log("channel" + friend.channel + " was undefined");
        return callback(false);
    }
    friend = channel.members.get(friend.displayName);

    if (friend) {
        callback(true);
    }
    else {
        callback(false);
    }
}

QStackPusher.prototype.publish          = function(channel, eventName, data){
    var channel = this.pusher.channel(channelName);
    channel.trigger(eventName, data);
}


QStackPusher.prototype.notSubscribed    = function(channelName){
    return !this.pusher || !this.pusher.channel(channelName);
}


QStackPusher.prototype.end = function(){
    if (this.pusher) {
        this.pusher.disconnect();
    }
    this.pusher = null;
}


QStackPusher.prototype.addCallback = function(event, callbackToAdd){
    console.log('adding callbacks');
    this.callbacks[event] = callbackToAdd;
};

