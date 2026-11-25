'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #InlineMessageLinker category: #Nativization!
MessageLinker subclass: #InlineMessageLinker
	instanceVariableNames: 'assembler map'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleAsFloatInto
	#_asFloatInto:.
	assembler
		loadX0withRasDouble;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleAsNative
	| noninteger |
	#_asNative.
	noninteger := assembler labeledIntegerBitTestOfR.
	assembler
		convertRtoNativeInteger;
		@ noninteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleAsObject
	#_asObject.
	assembler clearSafeRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleAsPointer
	| nonInteger |
	#_asPointer.
	nonInteger := assembler labeledIntegerBitTestOfR.
	assembler
		convertRtoNativeInteger;
		@ nonInteger;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleAsSmallInteger
	#_asSmallInteger.
	assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicAt
	| oop |
	#_basicAt:.
	oop := assembler labeledIntegerNativizationOfA.
	assembler
		loadRwithRatA;
		@ oop
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicAtPut
	| nonInteger |
	#_basicAt:put:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeTinRatA;
		@ nonInteger;
		loadRwithT
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicCopyFromToWith
	#_basicCopyFrom:to:with:.
	assembler
		pushE;
		convertAtoNativeInteger;
		convertTtoNativeInteger;
		loadEwithAddressOfRatA;
		loadSwithAddressOfSatA;
		subAfromT;
		addTwithImmediate: 1;
		moveTslots;
		popE
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicFlags
	#_basicFlags.
	self emitByteAtOffset: _Flags
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicFlagsPut
	#_basicFlags:.
	self emitByteAtOffsetPut: _Flags
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicHash
	#_basicHash.
	assembler
		loadZeroExtendShortRwithRoffset: _Hash;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicHashPut
	| nonInteger |
	#_basicHash:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeShortAinRoffset: _Hash;
		@ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicSize
	#_smallSize.
	self emitByteAtOffset: _SmallSize
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicSizePut
	#_smallSize:.
	self emitByteAtOffsetPut: _SmallSize
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicULongAt
	| nonInteger |
	#_basicULongAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		loadZeroExtendLongRwithRatA;
		@ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBasicULongAtPut
	| nonInteger |
	#_basicULongAt:put:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeLongTinRatA;
		@ nonInteger;
		loadRwithT
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBeCurrent
	#_beCurrent.
	assembler
		loadRwithRindex: 1;
		clearSafeRintegerBit;
		loadFPwithR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBeEnvironment
	#_beEnvironment.
	assembler loadEwithR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBeFramePointer
	#_beFramePointer.
	assembler storeRinFPindex: 1
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBitShiftLeft
	| success |
	#_bitShiftLeft:.
	success := assembler newLabel.
	assembler
		loadTwithA;
		loadAwithR;
		clearSafeRintegerBit;
		convertTtoNativeInteger;
		shiftLeftRwithT;
		setSafeRintegerBit;
		pushR;
		shiftRightRwithT;
		setSafeRintegerBit;
		compareRwithA;
		popR;
		shortJumpIfEqualTo: success;
		loadRwithNil;
		@ success
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBitShiftRight
	#_bitShiftRight:.
	assembler
		move: assembler regA to: assembler regT;
		convertToNativeInteger: assembler regT;
		shiftRightArithmetic: assembler regR by: assembler regT b;
		setIntegerBit: assembler regR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBusyWait
	| loop |
	#_busyWait.
	loop := assembler newLabel.
	assembler
		loadTwithImmediate: 0;
		@ loop;
		exchangeRindirectWithT;
		compareTwithImmediate: 0;
		shortJumpIfEqualTo: loop
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleByteAt
	| nonInteger |
	#_byteAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		loadZeroExtendByteRwithRatA;
		convertRtoSmallInteger;
		@ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleByteAtPut
	| nonInteger1 nonInteger2 |
	#_byteAt:put:.
	nonInteger1 := assembler labeledIntegerNativizationOfA.
	nonInteger2 := assembler labeledIntegerNativizationOfT.
	assembler
		storeByteTinRatA;
		@ nonInteger1;
		@ nonInteger2;
		loadRwithT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleCDeclCallWithArguments
	#_cdeclCallWithArguments:.
	assembler
		loadZeroExtendByteTwithAindex: _SmallSize + 1;
		shiftTright: assembler wordSizeShift;
		pushS;
		saveCallerFrame;
		subTslotsToSP;
		assemble: 'and' with: assembler regSP with: -16;
		loopTtimes: [ assembler
				load: assembler regS
				fromMem: assembler memRefAatT;
				store: assembler regS
				intoMem: assembler memRefSPatT ].
	assembler addressSize = 8
		ifTrue: [ self loadArgumentsIntoRegisters ].
	assembler
		callR;
		restoreCallerFrame;
		popS
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleCallWithArguments
	#_stdcallWithArguments:.
	assembler
		loadZeroExtendByteTwithAindex: _SmallSize + 1;
		shiftTright: assembler wordSizeShift;
		loopTtimes: [ assembler pushAatToffset: 0 - assembler addressSize ].
	assembler addressSize = 8
		ifTrue: [ self loadArgumentsIntoRegisters ].
	assembler callR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleEnvironment
	#_environment.
	assembler loadRwithE
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleExpandInStackSized
	#_expandInStackSized:.
	assembler
		convertAtoNativeInteger;
		loadTwithA;
		loopTtimes: [ assembler
				pushIndirectR;
				addRwithImmediate: assembler wordSize ]
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleExtendedSize
	#_largeSize.
	assembler
		loadZeroExtendLongRwithRindex: _ExtendedSize;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatEquals
	"
	first compare magnitudes to set error bit if NaN
	"
	#_floatEquals:.
	assembler
		pushR;
		loadLargeX0withRindirect;
		compareLessThanDoubleX0withAindirect;
		popR;
		loadLargeX0withRindirect;
		compareEqualDoubleX0withAindirect;
		moveX0toR;
		addRwithImmediate: 1;
		convertRtoSmallInteger.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatFractionPartInto
	#_floatFractionPartInto:.
	assembler
		loadLargeX0withRindirect;
		roundDoubleX0intoX1;
		subDoubleX1fromX0;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatLessThan
	#_floatLessThan:.
	assembler
		loadLargeX0withRindirect;
		compareLessThanDoubleX0withAindirect;
		moveX0toR;
		addRwithImmediate: 1;
		convertRtoSmallInteger.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatMinusInto
	#_floatMinus:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		subDoubleX1fromX0;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatMultiplyInto
	#_floatMultiply:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		multiplyDoubleX0byX1;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatPlusInto
	#_floatPlus:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		addDoubleX1toX0;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatQuotientInto
	#_floatQuotient:into:.
	assembler
		loadLargeX0withRindirect;
		loadLargeX1withAindirect;
		divideDoubleX0byX1;
		storeLargeX0inT.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatSqrtInto
	#_floatSqrtInto:.
	assembler
		loadLargeX0withRindirect;
		sqrtDoubleX0;
		storeLargeX0inA.
	self readFloatStatus
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFloatTruncated
	#_floatTruncated.
	assembler loadRconvertingDoublePointedByR.
	self readFloatStatus.
	assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleFramePointer
	#_framePointer.
	assembler loadRwithFPindex: 1
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleGetTIBValue
	| nonInteger |
	#_getThreadInformationBlockValue.
	nonInteger := assembler labeledIntegerNativizationOfR.
	assembler
		loadRwithTIBatR;
		@ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleGetThreadValue
	| nonInteger uninitialized |
		#_getThreadValue.
	nonInteger := assembler labeledIntegerNativizationOfR.
	uninitialized := assembler newLabel.
	assembler
		loadRwithThreadVariableAtR;
		compareRwithImmediate: 0;
		shortJumpIfEqualTo: uninitialized.
	assembler
		jumpOver: [ assembler
				@ uninitialized;
				@ nonInteger;
				loadRwithNil ]
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleHigh16
	#_high16.
	assembler wordSize > 4
		ifTrue: [ assembler clearRhigh32 ].
	assembler
		shiftRright: 15;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleHigh32
	#_high32.
	assembler
		shiftLogicalRright: 31;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleHoldRefererIfNeeded
	#_holdRefererIfNeeded:.
	assembler
		pushA;
		loadAwithGlobal: #WriteBarrier;
		callIndirectA;
		popA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleIntegerMultiplyByInto
	#_integerMultiplyBy:into:.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		multiplyRbyAwideningToA;
		storeRinTindex: 1;
		storeAinTindex: 2;
		loadRwithT
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleInvoke
	#_invoke:.
	assembler
		loadMwithA;
		callIndirectM
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleLeadingZeroBitCount
	#_leadingZeroBitCount.
	assembler
		convertRtoNativeInteger;
		leadingRzeroCount;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleLoadFloatStatusFrom
	#_status:.
	assembler loadMXCSRfromA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleLow16
	#_low16.
	assembler
		andRwithImmediate: 16rFFFF;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleLow32
	#_low32.
	assembler wordSize > 4
		ifTrue: [ assembler
				andRwithImmediate: 16rFFFFFFFF;
				convertRtoSmallInteger ]
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleNativeHalt
	#_halt.
	assembler breakpoint
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleNilSlots
	#_nilSlots:.
	assembler
		pushE;
		loadEwithR;
		loadRwithNil;
		loadTwithA;
		convertTtoNativeInteger;
		writeTslots;
		popE
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleObjectAtOffset
	| nonInteger1 |
	#_objectAtOffset:.
	nonInteger1 := assembler labeledIntegerNativizationOfA.
	assembler
		loadRwithRatOffsetA;
		@ nonInteger1
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleObjectAtOffsetPut
	| oop |
	#_objectAtOffset:put:.
	oop := assembler labeledIntegerNativizationOfA.
	assembler
		storeTinRatOffsetA;
		@ oop;
		loadRwithT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleOop
	#_oop.
	^ assembler convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleQuotientTowardZero
	#_quotientTowardZero:.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		extendRtoAandDividebyT;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleRelease
	#_release.
	assembler
		lock;
		decRindirect
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleRemainderTowardZero
	| adapt convert |
	#_remainderTowardZero:.
	adapt := assembler newLabel.
	convert := assembler newLabel.
	assembler
		convertRtoNativeInteger;
		convertAtoNativeInteger;
		loadTwithA;
		xorAwithR;
		jumpIfSignTo: adapt;
		extendRtoAandDividebyT;
		loadRwithA;
		jumpTo: convert;
		@ adapt;
		extendRtoAandDividebyT;
		loadRwithA;
		testRwithR;
		jumpIfZeroTo: convert;
		addTtoR;
		@ convert;
		convertRtoSmallInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleRestore
	#_restore.
	assembler loadEwithR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleRestoreAndTransferControlWithContext
	#_restoreAndTransferControlWithContext:.
	assembler
		clearSafeRintegerBit;
		loadFPwithR;
		loadSPwithFP;
		loadRwithA;
		clearSafeRintegerBit;
		loadFPwithR;
		popR;
		loadEwithR;
		restoreCallerSelf;
		restoreCallerM;
		loadRwithS;
		return: 0
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleRestoreWithContext
	#_restoreWithContext:.
	assembler
		clearSafeRintegerBit;
		loadFPwithR;
		loadSPwithFP;
		loadRwithA;
		clearSafeRintegerBit;
		loadFPwithR
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleSaveCurrentEnvironment
	#_saveCurrentEnvironment.
	assembler
		clearSafeRintegerBit;
		pushE;
		popT;
		storeTinRindex: 1;
		setSafeRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleSetTIBValue
	#_setThreadInformationBlockValue:.
	assembler
		convertRtoNativeInteger;
		storeTIBatRwithA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleSetThreadValue
	| nonInteger |
	#_setThreadValue:.
	nonInteger := assembler labeledIntegerNativizationOfR.
	assembler
		storeAinThreadVariableAtIndexR;
		convertRtoSmallInteger.
	assembler @ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleSmallIntegerByteAt
	| nonInteger |
	#_smallIntegerByteAt:.
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		convertRtoNativeInteger;
		pushR;
		loadZeroExtendByteRwithSPatA;
		convertRtoSmallInteger;
		popA;
		@ nonInteger
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleStoreDoubleResult
	#_storeDoubleResult.
	assembler storeDoubleResultInRindirect
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleStoreFloatStatusInto
	#_readStatusOn:.
	assembler storeMXCSRintoA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleTestSmallInteger
	| integer |
	#_isSmallInteger.
	integer := assembler newLabel.
	assembler
		testRintegerBit;
		loadRwithTrue;
		shortJumpIfNotZeroTo: integer;
		loadRwithFalse;
		@ integer
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleThisContext
	#_thisContext.
	assembler loadRwithFP setRintegerBit
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleTimesTwoPower
	#_timesTwoPower:.
	assembler clearFPUFlags scaleFloatOnRWithA clearFPUFlags
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleTransferControlDiscardingLastArgTo
	#_transferControlDiscardingLastArgTo:.
	assembler
		restoreCallerFrame;
		popSPindirect;
		loadMwithA;
		jumpToMindex: 1
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleTransferControlTo
	#_transferControlTo:.
	assembler restoreCallerFrame; loadMwithA; jumpToMindex: 1
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULargeAtOffset
	| overflow1 overflow2 end |
	#_uLargeAtOffset:.
	overflow1 := assembler newLabel.
	overflow2 := assembler newLabel.
	end := assembler newLabel.
	assembler
		convertAtoNativeInteger;
		loadRwithRatOffsetA;
		shiftRleft: 1;
		shortJumpIfCarryTo: overflow1;
		shortJumpIfSignTo: overflow2;
		setRintegerBit;
		shortJumpTo: end.
	assembler
		@ overflow1;
		@ overflow2;
		loadRwithNil;
		@ end
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULargeAtOffsetInto
	#_uLargeAtOffset:into:.
	assembler
		convertAtoNativeInteger;
		loadAwithRoffsetAtA;
		storeAinTindex: 1;
		loadRwithT
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULargeAtOffsetPut
	| end notSmall |
	#_uLargeAtOffset:put:.
	notSmall := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end;
		@ notSmall;
		loadTwithTindex: 1;
		@ end;
		storeTinRatOffsetA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULongAtOffset
	| overflow1 overflow2 end |
	#_uLongAtOffset:.
	overflow1 := assembler newLabel.
	overflow2 := assembler newLabel.
	end := assembler newLabel.
	assembler
		convertAtoNativeInteger;
		loadLongRwithRatOffsetA;
		shiftRleft: 1;
		shortJumpIfCarryTo: overflow1;
		shortJumpIfSignTo: overflow2;
		setRintegerBit;
		shortJumpTo: end.
	assembler
		@ overflow1;
		@ overflow2;
		loadRwithNil;
		@ end
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULongAtOffsetInto
	#_uLongAtOffset:into:.
	assembler
		convertAtoNativeInteger;
		loadLongRwithRatOffsetA;
		storeRinTindex: 1;
		loadRwithT
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleULongAtOffsetPut
	| end oop |
	#_uLongAtOffset:put:.
	oop := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end;
		@ oop;
		loadTwithTindex: 1;
		@ end;
		storeLongTinRatOffsetA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleUShortAtOffsetPut
	| end notSmall |
	#_uShortAtOffset:put:.
	notSmall := assembler
		convertAtoNativeInteger;
		labeledIntegerBitTestOfT.
	end := assembler newLabel.
	assembler
		convertTtoNativeInteger;
		shortJumpTo: end.
	assembler
		@ notSmall;
		loadTwithTindex: 1;
		@ end;
		storeShortTinRatOffsetA
