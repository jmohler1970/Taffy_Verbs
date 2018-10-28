component extends="taffy.core.resource" taffy_uri="/statesprovinces" {

function get(){

	return rep(queryToArray(
		EntityToQuery(EntityLoad("StatesProvinces", {}, "CountrySort, LongName"))
		));
	}

}
