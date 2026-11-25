'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!


!Module methodsFor:  '*Tonel' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeSourceTo: aDirectoryPath
	| writer |
	self classes do: [:cls |
		| filename contents |
		contents := TonelWriter writeClass: cls category: self name.
		filename := aDirectoryPath, '/', cls name, '.st'.
		Kernel writeFile: filename contents: contents].
	self writeExtensionsTo: aDirectoryPath.
	self writeModuleClassTo: aDirectoryPath
! !

!Module methodsFor:  '*Tonel' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeExtensionsTo: aDirectoryPath
	extensions keysAndValuesDo: [:key :methods |
		| filename contents |
		contents := TonelWriter writeMethods: methods.
		filename := aDirectoryPath, '/', (key copyReplacing: ' ' with: '.'), '.st'.
		Kernel writeFile: filename contents: contents]
! !

!Module methodsFor:  '*Tonel' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeModuleClassTo: aDirectoryPath
	| cls filename contents |
	cls := self class.
	contents := TonelWriter writeClass: cls category: self name.
	filename := aDirectoryPath, '/', cls name, '.st'.
	Kernel writeFile: filename contents: contents
! !


