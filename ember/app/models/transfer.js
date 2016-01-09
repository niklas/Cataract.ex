import DS from 'ember-data';

export default DS.Model.extend({
  sizeBytes: DS.attr('number'),
  completedBytes: DS.attr('number'),
  ratio: DS.attr('number'),
  upRate: DS.attr('number'),
  downRate: DS.attr('number'),

  percentCompleted: function() {
      return 100 * ( this.get('completedBytes') / this.get('sizeBytes') )
  }.property('sizeBytes', 'completedBytes'),
});
