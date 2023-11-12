"
a DeviceStream is a ReadWriteStream on top of a Device

a Device must understand
#next, #nextPut: , #reopen, #isOpen, #flush, #close, #dataAvailable
"
Class {
	#name : #DeviceStream,
	#superclass : #ReadWriteStream,
	#instVars : [
		'device'
	],
	#category : #'SqueakNOS-FileSupport'
}

{ #category : #'as yet unclassified' }
DeviceStream class >> on: aDevice [
	^ self basicNew device: aDevice
]

{ #category : #'fileIn/Out' }
DeviceStream >> atEnd [
	^ device isOpen not
]

{ #category : #accessing }
DeviceStream >> close [
	device close
]

{ #category : #testing }
DeviceStream >> dataAvailable [
	^ device dataAvailable
]

{ #category : #accessing }
DeviceStream >> device: aDevice [
	device := aDevice
]

{ #category : #accessing }
DeviceStream >> flush [
	device flush
]

{ #category : #'fileIn/Out' }
DeviceStream >> next [
	^ device next
]

{ #category : #'fileIn/Out' }
DeviceStream >> next: anInteger [
	^ device next: anInteger
]

{ #category : #'fileIn/Out' }
DeviceStream >> nextPut: anObject [
	^ device nextPut: anObject
]

{ #category : #accessing }
DeviceStream >> reopen [
	^ device reopen
]
