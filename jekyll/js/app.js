
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

App.router = Em.Object.create({
  selectedSchoolId: null,
  /*selectedCity: "Helsinki",*/
  selectedStudioId: null,
  
  showSelectedSchools: function() {
    var self = this;
    var schools = App.schoolsController.content;
    if (self.selectedSchoolId == null || self.selectedSchoolId == "") {
      /*No school is specified; hide all.*/
      schools.setEach('hidden', true);
    } else {
      /* Show the specified school(s)*/
      schools.forEach(function(item){
        item.set('hidden', item.get('id') != self.selectedSchoolId);
      });
    }
  },

  showSelectedStudios: function() {
    var self = this;
    App.schoolsController.content.forEach(function(school) {
      school.studios.forEach(function(studio) {
        var hidden = (self.selectedStudioId == null || self.selectedSchooldId == "") ? false : studio.get('id') != self.selectedStudioId;
        studio.set('hidden',  hidden);
      });
    });
  },

  newHash: function(hash) {
    this.setSelectedSchoolId(this.parseSchoolId(hash));
    this.setSelectedStudioId(this.parseStudioId(hash));
  },

  parseSchoolId: function(hash) {
    return hash.substring(1/*Omit char '#'*/, this.hasStudio(hash) ? hash.indexOf('/') : hash.length);
  },

  hasStudio: function(hash) {return hash.indexOf('/') >= 0;},

  parseStudioId: function(hash) {
   return this.hasStudio(hash) ? hash.substring(hash.indexOf('/')+1, hash.length) : null; 
  },

  setSelectedStudioId: function(studioId) {
    this.selectedStudioId = studioId;
    this.showSelectedStudios();
  },
  
  setSelectedSchoolId: function(schoolId) {
    this.selectedSchoolId = schoolId;
    this.showSelectedSchools();
  },

});

App.schoolsController = Em.ArrayController.create({
  content: [], /* App.School array*/

  loadData: function() {
    var self = this;
    $.ajax({
      url: '/api/all_schools', 
      dataType: 'json',
      success: function(data) {
        data.schools.forEach(function(school) {
          self.pushObject(self.createSchool(school));
          App.router.showSelectedSchools();
          App.router.showSelectedStudios();
        });
      }
    });
  },

  // Returns an App.School
  createSchool: function(schoolJson) {
    var self = this;
    studioModels = schoolJson.studios.map(function(studio, index) {
      classModels = studio.classes.map(function(yogaClass) {
        return App.YogaClass.create(yogaClass);
      });

      studio.id = "sali-"+ (index + 1);

      studio.classes = classModels;

      studio.dayDatas = [0,1,2,3,4,5,6].map(function(dayOfWeek) { // Group per weekday
        return App.DayData.create({
          dayofweek: App.DayOfWeek.create({asInteger:dayOfWeek}),
          classes: studio.classes.filterProperty("dayofweek", dayOfWeek)
        });
      });

      return App.Studio.create(studio);
    });

    schoolJson.hasOneStudio = studioModels.length == 1;
    schoolJson.studios = studioModels;
    school = App.School.create(schoolJson);

    school.studios.forEach(function(studio) {studio.set('school', school);}); // Backref studio–>school
    
    return school;
  }
});

App.StudioLinkView = Em.View.extend({
  render: function(ctx) {
    ctx.push("<a href='/#"+this.studio.get('school').id+"/"+this.studio.get('id')+"'>"+this.studio.get('name')+"</a>");
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
