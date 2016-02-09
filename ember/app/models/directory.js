import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  path: DS.attr('string'),
  parent: DS.belongsTo('directory'),
  disk: DS.belongsTo('disk'),
  torrents: DS.hasMany('torrent', {async: false}),
});
