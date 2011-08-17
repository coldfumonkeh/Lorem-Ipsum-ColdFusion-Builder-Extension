<!---
Filename: generateText.cfm
Creation Date: 18/March/2010
Original Author: Matt Gifford aka coldfumonkeh
Revision: $Rev$
$LastChangedBy$
$LastChangedDate$
Description:
generateText.cfm used to pull data from the CFC
--->
<cfparam name="ideEventInfo" default="" />
 
<cfscript>
xmldoc 			= xmlParse(ideeventinfo);
response 		= xmlSearch(xmldoc,"//user");

user 			= structNew();
user.start 		= response[1].xmlChildren[1].xmlattributes.value;
user.method 	= response[1].xmlChildren[2].xmlattributes.value;
user.number 	= response[1].xmlChildren[3].xmlattributes.value;

objLipsum	 	= createObject("component", "loremGenerator").init();
arrLipsum	 	= objLipsum.getText(
					start=user.start,
					method=user.method,
					number=user.number);
</cfscript>

<cfheader name="Content-Type" value="text/xml">
<cfoutput>
<response> 
    <ide> 
        <commands> 
            <command type="inserttext"> 
            <params> 
            <param key="text" > 
            <![CDATA[ 
<cfloop from="1" to="#arraylen(arrLipsum)#" index="i">
<p>#arrLipsum[i]#</p>
</cfloop>
			 ]]> 
            </param> 
            </params> 
        </command> 
        </commands> 
    </ide> 
</response>
</cfoutput>