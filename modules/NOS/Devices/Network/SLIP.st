"
To start a SLIP on a normal Squeak in Linux:

1. inside Squeak inspect ""SLIP on: (FileStream oldFileNamed: '/dev/ptya0')""
2. open a shell as root
3. be sure that slip is installed in current kernel. check 'dmesg' and/or 'lsmod' output. If it's not, 'insmod slip' should be enough.
4. in the shell: 'slattach -m -L -p slip ttya0 &'
5. in the shell: 'ifconfig sl0 192.168.217.2'  ""the IP address must be in an unused network""
6. in the shell: 'route add -net 192.168.217.0 netmask 255.255.255.0 sl0'

"
Class {
	#name : #SLIP,
	#superclass : #InternalNetworkDevice,
	#instVars : [
		'stream'
	],
	#classVars : [
		'END',
		'ESC',
		'ESCEND',
		'ESCESC'
	],
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #initialization }
SLIP class >> initialize [
	END := Character value: 8r300.
	ESC := Character value: 8r333.
	ESCEND := Character value: 8r334.
	ESCESC := Character value: 8r335.
]

{ #category : #'instance creation' }
SLIP class >> on: aStream [
	^ self new stream: aStream
]

{ #category : #control }
SLIP >> close [
	stream close
]

{ #category : #initialization }
SLIP >> initialize [
	super initialize.
	mtu := 296
]
