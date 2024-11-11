Extension { #name : 'MetaclassSpec' }

{ #category : '*Powerlang-EggWebside-Base' }
MetaclassSpec >> definition [

	^ self name , ' instanceVariableNames: '
	  , (' ' join: instVarNames) storeString
]

