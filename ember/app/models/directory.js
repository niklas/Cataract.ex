import DS from 'ember-data';

let c = Ember.computed;

export default DS.Model.extend({
  name: DS.attr('string'),
  path: DS.attr('string'),
  parent: DS.belongsTo('directory'),
  disk: DS.belongsTo('disk'),
  torrents: DS.hasMany('torrent', {async: false}),

  sizeBytesOfTorrents: c.mapBy('torrents', 'sizeBytes'),
  sizeBytes: c.sum('sizeBytesOfTorrents'),
});
