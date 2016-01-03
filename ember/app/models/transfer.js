import DS from 'ember-data';

export default DS.Model.extend({
  upRate: DS.attr('integer'),
  downRate: DS.attr('integer')
});
