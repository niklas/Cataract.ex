import DS from 'ember-data';
import Ember from 'ember';

let c = Ember.computed;

export default DS.Model.extend({
  name: DS.attr('string'),
  path: DS.attr('string'),
  parent: DS.belongsTo('directory'),
  disk: DS.belongsTo('disk'),
  torrents: DS.hasMany('torrent', {async: false, inverse: 'directory'}),

  sizeBytesOfTorrents: c.mapBy('torrents', 'sizeBytes'),
  sizeBytes: c.sum('sizeBytesOfTorrents'),

  torrentsWithPayload: c.filterProperty('torrents', 'payloadDirectory'),
  sizeBytesOfTorrentsWithPayload: c.mapBy('torrentsWithPayload', 'sizeBytes'),
  sizeBytesActual: c.sum('sizeBytesOfTorrentsWithPayload'),
});
