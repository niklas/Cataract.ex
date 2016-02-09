import DS from 'ember-data';

export default DS.JSONAPIAdapter.extend({
  namespace: 'api/1',
  shouldReloadAll: function() { return true; },
});
