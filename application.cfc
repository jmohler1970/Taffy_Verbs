<cfscript>
component extends="taffy.core.api"  {

this.name = "taffy_21";
this.applicationTimeout 		= createTimeSpan(0, 4, 0, 0);
this.applicationManagement 	= true;

this.ormenabled = true;
this.ormsettings.eventhandling = true;
this.datasource = "UserManager";


this.mappings['/resources'] 	= expandPath('./resources');
this.mappings['/taffy'] 		= expandPath('./taffy');

function onApplicationStart() output="false"	{

	application.util = new formutils.FormUtils().init();

	return super.onApplicationStart();
	}


function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers)	{

	application.util.buildFormCollections(form);


	/*
	if(!arguments.headers.keyExists("apiKey")){
		//unauthorized because they haven't included their API key
		return rep({ 'error' : 'Missing header apiKey' }).withStatus(401);
		}
	*/

	//api key found
	return true;
	}
}


</cfscript>