! !

!InlineMessageLinker methodsFor:  'private - assemble' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleZeroSlots
	#_zeroSlots:.
	assembler
		pushE;
		loadEwithR;
		loadRwithImmediate: 0;
		loadTwithA;
		convertTtoNativeInteger;
		writeTslots;
		popE
! !

!InlineMessageLinker methodsFor:  'private - helpers' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitByteAtOffset: offset
	assembler
		loadZeroExtendByteRwithRindex: offset + 1;
		convertRtoSmallInteger 
! !

!InlineMessageLinker methodsFor:  'private - helpers' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitByteAtOffsetPut: offset
	| nonInteger |
	nonInteger := assembler labeledIntegerNativizationOfA.
	assembler
		storeByteAinRindex: offset + 1;
		@ nonInteger 
! !

!InlineMessageLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSend: aSymbol using: anAssembler
	| arity selector | 
	assembler := anAssembler.
	arity := aSymbol arity. 
	arity > 2 ifTrue: [assembler pop: assembler regS].
	arity > 1 ifTrue: [assembler pop: assembler regT].
	arity > 0 ifTrue: [assembler pop: assembler regA].
	self ASSERT: arity <= 3 .
	selector := map at: aSymbol.
	self perform: selector
! !

!InlineMessageLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSendDebuggable: aSymbol using: anAssembler
	self emitSend: aSymbol using: anAssembler 
