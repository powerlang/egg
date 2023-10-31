"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestOCompiler,
	#superclass : #PackageManifest,
	#category : #'OCompiler-Core-Manifest'
}

{ #category : #'code-critics' }
ManifestOCompiler class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#OCompiler)) #'2023-04-05T10:17:13.560006-03:00') )
]
