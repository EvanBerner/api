(function() {
  angular.module('broker.wizard')
    .config(function($stateProvider) {
      $stateProvider
        .state('base.authed.wizard', {
          url: "/wizard",
          templateUrl: "/templates/partials/wizard/question.html",
          resolve: {
            /**@ngInject*/
            question: function(WizardQuestionsResource) {
              return WizardQuestionsResource.get({ id: "first" }).$promise;
            },
          },
          controller: "WizardQuestionsController as vm"
        });
    });
}());
