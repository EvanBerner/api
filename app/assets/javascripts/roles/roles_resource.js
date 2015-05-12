'use strict';

/**@ngInject*/
window.RolesResource = function($resource, apiResource, $state) {
  return $resource(apiResource('roles'), {'id': '@id'});
};
