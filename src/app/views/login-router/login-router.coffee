angular.module 'mnoEnterpriseAngular'
  .controller 'LoginRouterCtrl', ($scope, MnoeOrganizations, $window, $state) ->

    $scope.$watch(MnoeOrganizations.getSelected, (newValue) ->
      if newValue?
        # Impac! is displayed only to admin and super admin
        if (MnoeOrganizations.role.isAdmin() || MnoeOrganizations.role.isSuperAdmin())
          $state.go('home.impac')
        else
          $state.go('home.apps')
    )

    return
