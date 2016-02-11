import DS from 'ember-data';
import Ember from 'ember';

let c = Ember.computed;

export default DS.Model.extend({
  name: DS.attr('string'),
  path: DS.attr('string'),
  parent: DS.belongsTo('directory'),
  disk: DS.belongsTo('disk'),
  torrentsAsFiles: DS.hasMany('torrent', {async: false, inverse: 'directory'}),

  // the torrent files in this directory
  torrentsHavingPayloadSomewhere: c.filter('torrents.@each.payloadDirectory', function(torrent, _i, _a) {
    return !!torrent.get('payloadDirectory');
  }),

  // the torrents having payload in this directory
  torrents: DS.hasMany('torrent', {async: false, inverse: 'payloadDirectory'}),

  sizeBytesOfTorrents: c.mapBy('torrents', 'sizeBytes'),
  sizeBytes: c.sum('sizeBytesOfTorrents'),
});
