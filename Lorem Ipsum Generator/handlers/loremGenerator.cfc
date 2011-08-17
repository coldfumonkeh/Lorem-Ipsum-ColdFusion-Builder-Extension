<!---
Filename: loremGenerator.cfc
Creation Date: 18/March/2010
Original Author: Matt Gifford aka coldfumonkeh http://www.mattgifford.co.uk/
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
the loremGenerator class used to pull dummy text.
Based on the LoremIpsum CFC created by Tim Blair
--->
<cfcomponent displayname="loremGenerator" output="false">

	<cfset variables.instance = structNew() />

	<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the loremGenerator Class.">
		<cfargument name="startWithLorem" type="boolean" required="false" default="true" hint="Set to true, will ensure returned data starts with 'Lorem ipsum.'" />
			<cfscript>
				variables.instance.URI = 'http://www.lipsum.com/feed/xml';
				setStart(arguments.startWithLorem);
			</cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setStart" 	access="private" output="false" hint="I set the start value into the variables.instance scope.">
    	<cfargument name="startWithLorem" type="boolean" required="false" default="true" hint="Set to true, will ensure returned data starts with 'Lorem ipsum.'" />
		<cfset variables.instance.start = arguments.startWithLorem />
    </cffunction>
		
	<!--- ACCESSORS --->
	<cffunction name="getURI" 	access="private" output="false" returntype="String" hint="I return the URI from the variables.instance scope.">
    	<cfreturn variables.instance.URI />
    </cffunction>
	
	<cffunction name="getStart" access="private" output="false" hint="I return the start value from the variables.instance scope.">
    	<cfreturn variables.instance.start />
    </cffunction>

	<!--- PUBLIC METHODS --->
	<cffunction name="getText" 	access="public" output="false" returntype="array" hint="I return the requested dummy text.">
    	<cfargument name="start" 	required="false" 	type="boolean"	default="#getStart()#" 	hint="Should the text start with 'Lorem Ipsum'?" />
		<cfargument name="method" 	required="true" 	type="String" 							hint="The method to get the text." />
		<cfargument name="number" 	required="true" 	type="Numeric" 	default="2"				hint="The total number to return." />
			<cfset var strMethod = '' />
				<cfif NOT isNumeric(arguments.number)>
					<cfset arguments.number = 2 />
				</cfif>
				<cfswitch expression="#arguments.method#">
					<cfcase value="words">
						<cfreturn remoteCall('words', arguments.number, arguments.start) />
					</cfcase>
					<cfcase value="bytes">
						<cfreturn remoteCall('bytes', arguments.number,  arguments.start) />
					</cfcase>
					<cfdefaultcase>
						<cfreturn remoteCall('paras', arguments.number,  arguments.start) />
					</cfdefaultcase>
				</cfswitch>
    </cffunction>
	
	<!--- PRIVATE METHODS --->
	<cffunction name="remoteCall" access="private" returntype="array" output="no" hint="Performs the request to grab the Lorem Ipsum text from the remote server.">
		<cfargument name="method" type="string" 	required="yes" 	hint="The request limit type (paras, words, bytes)." />
		<cfargument name="number" type="numeric" 	required="yes" 	hint="The limit of [type] to return." />
		<cfargument name="start"  type="boolean"	required="yes" 	hint="Should the text start with 'Lorem Ipsum'?" />
			<cfset var strURI 		= buildURL(arguments.method, arguments.number,  arguments.start) />
			<cfset var xmlLipsum 	= '' />
			<cfhttp url="#strURI#" method="get"></cfhttp>
			<cfset xmlLipsum = xmlparse(cfhttp.filecontent).feed.lipsum.xmltext />
		<!--- split into paragraphs and return --->
		<cfreturn xmlLipsum.split('\n+')>
	</cffunction>

	<cffunction name="buildURL" access="private" returntype="string" output="no" hint="Builds the URL for the remote request.">
		<cfargument name="method" type="string" 	required="yes" 	hint="The request limit type (paras, words, bytes)." />
		<cfargument name="number" type="numeric" 	required="yes" 	hint="The limit of [type] to return." />
		<cfargument name="start"  type="boolean"	required="yes" 	hint="Should the text start with 'Lorem Ipsum'?" />
		<!--- default to paragraphs if we don't have a valid type --->
		<cfif NOT listfind("paras,words,bytes", arguments.method)>
			<cfset arguments.method = "paras" />
		</cfif>
		<cfreturn getURI()
			    & "?amount=" & arguments.number
			    & "&what=" & arguments.method
			    & "&start=" & arguments.start />
	</cffunction>

</cfcomponent>