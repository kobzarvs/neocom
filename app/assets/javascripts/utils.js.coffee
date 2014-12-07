m = angular.module('utils', [])

class Person
	name: "*****"

	constructor: ( )->
		console.log "constructor"			

	getName: () ->
  	console.log "Get name: #{@name}"
  	return @name

	setName: (name) ->
		@name = name
		console.log "Set name: #{@name}"

m.service '$ts', Person



#
#
@hide = (elem) ->
	angular.element(elem).addClass 'ng-hide'

#
#	
@show = (elem) ->
	angular.element(elem).removeClass 'ng-hide'


mouseEvent = (type, sx, sy, cx, cy) ->
	e =
    bubbles: true
    cancelable: (type != "mousemove")
    view: window
    detail: 0
    screenX: sx
    screenY: sy
    clientX: cx
    clientY: cy
    ctrlKey: false
    altKey: false
    shiftKey: false
    metaKey: false
    button: 0
    relatedTarget: undefined
	
  if typeof( document.createEvent ) == "function"
    evt = document.createEvent("MouseEvents")
    evt.initMouseEvent( type, 
      e.bubbles, e.cancelable, e.view, e.detail,
      e.screenX, e.screenY, e.clientX, e.clientY,
      e.ctrlKey, e.altKey, e.shiftKey, e.metaKey,
      e.button, document.body.parentNode )
  else if document.createEventObject
    evt = document.createEventObject()
    evt[prop] = e[prop] for prop of e

    evt.button = { 0:1, 1:4, 2:2 }[evt.button] || evt.button
  return evt

			

#
# load template from site and append to current element 
#
# @appendFromTemplate = (dest, path) ->
# 	$http.get path
# 		.success (data) ->
# 			e = $compile(data)($scope)
# 			dest.append e
# 			$scope.tmpElem = e
# 			$scope.$applyAsync()
#

# class $tsProvider
# 	name:
# 		get: () ->
# 			@name
# 		set: (name) ->
# 			@name = name


#
# load template from site and append to current element 
#

getProviders = (list) ->
	initInjector = angular.injector(['ng'])
	result = []
	result.push initInjector.get(provider) for provider in list
	return result
	

m.provider '$utils', [ () ->
	[$http, $compile, $document] = getProviders ['$http', '$compile', '$document']

	name = 'Utils'
	
	appendFromTemplate = (dest, path, scope) ->
		$http.get path
			.success (data) ->
				console.log $document
				e = $compile(data)(scope)
				dest.append e
				scope.tmpElem = e
#				scope.$applyAsync()

		
				
	dispatchEvent = (elem, event) ->
	  if elem.dispatchEvent
	    elem.dispatchEvent event
	  else if elem.fireEvent
	    elem.fireEvent 'on' + event.type, event

	  return event
		

	return {
		config: {}
	
		$get: ->
			_appendFromTemplate = (dest, path, scope) -> appendFromTemplate(dest, path, scope)
			_dispatchEvent = (elem, event) ->	dispatchEvent(elem, event)
			_mouseEvent = (type, sx, sy, cx, cy) -> mouseEvent(type, sx, sy, cx, cy)
			
			return {
				name: name
				appendFromTemplate: _appendFromTemplate
				dispatchEvent:			_dispatchEvent
				mouseEvent:					_mouseEvent
		  }
	}
]

m.config ($utilsProvider) ->
	console.log "utils settings up!"


console.log "utils loaded!"
