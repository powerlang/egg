Class {
	#name : #EthernetInterface,
	#superclass : #NetInterface,
	#instVars : [
		'ethernet',
		'ip'
	],
	#category : 'SqueakNOS-Net-Interfaces'
}

{ #category : #'as yet unclassified' }
EthernetInterface >> device: aDevice [
	super device: aDevice.
	ethernet address: aDevice macAddress
]

{ #category : #'as yet unclassified' }
EthernetInterface >> down [
	self ethernet arp timerDown.
	self ip tcp timerDown.
	super down
]

{ #category : #'as yet unclassified' }
EthernetInterface >> ethernet [
	^ ethernet
]

{ #category : #'as yet unclassified' }
EthernetInterface >> initialize [
	super initialize.
	ip := IP new.
	ip | TCP new.
	ip | UDP new.
	ethernet := Ethernet new.
	self | PluggableConduit transcripter | ethernet | ip
]

{ #category : #'as yet unclassified' }
EthernetInterface >> internetAddress: anInternetAddress [
	ip address: anInternetAddress.
	ethernet arp protocolAddress: anInternetAddress
]

{ #category : #'as yet unclassified' }
EthernetInterface >> ip [
	^ ip
]

{ #category : #'as yet unclassified' }
EthernetInterface >> macAddress: anEthernetAddress [
	ethernet address: anEthernetAddress.
	device macAddress: anEthernetAddress
]

{ #category : #'as yet unclassified' }
EthernetInterface >> up [
	super up.
	self ethernet arp timerUp.
	self ip tcp timerUp
]
