<cfparam name="url.reporter" default="simple" type="variablename">
<cfset plainText = url.reporter IS "text" OR url.reporter IS "mintext">
<cfsetting requesttimeout="150" enablecfoutputonly="#plainText#">
<cfif plainText>
	<cfcontent type="text/plain">
</cfif>

<strong>Test Environment</strong>: 
<cfif server.coldfusion.productname contains "ColdFusion">
	<cfoutput>Adobe ColdFusion #server.coldfusion.productversion#</cfoutput>
<cfelseif structKeyExists(server, "lucee")>
	<cfoutput>Lucee #server.lucee.version#</cfoutput>
<cfelseif structKeyExists(server, "railo")>
	<cfoutput>Railo #server.railo.version#</cfoutput>
<cfelse>
	<cfoutput>#server.coldfusion.productname#</cfoutput>
</cfif>
<cfoutput> on #server.os.name# #server.os.version#</cfoutput>
<cfset system = createObject("java", "java.lang.System")>
<cfoutput> running Java #system.getProperty("java.version")#

</cfoutput>

<cfset r = new testbox.system.TestBox( directory="tests", reporter=url.reporter ) >
<cfoutput>#r.run()#</cfoutput>
<cfset resultObject = r.getResult()>
<cfset errors       = resultObject.getTotalFail() + resultObject.getTotalError()>
<cfif errors GT 0>
	<cfheader statuscode="500" statustext="Tests Failed">
</cfif>

<cfif NOT plainText>
	<cfoutput>
		<a href="run.cfm?ts=#GetTickCount()#">ReRun</a>
	</cfoutput>
</cfif>