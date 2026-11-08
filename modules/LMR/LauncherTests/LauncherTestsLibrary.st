"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LauncherTestsLibrary,
	#superclass : #ExternalLibrary,
	#category : #'LMR-LauncherTests'
}

{ #category : #callouts }
LauncherTestsLibrary >> labs: anInteger [
	<cdecl: sint64 labs(sint64)>
]

{ #category : #callouts }
LauncherTestsLibrary >> sqrt: aFloat [
	<cdecl: double sqrt(double)>
]

{ #category : #callouts }
LauncherTestsLibrary >> sqrtf: aFloat [
	<cdecl: float sqrtf(float)>
]

{ #category : #callouts }
LauncherTestsLibrary >> stackArguments: a1 a2: a2 a3: a3 a4: a4 a5: a5 a6: a6 a7: a7 a8: a8 a9: a9 a10: a10 a11: a11 a12: a12 [
	<cdecl: sint64 lmrTestStackArguments(sint64, sint64, sint64, sint64, sint64, sint64, sint64, sint64, sint32, sint8, sint16, sint64)>
]

{ #category : #callouts }
LauncherTestsLibrary >> floatArguments: d1 d2: d2 d3: d3 d4: d4 d5: d5 d6: d6 d7: d7 d8: d8 f9: f9 d10: d10 f11: f11 [
	<cdecl: double lmrTestFloatArguments(double, double, double, double, double, double, double, double, float, double, float)>
]

{ #category : #callouts }
LauncherTestsLibrary >> callBack: anAddress times: anInteger [
	<cdecl: sint64 lmrTestCallBack(pointer, sint64)>
]
