w = angular.module('wraper',['utils']) #.constant('_', window._)



w.directive 'wraper', ['$compile', '$document', '$http', '$rootElement', '$utils', ($compile, $document, $http, $rootElement, $utils) ->

	link = ($scope, $elem, $attr) ->
		scope = $scope



		#
		# calc arrow params
		#
		calcArrow = (dx,dy, titleParams, minTitleShowSize=0) ->
				sign = if dx < 0 then -180 else 0
				distance = Math.round(Math.sqrt(dx*dx + dy*dy) - 3)
				angle = sign + Math.atan(dy / dx) / Math.PI*180
				side = if angle < -90 then 0 else 180
				offsetY = if angle < -90 then [50,20] else [70, 30]

				if _.isObject(titleParams)
					tmp = _(titleParams).filter (val,idx) -> idx <= distance
					title = tmp.last()
					title = '' if _.isUndefined(title)
				else
					title = if distance > minTitleShowSize then titleParams else ''
				
				if title.length > 0
					title = $compile("<div>#{title}</div>")($scope)
					title = title[0]

				[side, angle, offsetY, distance, title]

		
		#
		#
		refreshArrow = (dx,dy) ->
			titleParams =
				400: "&nbsp; Big Distance (400): {{distance}} &nbsp;"
				100: "&nbsp; {{distance}} &nbsp;"
				600: "&nbsp; Very Big Distance (>600): {{distance}} &nbsp;"
				220: "&nbsp; Distance: {{distance}} &nbsp;"

			[$scope.side, $scope.angle, $scope.offsetY, 
			$scope.distance, $scope.title] = calcArrow dx, dy, titleParams

		
		#
		#
		mapParentElements = (el, preFunc = null, middleFunc = null, postFunc = null, stopAttr = 'connector-') ->
			if _.isElement(el)
				attr = ''
				attr = i.name for i in el.attributes when i.name is stopAttr
				#console.log "OFFSET: ",el.tagName #, el.attributes
				preFunc?( el )

				if attr.length
					middleFunc(el)
					return postFunc?(el)

				if el.parentElement?
					unless el.parentElement.tagName is 'HTML'
						mapParentElements el.parentElement, preFunc, middleFunc, postFunc, stopAttr
						return postFunc?(el)

				middleFunc(el)

		#
		# warpEventThrough:
		# 	1. 	Вызывает preFunc для всех элементов, на которые указывает курсор мыши, начиная с текущего elem
		#				preFunc должен возвращать элемент (это можент быть копия или измененный объект)
		#		2.  Когда находит элемент с атрибутом targetAttr, вызывает trigger
		#		3.	Вызывает postFunc в обратном порядке для каждого элемента, для которых вызывался preFunc
		#
		warpEventThrough = (targetAttr, elem, preFunc = null, postFunc = null, trigger = null) ->
			if _.isElement(elem)
				mainElem = getByAttr elem, targetAttr
				if mainElem
					elemClone = preFunc? mainElem
					underElem = $document[0].elementFromPoint event.pageX, event.pageY
					warpEventThrough targetAttr, underElem, preFunc, postFunc, trigger
					postFunc? elemClone
				else
					trigger? elem
				
		#
		#		
		getByAttr = (el, stopAttr) ->
			if _.isElement(el)
				attr = ''
				attr = i.name for i in el.attributes when _.contains(i.name, stopAttr)
				if attr.length
					return el
				else if el.parentElement
					return getByAttr el.parentElement, stopAttr
			return null
			
		#
		#
		getBody = (el) ->
			if _.isElement(el)
				if el.tagName is 'BODY'
					return el
				else if el.parentElement
					getBody el.parentElement
			return null
			
		copyElement = (srcElem) ->
			srcElem.cloneNode(true)
			
		cutElement = (srcElem) ->
			destElem = copyElement srcElem
			srcElem.remove()
			return destElem
			
		pasteElement = (destElem) ->
			$rootElement.append destElem 
		

		#
		#
		silencer = (e) ->
			console.log "silenser!"
			e.preventDefault()
			e.stopPropagation()
			
			warpEventThrough 'connector-main', e.target,
				(elem) ->
					hide elem
				(elem) ->
					show elem
				(elem) ->
					console.log "trigger", e
					evt = $utils.mouseEvent e.type, e.x, e.y, e.x, e.y
					$utils.dispatchEvent elem, evt

			return false
				

		#
		# mouse events
		#
							
		mousedown = (e) ->
			console.log "mouse down: ", e.x, e.y
			$scope.sx = e.x #- $scope.ox
			$scope.sy = e.y #- $scope.oy
			body = getBody e.target
			#console.log _.keys(e.target)
			console.log "SCOPE 1:", $scope
			$utils.appendFromTemplate $rootElement, 'assets/connector.html', $scope
			$scope.$digest()
			e.preventDefault()
			$document.on 'mousemove', mousemove
			$document.on 'mouseup', mouseup
			$elem.off 'mousedown', mousedown
			refreshArrow 0,0


		mouseup = ->
			$elem.on 'mousedown', mousedown
			$document.off 'mousemove', mousemove
			$document.off 'mouseup', mouseup
			elem = cutElement $scope.tmpElem[0]
			pasteElement elem
			angular.element(elem).on 'mousedown click', silencer
			console.log "mouse up"


		mousemove = (e)->
			dx = e.x - $scope.sx
			dy = e.y - $scope.sy
			refreshArrow dx, dy
			$scope.$applyAsync()
			#console.log "mouse move: ", e.x, e.y, $scope.angle

		$elem.on 'mousedown', mousedown
		
		restrict: 'A'
		link: link
		scope: true
]


