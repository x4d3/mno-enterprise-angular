
DashboardAppsDockCtrl = ($scope, $cookies, $uibModal, $window, MnoeOrganizations, MnoeAppInstances) ->
  'ngInject'

  $scope.appDock = {}
  $scope.appDock.isMinimized = true
  $scope.activeApp = null
  $scope.launchApp = {isClosed: true}

  # 'Lock' the dock when a menu is expanded.
  # Ie: we disable all effects and animation
  $scope.appDock.isAnimated = () ->
    $scope.activeApp == null

  # Scope initialization
  $scope.modal ||= {}

  # ----------------------------------------------------------
  # Permissions helper
  # ----------------------------------------------------------
  $scope.helper = {}
  $scope.helper.displaySettings = ->
    MnoeOrganizations.can.update.appInstance()

  $scope.helper.isLaunchHidden = (app) ->
    app.status == 'terminating' ||
    app.status == 'terminated' ||
    $scope.helper.isOauthConnectBtnShown(app) ||
    $scope.helper.isNewOfficeApp(app)

  $scope.helper.isOauthConnectBtnShown = (instance) ->
    instance.app_nid != 'office-365' &&
    instance.stack == 'connector' &&
    !instance.oauth_keys_valid

  $scope.helper.isNewOfficeApp = (instance) ->
    instance.stack == 'connector' && instance.appNid == 'office-365' && (moment(instance.createdAt) > moment().subtract({minutes:5}))

  $scope.helper.oAuthConnectPath = (instance)->
    MnoeAppInstances.clearCache()
    $window.location.href = "/mnoe/webhook/oauth/#{instance.uid}/authorize"

  # Launch cloud application
  # If app requires custom we open the popup, otherwise we open the link directly
  $scope.launchAction = (app, event) ->
    $scope.setActiveApp(event, app.id)
    if app.customInfoRequired
      return false
    else
      $window.open("/mnoe/launch/#{app.uid}", '_blank')
      return true

  $scope.setActiveApp = (event, app) ->
    if $scope.isActiveApp(app)
      $scope.activeApp = null
    else
      angular.element(event.target).off('mouseout')
      $scope.activeApp = app

  $scope.isActiveApp = (app) ->
    $scope.activeApp == app

  $scope.appDock.toggle = ->
    $scope.appDock.isMinimized = !$scope.appDock.isMinimized

  #====================================
  # App Settings modal
  #====================================
  $scope.showSettingsModal = (app) ->
    modalInstance = $uibModal.open(
      templateUrl: 'app/views/apps/modals/app-settings-modal.html'
      controller: 'DashboardAppSettingsModalCtrl'
      resolve:
        app: ->
          app
    )

  #====================================
  # Post-Initialization
  #====================================
  $scope.$watch MnoeOrganizations.getSelectedId, (val) ->
    if val?
      MnoeAppInstances.getAppInstances().then(
        ->
          $scope.apps = MnoeAppInstances.appInstances
      )

#====================================
# Modals Controllers
#====================================
angular.module 'mnoEnterpriseAngular'
  .directive('dashboardAppsDock', ($window) ->
    return {
      scope: {
        visibleIfEmpty: '=?'
      },
      link: (scope, element) ->
        # Mobile dock: max-height need to be an absolute value for the scrolling to work
        pageHeight = angular.element(window).height()
        navHeight = pageHeight * 0.7
        angular.element('#mobile-dock').css({ maxHeight: navHeight + 'px' })

        element.on('mouseover', (e) ->
          if scope.activeApp == null
            if e.target.src # Check if it's an image
              li = e.target.parentNode
              prevLi = angular.element(li.previousElementSibling)
              if prevLi
                prevLi.addClass "prev"

              angular.element(e.target).bind('mouseout mouseleave', () ->
                if prevLi
                  prevLi.removeClass "prev"
              )
        )
        angular.element($window).on('mouseup', (event) ->
          if scope.activeApp? && scope.launchApp.isClosed
            $menu = $('li.active.dock-icon')
            if ($menu.has(event.target).length == 0 && # checks if descendants of $menu was clicked
                !$menu.is(event.target) ) # checks if the $menu itself was clicked
              scope.$apply(
                scope.activeApp = null
                $('ul.dock:not(.animated) > li.prev').removeClass('prev')
              )
        )
      restrict: 'EA'
      controller: DashboardAppsDockCtrl
      templateUrl: 'app/components/dashboard-apps-dock/dashboard-apps-dock.html',
     }
)
