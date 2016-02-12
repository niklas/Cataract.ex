import Ember from 'ember';

export default Ember.Route.extend({
  afterModel(model) {
    return this.store.query('torrent', { disk: model.id });
  },
});
