provider = () ->
	thisIsPrivate = "Private"
	return {
		setPrivate: (newVal) ->
			thisIsPrivate=newVal

		$get: ->
			getPrivate = ->
				return thisIsPrivate

			return {
				variable: "This is public"
				getPrivate: getPrivate
      }
	}