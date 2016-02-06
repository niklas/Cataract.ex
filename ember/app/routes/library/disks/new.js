import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord('disk')
  },
  actions: {
    createDisk: function(disk) {
      return disk.save()
    },
  },
});
