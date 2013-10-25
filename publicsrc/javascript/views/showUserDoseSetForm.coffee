define ['jquery', 'underscore', 'backbone','helpers','collections/DoseSets','views/ChooseDoseSetSelect', 'collections/Users'], ($, _, Backbone, Helpers, DoseSets, ChooseDoseSetSelect, Users) ->

	class ShowUserDoseSetForm extends Backbone.View