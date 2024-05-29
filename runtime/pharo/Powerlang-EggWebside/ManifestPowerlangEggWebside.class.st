"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestPowerlangEggWebside,
	#superclass : #PackageManifest,
	#category : #'Powerlang-EggWebside-Manifest'
}

{ #category : #'code-critics' }
ManifestPowerlangEggWebside class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'Powerlang-EggWebside')) #'2022-05-27T22:04:23.077811+00:00') )
]

{ #category : #'code-critics' }
ManifestPowerlangEggWebside class >> ruleSelfSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'Powerlang-EggWebside')) #'2023-02-14T15:06:02.567-03:00') )
]
