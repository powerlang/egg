"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonParserTest,
	#superclass : #TestCase,
	#category : #'JSON\Tests'
}

{ #category : #private }
JsonParserTest >> testJsonNode [
	| info |
	info := Compiler
		compile: 'm ^<json>{"id": 1, "name": "john"}</json>'
		in: self class.
	self
		assert: (info ast statements anyone expression body ast
			isKindOf: JsonObject)
]

{ #category : #private }
JsonParserTest >> testTP48846 [
	| wrong |
	wrong := '<!DOCTYPE html><html xmlns="http://www.w3.org/1999/xhtml"><head><meta charset="utf-8"><title data-ng-bind="title">Page not found</title><meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no"><meta http-equiv="cache-control" content="max-age=0"><meta http-equiv="cache-control" content="no-cache"><meta http-equiv="expires" content="0"><meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT"><meta http-equiv="pragma" content="no-cache"><link rel="icon" type="image/x-icon" href="content/images/favicon.ico"><link rel="stylesheet" href="content/css/lib.css?1484223512"><link rel="stylesheet" href="content/css/app.css?1484223512"></head><body class="helper-html"><nav class="navbar navbar-fixed-top navbar-inverse ng-scope"><div class="navbar-header"><a href="/" class="navbar-brand" style="padding: 11px 0"><img src="content/images/logos/palantir-logo-inverted.png" style="height: 30px"></a></div><div class="container"></div></nav><div class="container-fluid banner"></div><div class="container"><h1>Page not found</h1><h2>The requested URL <span id="url"></span> was not found on this server.</h2><button class="btn btn-lg btn-primary" onclick="goBack()">Back</button> <a href="/" class="btn btn-lg btn-primary">Home</a></div><script src="content/js/lib.js?1484223512"></script><script>function goBack(){window.history.back()}function getUrlParameter(t){for(var r=window.location.search.substring(1),n=r.split("&"),i=0;i<n.length;i++){var a=n[i].split("=");if(a[0]==t)return a[1]}}$(function(){$("#url").text(getUrlParameter("p"))});</script></body></html>'.
	self
		should: [JsonParser parse: wrong]
		raise: JsonError
		satisfying: [:e | e isResumable not]
		description: 'Default action'
]

