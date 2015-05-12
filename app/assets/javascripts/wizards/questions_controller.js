(function() {
  'use strict';

  angular.module('broker.wizard')
    /**@ngInject*/
    .controller('WizardQuestionsController', function(question, WizardQuestionsResource) {
      var vm = this;
      vm.tags = [];
      vm.answer = question.wizard_answers[0];
      vm.question = question;
      vm.action = "Next Question";

      vm.nextQuestion = function() {
        vm.tags = _.union(vm.tags, vm.answer.tags_to_add)
        vm.tags = _.difference(vm.tags, vm.answer.tags_to_remove)

        if(vm.question.next_question_id) {
          WizardQuestionsResource.get({ id: vm.question.next_question_id }).$promise
            .then(function(question) {
              vm.question = question;
              vm.answer = question.wizard_answers[0];
            });
        } else {
          vm.action = "Done now.";
        }
      }
    });
}());
