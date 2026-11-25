'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RemoteObjectChannel category: 'SqueakNOS-FileSupport'!
Object subclass: #RemoteObjectChannel
	instanceVariableNames: 'handle stream object'
	classVariableNames: 'Channels MainChannelStream'
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!RemoteObjectChannel commentStamp: '<historical>' prior: 0!

I'm a channel used on the client side of an RPC communication. I know how to perform: something on a remote object and return the answer. Classes must be mirrored on both images

" To start a remoting server, do the next in a standard squeak."
RemoteObjectChannel stream socket closeAndDestroy.
RemoteObjectChannel waitConnectionsOnPort: 1234.
[RemoteObjectChannel performNext] repeat..

" To connect to a remoting server from a standard Squeak (testing) do:"
RemoteObjectChannel conRemoteObjectChannel stream socket closeAndDestroy.
nectSocketTo: NetNameResolver localHostAddress onPort: 1234

" To setup the remoting client inside SqueakNOS, do the next"
Computer current defaultSerialPort open.
RemoteObjectChannel stream: (DeviceStream on: Computer current defaultSerialPort)

" To test do:"
(RemoteMultiByteStream oldFileNamed: 'TestFile.st') fileIn

" If you want to change default File and Directory classes, edit the next methods:"
activeDirectoryClass
	^ RemoteFileDirectory

concreteStream
	^ RemoteMultiByteFileStream

!

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
forget
	^ self class forgetOnServer: self handle
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
handle
	^ handle
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
handle: anInteger
	handle := anInteger
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
object
	^ object
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
object: anObject
	object := anObject
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector
	^ self remotePerform: aSelector withString: '#()'
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector with: arg1
	^ self remotePerform: aSelector withArguments: (Array with: arg1)
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector with: arg1 with: arg2
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2)
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector with: arg1 with: arg2 with: arg3
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2 with: arg3)
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector with: arg1 with: arg2 with: arg3 with: arg4
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2 with: arg3 with: arg4)
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector withArguments: arguments
	| strm |
	strm := WriteStream on: ''.
	strm nextPut: ${.
	arguments do: [:each |
		strm
			store: each;
			nextPut: $ ;
			nextPut: $.].

	^ self remotePerform: aSelector withString: strm contents allButLast, '}'


! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePerform: aSelector withString: argumentsString
	| answer |
	self stream
		nextPut: $>;	" query "
		int32: self handle;
		string: aSelector;
		string: argumentsString;
		flush.

	[self stream next = $< asciiValue] whileFalse.

	answer := (self stream next: self stream int32) asString.
	^ answer = 'self' ifTrue: [self object] ifFalse: [Compiler evaluate: answer].

! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
stream
	^ stream
! !

!RemoteObjectChannel methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
stream: aStream
	stream := aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RemoteObjectChannel class' category: 'SqueakNOS-FileSupport'!
RemoteObjectChannel class
	instanceVariableNames: 'Channels MainChannelStream'!

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
channels
	"only used in server's side.
	In client side there is no need to mantain the Dictionary, as every Channel knows its handle"
	^ Channels ifNil: [
		Channels := Dictionary new
			at: 0 put: (self new
				handle: 0;
				object: self;
				stream: self stream);
			yourself.
		]
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
connectSocketTo: ipAddress onPort: port
	self stream: (SocketStream openConnectionToHost: ipAddress port: port) binary.

! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
for: anObject using: contructorString
	| handle |
	handle := (self channels at: 0)
		remotePerform: #newOnServerFor:
		withString: '{',contructorString,'}'.

	^ self new
		handle: handle;
		stream: self stream;
		object: anObject

! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
forget: aHandle
	self channels 
		removeKey: aHandle
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
forgetOnServer: aHandle
	" called of client side "
	(self channels at: 0)
		remotePerform: #forget:
		withString: '#(',aHandle printString,')'.
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
installOn: aComputer
	| serial |
	serial := Computer current defaultSerialPort.
	serial ifNil: [^self].
	serial open.
	self stream: (DeviceStream on: serial).
	[[RemoteObjectChannel performNext] repeat] fork.

! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
newHandle
	| answer |
	[answer := SmallInteger maxVal atRandom.
	self channels includesKey: answer] whileTrue.
	^ answer
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
newOnServerFor: anObject
	| handle |
	handle := self newHandle.
	self channels at: handle put: (
		self new
			handle: handle;
			object: anObject).	" no need to set the stream on the server side "
	^ handle
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
objectForHandle: handle
	^ (self channels at: handle ifAbsent: [^ nil]) object
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
performNext
	"server side"
	| strm object selector arguments answer |
	strm := self stream.

	[strm next = $> asciiValue] whileFalse.

	object := strm int32.
	selector := strm string asSymbol.
	arguments := strm string.

	object := self objectForHandle: object.
	arguments := Compiler evaluate: arguments.

	[	answer :=object perform: selector withArguments: arguments.
		answer := answer == object
			ifTrue: [#self]
			ifFalse: [answer storeString].
	]	ifError: [:msg :receiver | answer := 'Error signal: ', msg storeString].

	strm
		nextPut: $<;
		int32: answer size;
		nextPutAll: answer;
		flush.

! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
stream
	^ MainChannelStream
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
stream: aStream
	MainChannelStream := aStream.
	Channels := nil.
! !

!RemoteObjectChannel class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
waitConnectionsOnPort: port
	| s |
	s := Socket new listenOn: port backlogSize: 10.
	self stream: (SocketStream on: (s waitForAcceptFor: 1000)) binary.
! !


