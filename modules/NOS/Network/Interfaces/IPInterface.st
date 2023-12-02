Class {
	#name : #IPInterface,
	#superclass : #NetInterface,
	#instVars : [
		'ip'
	],
	#category : 'SqueakNOS-Net-Interfaces'
}

{ #category : #'as yet unclassified' }
IPInterface >> initialize [
	super initialize.
	ip := IP new.
	ip | TCP new.
	ip | UDP new.
	self | ip
]

{ #category : #'as yet unclassified' }
IPInterface >> internetAddress: anInternetAddress [
	ip address: anInternetAddress
]

{ #category : #'as yet unclassified' }
IPInterface >> ip [
	^ ip
]
