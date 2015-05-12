(function() {
  'use strict';

  /**@ngInject*/
window.GroupsInput =  function() {
    return {
      restrict: 'E',
      templateUrl: '/templates/partials/projects/groups_input.html',
      scope: {
        project: "="
      },
      controller: function($scope, UsersResource, GroupsResource, MembershipsResource, RolesResource) {
        $scope.project.groups = $scope.project.groups || [];
        $scope.project.group_ids = $scope.project.group_ids || [];
        $scope.allRoles = RolesResource.query();
        UsersResource.getCurrentMember({'includes[]': ['groups']}).$promise
          .then(function(currentUser) {
            if(currentUser.isAdmin()) {
              $scope.groups = GroupsResource.query();
            } else {
              $scope.groups = currentUser.groups;
            }
            $scope.unaddedGroups = $scope.groups;
          });

        $scope.$watchCollection('project.groups', function() {
          $scope.unaddedGroups = _.reject($scope.groups, function(group){
            return _.any($scope.project.groups, {id: group.id});
          })
        });

        $scope.addGroupToProject = function(group) {
          group = group.originalObject;
          $scope.project.groups.push(group);
          if($scope.project.id) {
            new MembershipsResource({
              group_id: group.id
            }).$save({projectId: $scope.project.id})
            .catch(function(_error) {
              _.remove($scope.project.groups, {id: group.id})
            });
          } else {
            $scope.project.group_ids.push(group.id)
          }
        };

        $scope.removeGroupFromProject = function(group) {
          _.remove($scope.project.groups, {id: group.id});
          if($scope.project.id) {
            MembershipsResource.delete({
              projectId: $scope.project.id,
              groupId: group.id
            }).$promise.catch(
              function(error){ $scope.project.groups.push(group) }
            );
          } else {
            _.remove($scope.project.group_ids, group.id);
          }
        };

        $scope.setGroupRole = function(role, group) {
          MembershipsResource.update({
            projectId: $scope.project.id,
            groupId: group.id,
            roleId: role.id,
          });
        }
      }

    };
  }
}());
