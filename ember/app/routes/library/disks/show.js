import Ember from 'ember';

export default Ember.Route.extend({
  pusher: Ember.inject.service(),
  afterModel(model) {
    return this.store.query('torrent', { disk: model.id });
  },

  actions: {
    index(disk) {
    return this.
      get('pusher').
      startJob('index_disk', disk.id)
    }
  },
});
