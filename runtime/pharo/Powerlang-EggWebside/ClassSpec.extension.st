Extension { #name : 'ClassSpec' }

{ #category : '*Powerlang-EggWebside-Base' }
ClassSpec >> definition [

	| definition |
	definition := supername , ' subclass: #' , name , '
	instVarNames: ' , (' ' join: instVarNames) storeString , '
	classVarNames: ' , (' ' join: self classVarNames) storeString , '
	sharedPools: ' , (' ' join: sharedPools) storeString.

	^ definition
]

