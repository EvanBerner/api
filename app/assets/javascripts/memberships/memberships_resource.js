'use strict';

/**@ngInject*/
var MembershipsResource = function($resource, apiResource) {
  return $resource(apiResource('projectGroups'), {projectId: '@id'}, {
    delete: {
      method: 'DELETE',
      url: apiResource(
        'projectGroupById',
        { projectId: '@projectId', groupId: '@groupId' }
      )
    },
    update: {
      method: 'PUT',
      url: apiResource(
        'projectGroupById',
        { projectId: '@projectId', groupId: '@groupId' }
      )
    }
  });
};

window.MembershipsResource = MembershipsResource;
