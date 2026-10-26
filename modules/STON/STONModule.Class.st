'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONModule category: #STON!
Module subclass: #STONModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
!

!STONModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#Kernel -> {#Error. #Association. #Boolean. #ByteArray. #Closure. #Collection. #Date. #Dictionary. 
		#HashedCollection. #Integer. #Interval. #Module. #Number. #OrderedDictionary. #Point. #SequenceableCollection.
		#String. #Symbol. #Time. #Timestamp. #UndefinedObject. #IdentityDictionary. #MessageNotUnderstood}.
	}
! !

!STONModule methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:39'!
justLoaded
	super justLoaded.
	STONWriter initialize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONModule class' category: #STON!
STONModule class
	instanceVariableNames: ''!


