
App = Em.Application.create();

App.School = Em.Object.extend({});

App.Studio = Em.Object.extend({
   // Returns classes sorted by the day of week (asc)
  classesByDow: function() {
    this.classes.sort(function(a,b){return a.dayofweek > b.dayofweek});
    return this.classes;
  }.property()
  
});

App.YogaClass = Em.Object.extend({

});

App.schoolsController = Em.ArrayController.create({
  content: [],

  loadData: function() {
    var self = this;
    $.ajax({
      url: '/api/hajk', // Only one school at the moment
      dataType: 'json',
      success: function(data) {
        self.pushObject(self.createSchool(data));
      }
    });
  },

  createSchool: function(schoolJson) {
    studioModels = schoolJson.studios.map(function(studio) {
      classModels = studio.classes.map(function(yogaClass) {
        return App.YogaClass.create(yogaClass);
      });

      studio.classes = classModels;

      return App.Studio.create(studio); // Create studio
    });

    schoolJson.studios = studioModels;
    return App.School.create(schoolJson); // Create school
  }
});

App.StudioView = Em.View.extend({
  content: {},
  templateName: "studio-table-view",

});

// Load the data. This also populates the views and produces the DOM.
App.schoolsController.loadData();
