Extension { #name : #Number }

{ #category : #'*Metacello-VersionMapping' }
Number >> isWildcard [ 

	"I am never a SemanticVersion wildcard."

	^ false
]
