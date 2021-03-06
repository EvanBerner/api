'use strict';

/**@ngInject*/
var AlertsTable = function() {
  return {
    restrict: 'E',
    templateUrl: '/templates/partials/common/problem_alerts.html',
    transclude: true,
    scope: {
      alerts: "="
    }
  };
};

window.AlertsTable = AlertsTable;
