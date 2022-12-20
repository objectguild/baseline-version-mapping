Extension { #name : #Character }

{ #category : #'*Metacello-VersionMapping' }
Character >> isWildcard [

	"Am I a SemanticVersion wildcard character?"

	^ self = $*
]
