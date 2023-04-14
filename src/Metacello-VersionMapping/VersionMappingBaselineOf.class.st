"
I am a subclass of BaselineOf with additional version mapping behavior.

I can detect my version description using Iceberg and use this to map a baseline to a version specific repository url. For example, when you have a version of your baseline that needs to load a specific tag for a dependency.

Note that you must implement my method `VersionMappingBaselineOf>>#createVersionBaselineRepositoryMap` with a mapping of your choice. 

You can use me to version application dependencies, making it possible to run consistent builds for specific versions.

## Example
Imagine you have an application that depends on Voyage. You finalize your application and tag it in git with v1.0.0. Now you want to make sure that you can consistently build your v1.0.0 application with exactly the same version of Voyage. For example, when your application code has evolved or changes have been made to the Voyage code.

To make this work, make your application baseline a subclass of VersionMappingBaselineOf and define a version baseline repository map. For example:

```language=Pharo
{ 
	'*' -> {
		'Voyage' -> 'github://objectguild/voyage:develop' } asDictionary.
	'v1.0.0' -> {
		'Voyage' -> 'github://objectguild/voyage:v1.2.1' } asDictionary.

} asDictionary
```

Now, whenever you run a build of v1.0.0 of your application (using these [Object Guild Pharo server tools](https://github.com/objectguild/pharo-server-tools)), the mapping will ensure that tag v1.2.1 will be used for the Voyage dependency. When a new version of your application depends on a different version of Voyage, or you have more dependencies, you can add additional entries to your mapping.

Note that this requires the ability (or authorization) to create a tag in the repository of your dependency. We suggest creating a fork, to ensure complete control over code changes and tags.

## Future work
- Implement semantic versioning behavior. The current implementation of the version baseline repository mapping works with an explicit version string (with the exception of the '*' wildcard). A future version can replace this with a semantic version object which can handle wildcards for minor or fix versions. For example, v1.2.* would match all versions starting with v1.2. Needs work, see `SemanticVersion`.
"
Class {
	#name : #VersionMappingBaselineOf,
	#superclass : #BaselineOf,
	#instVars : [
		'version',
		'versionBaselineRepositoryMap'
	],
	#category : #'Metacello-VersionMapping'
}

{ #category : #accessing }
VersionMappingBaselineOf class >> availableVersions [ 

	"Answer available version descriptions of my Iceberg repository. This will be 
	a collection of branches and tag names."

	| myRepository branchShortnames tagNames |

	myRepository := self myRepository.

	branchShortnames := myRepository remoteTrackedBranches 
		collect: [ :each | each shortname ] thenReject: [ :each | each = #HEAD ].
	tagNames := myRepository tags collect: [ :each | each name ].

	^ branchShortnames , tagNames
]

{ #category : #accessing }
VersionMappingBaselineOf class >> detectVersion [ 

	"Answer the version description of my Iceberg repository. This will be 
	the name of the checked out branch or tag. 

	This can probably also be a commit hash, but this has not been tested."

	^ self myRepository head description
]

{ #category : #accessing }
VersionMappingBaselineOf class >> myRepository [ 

	| myPackageName |

	myPackageName := self package name.

	^ IceRepository repositories detect: [ :repository | 
			repository workingCopy packages anySatisfy: [ :package | 
				package name = myPackageName ] ]
]

{ #category : #accessing }
VersionMappingBaselineOf >> createVersionBaselineRepositoryMap [ 

	"Answer a dictionary (map) that can be used to determine which 
	repository url to use for loading a dependent baseline.

	1) The first key is my current version description (name of git branch, 
	tag or commit hash) as loaded in the image (see #detectVersion).
	2) The second key is the name of the dependent baseline.
	3) The value is the repository url.

	Version mapping example:

	^ { 
		'*' -> {
			'Voyage' -> 'github://objectguild/voyage:production' } asDictionary.

		'develop' -> {
			'Voyage' -> 'github://objectguild/voyage:develop' } asDictionary.

	} asDictionary"

	self subclassResponsibility
]

{ #category : #accessing }
VersionMappingBaselineOf >> repositoryForBaseline: aString [ 

	"Answer the mapped respository url for my version and the specified baseline."

	| map repository |

	map := self versionBaselineRepositoryMap.

	repository := map at: self version at: aString ifAbsent: [ 
		map at: '*' at: aString ].

	MetacelloNotification signal: 'Mapping -> version: ' , self version , ' --- baseline: ' , aString , ' >> repository: ' , repository .

	^ repository
]

{ #category : #accessing }
VersionMappingBaselineOf >> version [ 

	^ version ifNil: [ version := self class detectVersion ]
]

{ #category : #accessing }
VersionMappingBaselineOf >> versionBaselineRepositoryMap [ 

	^ versionBaselineRepositoryMap ifNil: [ self createVersionBaselineRepositoryMap ] 
]
