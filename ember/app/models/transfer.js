import DS from 'ember-data';

export default DS.Model.extend({
  upRate: DS.attr('number'),
  downRate: DS.attr('number')
});
