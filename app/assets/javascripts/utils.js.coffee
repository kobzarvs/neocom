m = angular.module 'utils', []

#
#
@hide = (elem) ->
	angular.element(elem).addClass 'ng-hide'

#
#	
@show = (elem) ->
	angular.element(elem).removeClass 'ng-hide'


@mouseEvent = (type, sx, sy, cx, cy) ->
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

m.config ($provide, $compileProvider, $filterProvider) ->
	$provide.service 'dispatchEvent', (elem, event) ->
	  if elem.dispatchEvent
	    elem.dispatchEvent event
	  else if elem.fireEvent
	    elem.fireEvent 'on' + event.type, event

	  return event

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

console.log "utils loaded..."


