var app;

app = angular.module('DrillApp');

app.factory('ViewFactory', function() {
  return {
    createView: function() {
      var View;
      View = function() {
        this.current = 'first';
        this.isFirst = function() {
          return this.current === 'first';
        };
        this.isNotGraded = function() {
          return this.current === 'question';
        };
        this.isGraded = function() {
          return this.current === 'graded';
        };
        this.isQuestion = function() {
          return this.isGraded() || this.isNotGraded();
        };
        this.isFinal = function() {
          return this.current === 'end';
        };
      };
      return new View();
    }
  };
});
