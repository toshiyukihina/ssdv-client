# Directive used to set metisMenu and minimalize button
angular.module('ssdv')

  .directive 'sideNavigation', ($timeout) ->
    restrict: 'A'
    link: (scope, element) ->
      # Call metsi to build when user signup
      scope.$watch 'authentication.user', ->
        $timeout ->
          element.metisMenu()
          
  .directive 'iboxTools', ($timeout) ->
    restrict: 'A'
    scope: true
    templateUrl: 'components/common/ibox_tools.html'
    controller: ($scope, $element) ->
      # Function for collapse ibox
      $scope.showhide = ->
        ibox = $element.closest('div.ibox')
        icon = $element.find('i:first')
        content = ibox.find('div.ibox-content')
        content.slideToggle(200)
        # Toggle icon from up to down
        icon.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down')
        ibox.toggleClass('').toggleClass('border-bottom')
        $timeout ->
          ibox.resize()
          ibox.find('[id^=map-]').resize()
        , 50
      # Function for close ibox
      $scope.closebox = ->
        ibox = $element.closest('div.ibox')
        ibox.remove()

  .directive 'minimalizaSidebar', ($timeout) ->
    restrict: 'A'
    template: '<a class="navbar-minimalize minimalize-styl-2 btn btn-primary" href="" ng-click="minimalize()"><i class="fa fa-bars"></i></a>'
    controller: ($scope, $element) ->
      $scope.minimalize = ->
        angular.element('body').toggleClass('mini-navbar')
        if not angular.element('body').hasClass('mini-navbar') or angular.element('body').hasClass('body-small')
          # Hide menu in order to smoothly turn on when maximize menu
          angular.element('#side-menu').hide()
          # For smoothly turn on menu
          $timeout ->
            angular.element('#side-menu').fadeIn(500)
          , 100
        else
          # Remove all inline style from jquery fadeIn function to reset menu state
          angular.element('#side-menu').removeAttr('style')
          false
