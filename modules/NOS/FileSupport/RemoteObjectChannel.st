"
I'm a channel used on the client side of an RPC communication. I know how to perform: something on a remote object and return the answer. Classes must be mirrored on both images

"" To start a remoting server, do the next in a standard squeak.""
RemoteObjectChannel stream socket closeAndDestroy.
RemoteObjectChannel waitConnectionsOnPort: 1234.
[RemoteObjectChannel performNext] repeat..

"" To connect to a remoting server from a standard Squeak (testing) do:""
RemoteObjectChannel conRemoteObjectChannel stream socket closeAndDestroy.
nectSocketTo: NetNameResolver localHostAddress onPort: 1234

"" To setup the remoting client inside SqueakNOS, do the next""
Computer current defaultSerialPort open.
RemoteObjectChannel stream: (DeviceStream on: Computer current defaultSerialPort)

"" To test do:""
(RemoteMultiByteStream oldFileNamed: 'TestFile.st') fileIn

"" If you want to change default File and Directory classes, edit the next methods:""
activeDirectoryClass
	^ RemoteFileDirectory

concreteStream
	^ RemoteMultiByteFileStream

"
Class {
	#name : #RemoteObjectChannel,
	#superclass : #Object,
	#instVars : [
		'handle',
		'stream',
		'object'
	],
	#classVars : [
		'Channels',
		'MainChannelStream'
	],
	#category : #'SqueakNOS-FileSupport'
}

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> channels [
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
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> connectSocketTo: ipAddress onPort: port [
	self stream: (SocketStream openConnectionToHost: ipAddress port: port) binary.

]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> for: anObject using: contructorString [
	| handle |
	handle := (self channels at: 0)
		remotePerform: #newOnServerFor:
		withString: '{',contructorString,'}'.

	^ self new
		handle: handle;
		stream: self stream;
		object: anObject

]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> forget: aHandle [
	self channels 
		removeKey: aHandle
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> forgetOnServer: aHandle [
	" called of client side "
	(self channels at: 0)
		remotePerform: #forget:
		withString: '#(',aHandle printString,')'.
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> installOn: aComputer [
	| serial |
	serial := Computer current defaultSerialPort.
	serial ifNil: [^self].
	serial open.
	self stream: (DeviceStream on: serial).
	[[RemoteObjectChannel performNext] repeat] fork.

]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> newHandle [
	| answer |
	[answer := SmallInteger maxVal atRandom.
	self channels includesKey: answer] whileTrue.
	^ answer
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> newOnServerFor: anObject [
	| handle |
	handle := self newHandle.
	self channels at: handle put: (
		self new
			handle: handle;
			object: anObject).	" no need to set the stream on the server side "
	^ handle
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> objectForHandle: handle [
	^ (self channels at: handle ifAbsent: [^ nil]) object
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> performNext [
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

]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> stream [
	^ MainChannelStream
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> stream: aStream [
	MainChannelStream := aStream.
	Channels := nil.
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel class >> waitConnectionsOnPort: port [
	| s |
	s := Socket new listenOn: port backlogSize: 10.
	self stream: (SocketStream on: (s waitForAcceptFor: 1000)) binary.
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> forget [
	^ self class forgetOnServer: self handle
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> handle [
	^ handle
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> handle: anInteger [
	handle := anInteger
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> object [
	^ object
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> object: anObject [
	object := anObject
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector [
	^ self remotePerform: aSelector withString: '#()'
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector with: arg1 [
	^ self remotePerform: aSelector withArguments: (Array with: arg1)
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector with: arg1 with: arg2 [
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2)
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector with: arg1 with: arg2 with: arg3 [
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2 with: arg3)
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector with: arg1 with: arg2 with: arg3 with: arg4 [
	^ self remotePerform: aSelector withArguments: (Array with: arg1 with: arg2 with: arg3 with: arg4)
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector withArguments: arguments [
	| strm |
	strm := WriteStream on: ''.
	strm nextPut: ${.
	arguments do: [:each |
		strm
			store: each;
			nextPut: $ ;
			nextPut: $.].

	^ self remotePerform: aSelector withString: strm contents allButLast, '}'


]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> remotePerform: aSelector withString: argumentsString [
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

]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> stream [
	^ stream
]

{ #category : #'as yet unclassified' }
RemoteObjectChannel >> stream: aStream [
	stream := aStream
]
