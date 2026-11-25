'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ExceptionHandler category: #Kernel!
Object subclass: #ExceptionHandler
	instanceVariableNames: 'filter previous handlerBlock protectedBlock return'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ExceptionHandler commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateFor: anException
	^handlerBlock argumentCount = 0
		ifTrue: [handlerBlock value]
		ifFalse: [handlerBlock value: anException]
! !

!ExceptionHandler methodsFor:  'activation' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateProtectedBlock
	return := [:result | ^result].
	^protectedBlock value
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
findHandlerFor: anException
	| handler |
	handler := self.
	[handler notNil] whileTrue: [
		(handler handles: anException) ifTrue: [^handler].
		handler := handler nextHandler].
	^nil
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
handle: anException
	| result |
	Processor activeProcess
		useExceptionHandler: previous
		while: [result := self evaluateFor: anException].
	anException reset.
	self return: result
! !

!ExceptionHandler methodsFor:  'activation' stamp: 'KenD 28/Jun/2026 13:27:38'!
handle: exceptionClass with: hBlock during: pBlock
	| result active |
	filter := exceptionClass.
	handlerBlock := hBlock.
	protectedBlock := pBlock.
	active := Processor activeProcess.
	previous := active exceptionHandler.
	active
		useExceptionHandler: self
		while: [[
			result := self evaluateProtectedBlock.
			self shouldRetry: result] whileTrue].
	^result
! !

!ExceptionHandler methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
handles: anException
	^filter includesException: anException
! !

!ExceptionHandler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextHandler
	^previous
! !

!ExceptionHandler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextHandlerFor: anException
	^previous notNil ifTrue: [previous findHandlerFor: anException]
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: self class name withArticle; cr;
		nextPutAll: ' for ';
		nextPutAll: filter printString; cr;
		nextPutAll: ' with handler '; cr;
		nextPutAll: handlerBlock printString; cr;
		nextPutAll: ' and protected block '; cr;
		nextPutAll: protectedBlock printString; cr;
		nextPutAll: ' returning ';
		nextPutAll: return printString; cr;
		nextPutAll: ' previous handler ';
		nextPutAll: previous printString; cr
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
retry
	self return: self retryToken
! !

!ExceptionHandler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
retryToken
	^return
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
retryUsing: aBlock
	protectedBlock := aBlock.
	self retry
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
return: result
	return value: result
! !

!ExceptionHandler methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldRetry: anObject
	^anObject == self retryToken
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExceptionHandler class' category: #Kernel!
ExceptionHandler class
	instanceVariableNames: ''!

!ExceptionHandler class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
handle: exceptionClass with: handlerBlock during: userBlock
	^self new handle: exceptionClass with: handlerBlock during: userBlock
! !

!ExceptionHandler class methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldBeHidden: aSymbol
	^true
! !


