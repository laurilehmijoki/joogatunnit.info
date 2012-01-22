
App = Em.Application.create();

App.School = Em.Object.extend({});

App.Studio = Em.Object.extend({

});

App.StudioDayData = Em.Object.extend({

});

App.DayOfWeek = Em.Object.extend({
  asInteger: -1,

  inFinnish: function() {
    switch (this.asInteger) {
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

App.YogaClass = Em.Object.extend({});

App.schoolsController = Em.ArrayController.create({
  content: [],

  loadData: function() {
    var self = this;
    $.ajax({
      url: '/api/all_schools', 
      dataType: 'json',
      success: function(data) {
        data.schools.forEach(function(school) {
          self.pushObject(self.createSchool(school));
        });
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

      studio.dayDatas = [0,1,2,3,4,5,6].map(function(dayOfWeek) {
        return App.StudioDayData.create({
          dayofweek: App.DayOfWeek.create({asInteger:dayOfWeek}),
          classes: studio.classes.filterProperty("dayofweek", dayOfWeek)
        });
      });

      return App.Studio.create(studio);
    });

    schoolJson.studios = studioModels;
    return App.School.create(schoolJson);
  }
});

App.StudioDayView = Em.View.extend({
  templateName: "studio-day-view",
});

App.StudioView = Em.View.extend({
  templateName: "studio-view",

});

// Load the data. This also populates the views and produces the DOM.
App.schoolsController.loadData();
