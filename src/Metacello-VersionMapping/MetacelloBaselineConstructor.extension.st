Extension { #name : #MetacelloBaselineConstructor }

{ #category : #'*Metacello-VersionMapping' }
MetacelloBaselineConstructor >> useVersionMappedRepository [ 

	self repository: (self configuration repositoryForBaseline: self root name)
]
