import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('transfers');
  this.route('library', function() {
    this.route('disks', function() {
      this.route('new');
      this.route('show', { path: "/show/:disk_id" });
    });
  });
});

export default Router;
