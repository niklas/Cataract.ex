import DS from 'ember-data';
import ApplicationAdapter from 'cataract/adapters/application';

export default ApplicationAdapter.extend({
  shouldReloadAll: function() { return true; },
});
