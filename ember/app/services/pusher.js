import Ember from 'ember';
import {Socket} from "cataract/vendor/phoenix";

export default Ember.Service.extend({
  store: Ember.inject.service(),
  channels: null,

  init() {
    this._super(...arguments);
    this.set('channels', Ember.Object.create());

    let socket = new Socket("/socket", {params: {token: window.userToken}});
    socket.connect();
    this.set('phoenix', socket );
    this.jobChannel(); // always join
  },

  subscribe(modelName) {
    let store  = this.get('store');
    let chan = this.channel(`${modelName}:index`);

    chan.on("create", (response) => {
      store.pushPayload(response);
    });
    chan.on("destroy", (response) => {
      store.peek(modelName, response.id).then((model) => {
        store.unloadRecord(model);
      });
    });

    return this;
  },

  jobChannel() {
    let chan = this.channel("job:index");
    return chan;
  },

  startJob(name, id) {
    let chan = this.jobChannel()
    chan.push(name, id);
    return this;
  },

  channel(channelName) {
    let joined = this.get('channels');
    // only join once
    if ( Ember.isPresent( joined.get(channelName) ) ) {
        return joined.get(channelName);
    }

    let socket = this.get('phoenix');
    let joinParams = {};
    let chan = socket.channel(channelName, joinParams);
    chan.join().
      receive("ignore", () => {
        const error = `Could not connect to the ${channelName} channel`;
        Ember.logger.warn(error);
      }).
      receive("ok", (_msg) => {
        joined.set(channelName, chan);
      });

    return chan;
  }

});
