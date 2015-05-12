(function() {
  'use strict';

  angular.module('broker.wizard')
    /**@ngInject*/
    .factory('WizardQuestionsResource', function($resource, apiResource) {
      return $resource(apiResource('wizardQuestions'), {
        id: '@id',
        'includes[]': ['wizard_answers']
      });
    });
}());
