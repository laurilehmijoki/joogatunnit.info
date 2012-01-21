App = Em.Application.create();

App.School = Em.Object.extend({});

App.schoolsController = Em.ArrayController.create({
  content: [],

  loadData: function() {
    var self = this;
    $.ajax({
      url: '/api/hajk', // Only one school at the moment
      dataType: 'json',
      success: function(data) {
        self.pushObject(App.School.create(data));
      }
    });
  }

});

App.schoolsController.loadData();
