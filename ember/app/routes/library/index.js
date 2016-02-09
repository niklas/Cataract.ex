import Ember from 'ember';

export default Ember.Route.extend({
  setupController: function(controller) {
    controller.set('disks', this.store.findAll('disk'));
    return this._super();
  },
});
