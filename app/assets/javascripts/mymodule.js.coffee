mymodule = angular.module('neocom',['ui.bootstrap','ngMaterial', 'wraper'])

mymodule.run ($rootScope) ->
	$rootScope._ = window._
	console.log("Lodash injected to angular!")


mymodule.directive 'addConnector',  ['$document', '$compile', ($document, $compile) ->

	(scope, element, attr) ->
		scope.x = 0
		scope.y = 0
		scope.bx = 0
		scope.by = 0
		scope.alpha = 0
		scope.el = null

		console.log "***", attr

		mouseup = ->
			$document.off 'mousemove', mousemove
			$document.off 'mouseup', mouseup
			#console.log "mouse up"

		mousemove = (e)->
			dx = e.x - scope.bx
			dy = e.y - scope.by
			scope.sign = if dx < 0 then -180 else 0
			scope.distance = Math.round(Math.sqrt(dx*dx + dy*dy) - 3)
			atan = Math.atan(dy / dx)
			scope.alpha = scope.sign + atan / Math.PI*180
			scope.x = scope.bx
			scope.y = scope.by
			scope.angle = if scope.alpha < -90 then 0 else 180
			scope.offsetY = if scope.alpha < -90 then [50,20] else [70, 30]
			#console.log e.x, e.y

		element.on 'mousedown', (e) ->
			#console.log "mouse down"
			scope.bx = e.x
			scope.by = e.y
			e.preventDefault()
			$document.on 'mousemove', mousemove
			$document.on 'mouseup', mouseup
			el = $compile( "<connector></connector>" )( scope )
			element.append( el )

]



mymodule.controller 'DrawCtrl2', ($scope, $interval, $http) ->
	$scope.x = 0
	$scope.y = 0
	$scope.bx = 0
	$scope.by = 0
	$scope.alpha = 0

	$scope.onmousemove = (e)->
		dx = e.x - $scope.bx
		dy = e.y - $scope.by
		$scope.sign = if dx < 0 then -180 else 0
		$scope.distance = Math.round(Math.sqrt(dx*dx + dy*dy) - 3)
		atan = Math.atan(dy / dx)
		$scope.alpha = $scope.sign + atan / Math.PI*180
		$scope.x = $scope.bx
		$scope.y = $scope.by
		$scope.angle = if $scope.alpha < -90 then 0 else 180


	$scope.onclick = (e) ->
		$scope.bx = e.x
		$scope.by = e.y

mymodule.controller 'TimeCtrl', ($scope, $interval, $http) ->
	self = this
	$scope.timeValue = 0
	$scope.labels = []
	$scope.asyncSelected = []
	$scope.testval = 100
	
	$scope.getLabels = (search='') ->
		console.log "search: [#{search}] #{$scope.testval}"
		$http.get('/nodes.json').then (resp) ->
			data = resp.data
			$scope.labels = _.filter data.sort(), (label) -> _.contains(label, search)
			
	$interval( (-> $scope.getLabels()), 3000)
			
	@onclick = ->
		@getLabels('')


mymodule.controller 'AppCtrl', ($scope, $timeout, $mdSidenav) ->
	$scope.items = [1..5]
	$scope.data =
		selectedIndex: 0
	
	$scope.getHtml = (i) ->
		"<md-button style=\"width:100%; text-align:left\"> Primary #{i} </md-button>"

	$scope.toLeft = ->
		$scope.data.selectedIndex--
		console.log $scope.data.selectedIndex
		
	$scope.toRight = ->
		$scope.data.selectedIndex++
		console.log $scope.data.selectedIndex

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




	






