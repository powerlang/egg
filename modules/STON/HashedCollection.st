"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #HashedCollection}

{#category : '*STON'}
HashedCollection >> stonPostReferenceResolution [
	self rehash
]

