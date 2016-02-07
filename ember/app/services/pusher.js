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
  },

  subscribe(modelName) {
    let joined = this.get('channels');
    // only join once
    if ( Ember.isPresent( joined.get('modelName') ) ) { return; }

    let socket = this.get('phoenix');
    let store  = this.get('store');
    let joinParams = {};
    let channel = socket.channel(`${modelName}:index`, joinParams);

    channel.join().
      receive("ignore", () => {
        const error = `Could not connect to the ${modelName} channel`;
        Ember.logger.warn(error);
      }).
      receive("ok", (channel) => {
        joined.set(modelName, channel);
      });
    channel.on("create", (response) => {
      store.pushPayload(response);
    });
    channel.on("destroy", (response) => {
      store.peek(modelName, response.id).then((model) => {
        store.unloadRecord(model);
      });
    });

    return this;
  },


});
