component extends="taffy.core.resource" taffy_uri="/users" {

function get(){

	var Users = EntityLoad("Users", {}, "ID")

	var Result = [];
	for (var User in Users)	{
		Result.append({
			"id"			: User.getId(),	
			"firstName" 	: User.getFirstName(),
			"lastName" 	: User.getLastName(),
			"emailName"	: User.getEmail(),
			"stateProvinceId" : User.getStateProvince().getId(),
			"deleted"		: User.getDeleted()
		});
	}
	return rep(Result);
}

function put(
	required string firstname, 
	required string lastname,
	required string email, 
	required string stateprovinceid
	) {

	var StateProvince = entityLoadByPK("StatesProvinces", arguments.stateprovinceid);

	if (isNull(StateProvince))	{
		return noData();
	}

	
	var User = EntityNew("Users", {
		firstname : arguments.firstname, 
		lastname : arguments.lastname, 
		email : arguments.email, 
		stateprovince : StateProvince
	});
	EntitySave(User);
	ORMFlush();

	return rep({'status' : 'success','time' : GetHttpTimeString(now()),
		'messages' : ['<b>Success:</b> User has been created.']
	});
}

} // end component
