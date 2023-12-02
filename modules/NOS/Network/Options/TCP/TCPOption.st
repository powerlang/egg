"
see class methods
http://www.networkcomputing.com/1003/1003ws1.html

Options:  variable

    Options may occupy space at the end of the TCP header and are a
    multiple of 8 bits in length.  All options are included in the
    checksum.  An option may begin on any octet boundary.  There are two
    cases for the format of an option:

      Case 1:  A single octet of option-kind.

      Case 2:  An octet of option-kind, an octet of option-length, and
               the actual option-data octets.

    The option-length counts the two octets of option-kind and
    option-length as well as the option-data octets.

    Note that the list of options may be shorter than the data offset
    field might imply.  The content of the header beyond the
    End-of-Option option must be header padding (i.e., zero).

    A TCP must implement all options.


                                                               [Page 17]


                                                          September 1981
Transmission Control Protocol
Functional Specification



    Currently defined options include (kind indicated in octal):

      Kind     Length    Meaning
      ----     ------    -------
       0         -       End of option list.
       1         -       No-Operation.
       2         4       Maximum Segment Size.
      

    Specific Option Definitions

      End of Option List

        +--------+
        |00000000|
        +--------+
         Kind=0

        This option code indicates the end of the option list.  This
        might not coincide with the end of the TCP header according to
        the Data Offset field.  This is used at the end of all options,
        not the end of each option, and need only be used if the end of
        the options would not otherwise coincide with the end of the TCP
        header.

      No-Operation

        +--------+
        |00000001|
        +--------+
         Kind=1

        This option code may be used between options, for example, to
        align the beginning of a subsequent option on a word boundary.
        There is no guarantee that senders will use this option, so
        receivers must be prepared to process options even if they do
        not begin on a word boundary.

      Maximum Segment Size

        +--------+--------+---------+--------+
        |00000010|00000100|   max seg size   |
        +--------+--------+---------+--------+
         Kind=2   Length=4






[Page 18]                                                               


September 1981                                                          
                                           Transmission Control Protocol
                                                Functional Specification



        Maximum Segment Size Option Data:  16 bits

          If this option is present, then it communicates the maximum
          receive segment size at the TCP which sends this segment.
          This field must only be sent in the initial connection request
          (i.e., in segments with the SYN control bit set).  If this
          option is not used, any segment size is allowed.

"
Class {
	#name : #TCPOption,
	#superclass : #Object,
	#category : 'SqueakNOS-Net-Options-TCP'
}

{ #category : #'instance creation' }
TCPOption class >> bytes: aByteArray offset: anInteger [
	| type |
	type := aByteArray at: anInteger + 1.
	self allSubclassesDo: [ :each |
		type = each type ifTrue: [^ each new bytes: aByteArray; offset: anInteger]].
	^ super bytes: aByteArray offset: anInteger
]

{ #category : #accessing }
TCPOption class >> length [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
TCPOption class >> new [
	^ self bytes: ((ByteArray new: self length) at: 1 put: self type; at: 2 put: self length; yourself)
]

{ #category : #accessing }
TCPOption class >> type [
	^ nil
]

{ #category : #testing }
TCPOption >> isEOL [
	^ self type = 0
]

{ #category : #testing }
TCPOption >> isNOP [
	^ self type = 1
]

{ #category : #accessing }
TCPOption >> name [
	^ #(End Noop MSS WSopt sackOK SACK six seven TSopt) at: self type + 1 ifAbsent: [super name]
]
