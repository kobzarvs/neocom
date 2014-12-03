mymodule = angular.module('neocom',['ui.bootstrap','ngMaterial'])

mymodule.controller 'TimeCtrl', ($scope, $interval, $http) ->
	self = this
	$scope.timeValue = 0
	@labels = []
	@asyncSelected = []
	
	@getLabels = (search) ->
		$http.get('/labels.json').then (resp) ->
			data = resp.data
			self.labels = _.filter data.sort(), (label) -> _.contains(label, search)

			
	@onclick = ->
		@getLabels('')


mymodule.controller 'AppCtrl', ($scope, $timeout, $mdSidenav) ->
	$scope.items = [1..5]
	$scope.toggleLeft = ->
		$mdSidenav('left').toggle()

	$scope.toggleRight = ->
		$mdSidenav('right').toggle()

mymodule.controller 'LeftCtrl', ($scope, $timeout, $mdSidenav) ->
	$scope.close = ->
		$mdSidenav('left').close()

mymodule.controller 'RightCtrl', ($scope, $timeout, $mdSidenav) ->
	$scope.close = ->
		$mdSidenav('right').close()

mymodule.controller 'MyController', ($scope, $mdBottomSheet, $mdToast) ->
  $scope.openBottomSheet = ->
    $mdBottomSheet.show template: "<md-bottom-sheet>Hello!</md-bottom-sheet>"

  $scope.openToast = ($event) ->
    $mdToast.show( $mdToast
                  .simple()
                  .content('Файл сохранен')
                  .position('top right'))
