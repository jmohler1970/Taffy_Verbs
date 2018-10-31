component extends="taffy.core.resource" taffy_uri="/users" {

function get(string stateprovinceid = ""){

	var Users = EntityLoad("Users", {}, "ID")

	var Result = [];
	for (var User in Users)	{
		Result.append({
			"id"			: User.getId(),	
			"firstName" 	: User.getFirstName(),
			"lastName" 	: User.getLastName(),
			"emailName"	: User.getEmail(),
			"stateProvinceId" : User.getStateProvince().getId(),
			"filter_StateProvinceID" : arguments.StateProvinceID,
			"deleted"		: User.getDeleted()
		});
	}

	if (arguments.stateprovinceid != "")	{
		Result = Result.filter(function(item) {
			return item.StateProvinceId == item.filter_StateProvinceID;
		})
	}

	return rep({
		'time' 		: GetHttpTimeString(now()),
		'data' 		: Result
		});
}

function post(
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

	return rep({
		'status' 		: 'success',
		'time' 		: GetHttpTimeString(now()),
		'message_i18n' : 'WELCOME',
		'message' 	: '<b>Success:</b> User has been created.',
		'data'		: User.getId()
	});
}

} // end component
