
App = Em.Application.create();

App.School = Em.Object.extend({});

App.Studio = Em.Object.extend({
   // Returns classes sorted by the day of week (asc)
  classesByDow: function() {
    this.classes.sort(function(a,b){return a.dayofweek > b.dayofweek});
    return this.classes;
  }.property()
  
});

App.YogaClass = Em.Object.extend({});

App.DayOfWeek = Em.Object.extend({
  asNumber: -1,
  inFinnish: function() {
    switch (this.asNumber) {
      case 0: return "Maanantai";
      case 1: return "Tiistai";
      case 2: return "Keskiviikko";
      case 3: return "Torstai";
      case 4: return "Perjantai";
      case 5: return "Lauantai";
      case 6: return "Sunnuntai";
    }
  }.property() 
});

App.daysOfWeek = Em.Object.create({
  content: $.map([0,1,2,3,4,5,6], function(dow){
    return App.DayOfWeek.create({asNumber:dow});
  }) // 0 = Monday
  
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

  // Returns an App.School
  createSchool: function(schoolJson) {
    studioModels = schoolJson.studios.map(function(studio) {
      classModels = studio.classes.map(function(yogaClass) {
        return App.YogaClass.create(yogaClass);
      });

      studio.classes = classModels;

      return App.Studio.create(studio);
    });

    schoolJson.studios = studioModels;
    return App.School.create(schoolJson);
  }
});

App.StudioView = Em.View.extend({
  templateName: "studio-table-view",
});

// Load the data. This also populates the views and produces the DOM.
App.schoolsController.loadData();
