"
I represent a semantic version. See [https://semver.org/](https://semver.org) for details.


"
Class {
	#name : #SemanticVersion,
	#superclass : #Magnitude,
	#instVars : [
		'major',
		'minor',
		'patch'
	],
	#category : #'Metacello-VersionMapping'
}

{ #category : #'instance creation' }
SemanticVersion class >> major: majorVersion [ 

	^ self basicNew 
		initializeMajor: majorVersion minor: nil patch: nil ;
		yourself
]

{ #category : #'instance creation' }
SemanticVersion class >> major: majorVersion minor: minorVersion [ 

	^ self basicNew 
		initializeMajor: majorVersion minor: minorVersion patch: nil ;
		yourself
]

{ #category : #'instance creation' }
SemanticVersion class >> major: majorVersion minor: minorVersion patch: patchVersion [

	minorVersion isWildcard ifTrue: [ 
		patchVersion isWildcard ifFalse: [ 
			self error: 'patch must be wildcard when minor is wildcard' ] ].

	^ self basicNew 
		initializeMajor: majorVersion minor: minorVersion patch: patchVersion ;
		yourself
]

{ #category : #'instance creation' }
SemanticVersion class >> new [

	self error: 'Use ' , #major:minor:patch: printString
]

{ #category : #comparing }
SemanticVersion >> < aMagnitude [ 

	^ self asInteger < aMagnitude asInteger
]

{ #category : #comparing }
SemanticVersion >> = aSemanticVersion [ 

	self class = aSemanticVersion class ifFalse: [ ^ false ].

	self major = aSemanticVersion major ifFalse: [ ^ false ].
	self minor = aSemanticVersion minor ifFalse: [ 
		(self minor isWildcard or: [ aSemanticVersion minor isWildcard ]) 
			ifFalse: [ ^ false ] 
			ifTrue: [ ^ true ] ].

	self patch = aSemanticVersion patch ifFalse: [ 
		(self patch isWildcard or: [ aSemanticVersion patch isWildcard ]) 
			ifFalse: [ ^ false ] 
			ifTrue: [ ^ true ] ].

	^ true
]

{ #category : #converting }
SemanticVersion >> asInteger [

	| integer |

	major isWildcard 
		ifTrue: [ integer := 99900000000 ] 
		ifFalse: [ integer := (major * 100000000) ].

	integer := integer + (minor isWildcard 
		ifTrue: [ 99900000 ] 
		ifFalse: [ (minor * 100000) ]).

	integer := integer + (patch isWildcard 
		ifTrue: [ 99999 ] 
		ifFalse: [ patch ]).

	^ integer
]

{ #category : #comparing }
SemanticVersion >> hash [

	^ self species hash 
		bitXor: (self major 
			bitXor: (self minor 
				bitXor: self patch))

]

{ #category : #initialization }
SemanticVersion >> initializeMajor: majorVersion minor: minorVersion patch: patchVersion [

	self initialize.

	major := self parseValue: majorVersion.
	minor := self parseValue: minorVersion.
	patch := self parseValue: patchVersion
]

{ #category : #accessing }
SemanticVersion >> major [
	^ major
]

{ #category : #accessing }
SemanticVersion >> minor [
	^ minor
]

{ #category : #parsing }
SemanticVersion >> parseValue: anObject [ 

	({ '*'. $*. nil } includes: anObject) ifTrue: [ ^ '*' ].

	^ anObject asInteger
]

{ #category : #accessing }
SemanticVersion >> patch [
	^ patch
]

{ #category : #printing }
SemanticVersion >> printOn: stream [ 

	stream 
		<< major asString 
		<< '.' << minor asString.

	minor isWildcard ifTrue: [ ^ self ].

	stream << '.' << patch asString
]
