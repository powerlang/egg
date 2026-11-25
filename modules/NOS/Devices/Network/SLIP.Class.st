'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #SLIP category: 'SqueakNOS-Net-Devices'!
InternalNetworkDevice subclass: #SLIP
	instanceVariableNames: 'stream'
	classVariableNames: 'END ESC ESCEND ESCESC'
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!SLIP commentStamp: '<historical>' prior: 0!

To start a SLIP on a normal Squeak in Linux:

1. inside Squeak inspect "SLIP on: (FileStream oldFileNamed: '/dev/ptya0')"
2. open a shell as root
3. be sure that slip is installed in current kernel. check 'dmesg' and/or 'lsmod' output. If it's not, 'insmod slip' should be enough.
4. in the shell: 'slattach -m -L -p slip ttya0 &'
5. in the shell: 'ifconfig sl0 192.168.217.2'  "the IP address must be in an unused network"
6. in the shell: 'route add -net 192.168.217.0 netmask 255.255.255.0 sl0'

!

!SLIP methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
close
	stream close
! !

!SLIP methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	mtu := 296
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SLIP class' category: 'SqueakNOS-Net-Devices'!
SLIP class
	instanceVariableNames: 'END ESC ESCEND ESCESC'!

!SLIP class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	END := Character value: 8r300.
	ESC := Character value: 8r333.
	ESCEND := Character value: 8r334.
	ESCESC := Character value: 8r335.
! !

!SLIP class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
on: aStream
	^ self new stream: aStream
! !


SLIP initialize!

