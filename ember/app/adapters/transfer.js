import PhoenixAdapter from "ember-phoenix-adapter";

export default PhoenixAdapter.extend({
  addEvents: ["add", "create"],

  joinParams: function() {
    return { authToken: "verysecrettoken" };
  }.property("token"),
});
