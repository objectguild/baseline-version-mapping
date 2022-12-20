"
A SemanticVersionTest is a test class for testing the behavior of SemanticVersion
"
Class {
	#name : #SemanticVersionTest,
	#superclass : #TestCase,
	#category : #'Metacello-VersionMapping-Tests'
}

{ #category : #tests }
SemanticVersionTest >> testEqualsWildcard [ 

	| v123 |

	v123 := SemanticVersion major: 1 minor: 2 patch: '3'.

	self assert: v123 equals: (SemanticVersion major: 1 minor: 2 patch: '*').
	self assert: v123 equals: (SemanticVersion major: 1 minor: '*' patch: '*').

	self assert: v123 equals: (SemanticVersion major: 1 minor: $* patch: $*).

	self assert: v123 equals: (SemanticVersion major: 1 minor: nil patch: nil)
]