! !

!InlineMessageLinker methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	map := Dictionary new.
	self class supported do:[:each|map add: each].
	self filter: map keys asIdentitySet

	"
	InlineMessageLinker new
	"

! !

!InlineMessageLinker methodsFor:  'private - helpers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadArgumentsIntoRegisters
	| stack1 stack2 stack3 stack4 |
	stack1 :=assembler memRef: rsp indexImm: 1.
	stack2 :=assembler memRef: rsp indexImm: 2.
	stack3 :=assembler memRef: rsp indexImm: 3.
	stack4 :=assembler memRef: rsp indexImm: 4.
	assembler
		load: rcx fromMem: stack1;
		load: rdx fromMem: stack2;
		load: r8 fromMem: stack3;
		load: r9 fromMem: stack4;
		assemble: 'movq' with: xmm0 with: rcx;
		assemble: 'movq' with: xmm1 with: rdx;
		assemble: 'movq' with: xmm2 with: r8;
		assemble: 'movq' with: xmm3 with: r9
! !

!InlineMessageLinker methodsFor:  'private - helpers' stamp: 'KenD 28/Jun/2026 13:27:40'!
readFPUStatus
	assembler
		loadAwithKnown: #FloatStatus;
		readFPUStatusOnA
! !

!InlineMessageLinker methodsFor:  'private - helpers' stamp: 'KenD 28/Jun/2026 13:27:40'!
readFloatStatus
	assembler
		loadAwithKnown: #FloatStatus;
		storeMXCSRintoA
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InlineMessageLinker class' category: #Nativization!
InlineMessageLinker class
	instanceVariableNames: ''!

!InlineMessageLinker class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeInlineMessageLinkerFlags
	self addNamespaceAs: #InlineMessageLinkerFlags.
	InlineMessageLinkerFlags
		at: #_Flags put: -5;
		at: #_SmallSize put: -6;
		at: #_Hash put: -8;
		at: #_Reserved put: -2;
		at: #_ExtendedSize put: -3.

! !

!InlineMessageLinker class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
supported
	| selectors |
	selectors := self organization selectorsFor: #'private - assemble'.
	^selectors collect: [:selector | | cm key |
		cm := self >> selector.
		key := cm literals detect: [:each | each isSymbol and:[each first == $_ ]].
		key -> selector]. 

	"
	InlineMessageLinker supported
	"

! !


InlineMessageLinker initialize!

