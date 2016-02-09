import Ember from 'ember';

export default Ember.Route.extend({
  pusher: Ember.inject.service(),
  beforeModel() {
    this.get('pusher')
      .subscribe('directory')
      .subscribe('torrent')
      .subscribe('transfer');
    return true;
  },
});
