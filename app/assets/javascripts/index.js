'use strict';

angular.module("broker", [
  "ui.router",
  "ngResource",
  "angular-loading-bar",
  "smart-table",
  "ngAnimate",
  "ui.gravatar",
  "angucomplete-alt",
  "ui.bootstrap",
  "ui.select",
  "ngCookies",
  "ng-currency",
  "angular-progress-arc",
  "broker.common",
  "broker.base",
  "broker.errors",
  "broker.groups",
  "broker.roles",
  "broker.admin",
  "broker.alerts",
  "broker.flashes",
  "broker.question_input",
  "broker.auth",
  "broker.cart",
  "broker.projects",
  "broker.products",
  "broker.clouds",
  "broker.services",
  "broker.marketplace",
  "broker.orders",
  "broker.directives",
  "broker.dashboard",
  "broker.users",
  "broker.settings",
  "broker.memberships",
  "broker.wizard",
  "schemaForm",
  "nvd3",
  "ngDraggable",
  "angular.filter"
]).run(
  /**@ngInject*/
  function($http, $rootScope, $log, $location, AuthService, UsersResource, Session, $urlRouter, ROUTES, $state, APP_CONFIG, FlashesService) {

    $http.defaults.headers.common.Accept= 'application/json, text/javascript';
    $http.defaults.headers.common['Content-Type'] = 'application/json; charset=utf-8';

    // Allows us to have a different host for the API and still have cookies set correctly.
    // Requires CORS setup on API endpoints, as well as non wildcard values.
    $http.defaults.withCredentials = true;

    $rootScope.sideBarExpanded = true;

    $rootScope.APP_CONFIG = APP_CONFIG;

    // auto close popup on body click
    $("body").click(function(e) {
      var $target = $(e.target);
      if ($target.closest('.drop-down-box').length && $target.closest('.keep-drop-down-open').length) {
        return false;
      }
      $(".drop-down-box").addClass('hide');
    });

    //// On init we check the current user to see if we are already authenticated.
    //// If we are, we create the session and and sync the routes.
    //var currentMember = UsersResource.getCurrentMember();
    //currentMember.$promise.then(function(data) {
    //  Session.create(data.email, data.role);
    //  $urlRouter.sync();
    //}, function() {
    //  $state.transitionTo('base.public.logout');
    //  //$location.path(ROUTES.login);
    //  $urlRouter.sync();
    //});

    // Authorization and Authentication when switching Pages.
    $rootScope.$on('$stateChangeStart', function (event, next) {

      // Block all routing until the current user is loaded for the first time.
      // After authorization check because public routes do not need currentUser to verify.
      //if (!currentMember.$resolved) {
      //  event.preventDefault();
      //  return;
      //}
      var authorizedRoles = next.data.authorizedRoles;
      if (!AuthService.isAuthorized(authorizedRoles)) {
        if (AuthService.isAuthenticated()) {
          $state.transitionTo('base.authed.errors.unauthorized');
        } else {
          $state.transitionTo('errors.sorry');
        }
      }
    });

    // catch any error in resolve in state
    $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams, error) {
      // If a 401 is encountered during a state change, then kick the user back to the login screen
      if (401 === error.status) {
        if (AuthService.isAuthenticated()) {
          $state.transitionTo('base.public.logout');
        } else if ('base.public.login' !== toState.name) {
          $state.transitionTo('base.public.login');
        }
      } else if (403 === error.status) {
        FlashesService.add({
          timeout: false,
          type: 'error',
          message: 'An error has prevented the page from loading. Please try again later.'
        });
        if ('base.authed.dashboard' !== fromState.name) {
          $state.transitionTo('base.authed.dashboard');
        }
      } else {
        $log.error('Unhandled State Change Error occurred: ' + (error.statusText || error.message));
        FlashesService.add({
          timeout: false,
          type: 'error',
          message: 'An error has prevented the page from loading. Please try again later.'
        });
      }
      event.preventDefault();
    });

    $rootScope.$on('$stateChangeSuccess', function() {
      $("html, body").animate({scrollTop: 0}, 200);
    });

    $rootScope.$on('$stateNotFound', function(event) {
      event.preventDefault();
      if (AuthService.isAuthenticated()) {
        $state.transitionTo('base.authed.errors.not-found');
      } else {
        $state.transitionTo('errors.sorry');
      }
    });
  }
);
