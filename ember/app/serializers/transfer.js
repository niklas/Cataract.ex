import PhoenixAdapter from "ember-phoenix-adapter";

export default PhoenixAdapter.extend({
  primaryKey: 'hash',
  addEvents: ["add", "create"],

  joinParams: function() {
    return { authToken: token };
  }.property("token"),
});
