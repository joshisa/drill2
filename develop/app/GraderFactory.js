var app;

app = angular.module('DrillApp');

app.factory('GraderFactory', function(SafeEvalService) {
  return {
    createPerQuestionGrader: function(max, radical) {
      if (radical == null) {
        radical = true;
      }
      return function(question) {
        var correct, incorrect, ret;
        ret = {
          score: 0,
          total: max
        };
        correct = question.correct();
        incorrect = question.incorrect();
        if (!(radical && (incorrect || !correct))) {
          ret.score = Math.max(max * ((correct - incorrect) / question.totalCorrect()), 0);
        }
        return ret;
      };
    },
    createPerAnswerGrader: function(radical) {
      if (radical == null) {
        radical = true;
      }
      return function(question) {
        var correct, incorrect, ret;
        ret = {
          score: 0,
          total: question.totalCorrect()
        };
        correct = question.correct();
        incorrect = question.incorrect();
        if (!(radical && (incorrect || !correct))) {
          ret.score = Math.max(correct - incorrect, 0);
        }
        return ret;
      };
    },
    createOneLinerGrader: function(oneliner) {
      return function(question) {
        var fakeInfo, questionInfo;
        questionInfo = function(id) {
          switch (id) {
            case 'correct':
              return question.correct();
            case 'incorrect':
              return question.incorrect();
            case 'missed':
              return question.missed();
            case 'total':
              return question.totalCorrect();
            default:
              return 0;
          }
        };
        fakeInfo = function(id) {
          switch (id) {
            case 'correct':
            case 'total':
              return question.totalCorrect();
            default:
              return 0;
          }
        };
        return {
          score: SafeEvalService["eval"](oneliner, questionInfo),
          total: SafeEvalService["eval"](oneliner, fakeInfo)
        };
      };
    }
  };
});
