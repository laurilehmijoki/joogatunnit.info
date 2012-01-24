
App = Em.Application.create();

App.School = Em.Object.extend({
  hidden: false  
});

App.Studio = Em.Object.extend({

});

App.DayData = Em.Object.extend({

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
  selectedSchoolId: null, /* null == show all*/
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

  showSelectedSchools: function() {
    var self = this;
    if (self.selectedSchoolId == null || self.selectedSchoolId == "") {
      return;/*No school is specified; show all.*/
    }
    this.content.forEach(function(item){
      item.set('hidden', item.get('id') != self.selectedSchoolId);
    });
  },

  newHash: function(hash) {
    this.setSelectedSchoolId(hash.substring(1));  
  },
  
  setSelectedSchoolId: function(schoolId) {
    this.selectedSchoolId = schoolId;
    this.showSelectedSchools();
  },

  // Returns an App.School
  createSchool: function(schoolJson) {
    var self = this;
    studioModels = schoolJson.studios.map(function(studio) {
      classModels = studio.classes.map(function(yogaClass) {
        return App.YogaClass.create(yogaClass);
      });

      studio.classes = classModels;

      studio.dayDatas = [0,1,2,3,4,5,6].map(function(dayOfWeek) {
        return App.DayData.create({
          dayofweek: App.DayOfWeek.create({asInteger:dayOfWeek}),
          classes: studio.classes.filterProperty("dayofweek", dayOfWeek)
        });
      });

      self.showSelectedSchools();

      return App.Studio.create(studio);
    });

    schoolJson.studios = studioModels;
    return App.School.create(schoolJson);
  }
});

App.SchoolLinkView = Em.View.extend({
  render: function(ctx) {
    ctx.push("<a href='/#"+this.school.get('school').id+"'>"+this.school.get('school').name+"</a>");
  }
});

App.SchoolListItemView = Em.View.extend({
  templateName: "school-list-item-view",
  tagName: "span",
});

App.SchoolListView = Em.View.extend({
  templateName: "school-list-view"
});

App.SchoolHeaderView = Em.View.extend({
  templateName: "school-header-view",
});

App.StudioView = Em.View.extend({
  templateName: "studio-view",

});

App.start = function() {
  // Load the data. This also populates the views and produces the DOM.
  App.schoolsController.loadData();
}
