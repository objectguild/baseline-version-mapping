# Baseline Version Mapping
Enterprise-class versioning of your dependencies.

[![Pharo 8.0](https://img.shields.io/badge/Pharo-8.0-informational)](https://pharo.org)
[![Pharo 9.0](https://img.shields.io/badge/Pharo-9.0-informational)](https://pharo.org)
[![Pharo 10.0](https://img.shields.io/badge/Pharo-10.0-informational)](https://pharo.org)
[![Pharo 11.0](https://img.shields.io/badge/Pharo-11.0-informational)](https://pharo.org)

This library adds version mapping capabilities to BaselineOf classes, making it possible to link a project version to specific dependency versions. The purpose of this is to allow for consistent builds of a specific project version, even when one or more dependencies have released newer versions. To help with making consistent builds, take a look at our modified [Pharo server tools](https://github.com/objectguild/pharo-server-tools).

As an example, imagine you have a dependency on [CodeParadise](https://github.com/ErikOnBike/CodeParadise) (if not, you should check it out!). When your project is under active development, you surely want to depend on the `master` branch of **CodeParadise**. But when you release a version of your project to a production environment, you want to make sure that it always loads the exact version you tested with. This is where the **VersionMappingBaselineOf** comes in.

## How it works
Let's say that you've tagged your project with version `v0.9.0` and you want to version it's dependency on **CodeParadise**. To make this work, you can take the following steps:

1. Of course, you must load the Baseline Version Mapping baseline itself first.
```Smalltalk
Metacello new
	repository: 'github://objectguild/baseline-version-mapping:main' ;
	baseline: 'VersionMapping' ;
	load.
```
2. Make sure that the baseline of your project subclasses **VersionMappingBaselineOf**, like so:
```Smalltalk
VersionMappingBaselineOf subclass: #BaselineOfMyFirstProject
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'BaselineOfMyFirstProject'
```
3. Define your baseline dependency as follows. Note where the message **#useVersionMappedRepository** is sent to spec inside the block argument to `#with:`, which invokes the version mapping behavior.
```Smalltalk
baseline: spec
	<baseline>

	spec for: #common do: [

		spec postLoadDoIt: #postload:package:.

		"Dependencies"
		spec
			baseline: 'CodeParadise' with: [ spec useVersionMappedRepository loads: #( 'Shoelace' ) ].

		"Packages"
		"<your project package definitions go here like normal>"

		"Groups"
		"<your project group definitions go here like normal>"
	]
```
4. Implement the method **#createVersionBaselineRepositoryMap** on your subclass as follows. This tells the version mapping baseline to load **CodeParadise** version `v1.0.0` when the current project version is `v0.9.0`.
```Smalltalk
createVersionBaselineRepositoryMap

	^ {
		'*' -> {
			'CodeParadise' -> 'github://ErikOnBike/CodeParadise:master' } asDictionary.

		'v0.9.0' -> {
			'CodeParadise' -> 'github://ErikOnBike/CodeParadise:v1.0.0' } asDictionary.

	} asDictionary
```
5. That's it! You can add other dependencies or new project versions to the version map as you extend your project. The mapping of your project's version to its dependency versions is now part of the source code and included in the repository.

## Future work
- Implement semantic versioning behavior. The current implementation of the version baseline repository mapping works with an explicit version string (with the exception of the '\*' wildcard). A future version can replace this with a semantic version object which can handle wildcards for minor or fix versions. For example, v1.2.* would match all versions starting with v1.2. See current implementation of `SemanticVersion` in this project.

## Collective Code Construction Contract (C4)
It is Object Guild's intention to use the [Collective Code Construction Contract (C4)](https://rfc.zeromq.org/spec/42/) for collaboration on this project. Please familiarize yourself with its contents when you want to collaborate on Crypto-Nacl.

The C4 states that the project should have clearly documented guidelines for code style. Since these are currently missing (9 November 2020), these will be created as needed and will thus be a work in progress.

We will use incoming issues and pull requests for purposes of learning to apply C4, so please be patient with us :-) 

Comments are welcome. You are kindly requested to use the [project issue tracker](https://github.com/objectguild/Crypto-Nacl/issues) for this purpose.
