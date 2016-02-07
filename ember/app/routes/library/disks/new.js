import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord('disk')
  },
  actions: {
    createDisk: function(disk) {
      var that = this;
      return disk.save().then(function() {
        that.transitionTo('library.disks.show', disk)
      });
    },
  },
});
