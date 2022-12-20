Extension { #name : #String }

{ #category : #'*Metacello-VersionMapping' }
String >> isWildcard [ 

	"Am I a SemanticVersion wildcard string?"

	^ self = '*'
]
