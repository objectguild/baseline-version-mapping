"
I am the baseline to use for loading the baseline version mapping feature.

I only define one package named Metacello-VersionMapping. This contains a subclass of BaselineOf with additional version mapping behavior as well as an extension method for Metacello.
"
Class {
	#name : #BaselineOfVersionMapping,
	#superclass : #BaselineOf,
	#category : #BaselineOfVersionMapping
}

{ #category : #baselines }
BaselineOfVersionMapping >> baseline: spec [

	<baseline>

	spec for: #common do: [

		spec package: 'Metacello-VersionMapping' ]
]
