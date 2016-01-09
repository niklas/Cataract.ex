import Ember from 'ember';

export default Ember.Component.extend({
    classNames: 'progress'.w(),
    attributeBindings: [
        'role',
        'value:aria-valuenow',
        'minimum:aria-valuemin',
        'maximum:aria-valuemax',
    ],

    role: 'progressbar',
    tabindex: 0,

    minimum: 0,
    maximum: 9000,
    value: 0,

    meterStyle: function() {
        return new Ember.Handlebars.SafeString("width: " + this.get('percentCompleted') + "%")
    }.property('percentCompleted'),

    detail: function() {
        return "" + this.get('value') + " / " + this.get('maximum')
    }.property('maximum', 'value'),

    percentCompleted: function() {
        return (100 * ( this.get('value') / this.get('maximum') )).toFixed(2)
    }.property('maximum', 'value'),
});
