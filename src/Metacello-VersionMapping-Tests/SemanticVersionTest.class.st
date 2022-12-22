"
A SemanticVersionTest is a test class for testing the behavior of SemanticVersion
"
Class {
	#name : #SemanticVersionTest,
	#superclass : #TestCase,
	#category : #'Metacello-VersionMapping-Tests'
}

{ #category : #tests }
SemanticVersionTest >> testEquals [ 

	| v123 |

	v123 := SemanticVersion major: 1 minor: 2 patch: 3.

	self assert: v123 equals: (SemanticVersion major: 1 minor: 2 patch: 3).

	self deny: v123 equals: (SemanticVersion major: 1 minor: 2 patch: 2).
	self deny: v123 equals: (SemanticVersion major: 1 minor: 2 patch: 4).
	self deny: v123 equals: (SemanticVersion major: 1 minor: 1 patch: 1)
]

{ #category : #tests }
SemanticVersionTest >> testEqualsWildcard [ 

	| v123 |

	"version 1.2.3"
	v123 := SemanticVersion major: 1 minor: 2 patch: 3.

	"matches 1.2.*"
	self assert: v123 equals: (SemanticVersion major: 1 minor: 2 patch: '*').
	"matches 1.*.*"
	self assert: v123 equals: (SemanticVersion major: 1 minor: '*' patch: '*').
	self assert: v123 equals: (SemanticVersion major: 1 minor: $* patch: $*).
	self assert: v123 equals: (SemanticVersion major: 1 minor: nil patch: nil)
]
