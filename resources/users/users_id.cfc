component extends="taffy.core.resource" taffy_uri="/users/{id}" {

function get(required numeric id){

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData();
		}

	return rep({
		"id"			: User.getId(),	
		"firstName" 	: User.getFirstName(),
		"lastName" 	: User.getLastName(),
		"emailName"	: User.getEmail(),
		"stateProvinceId" : User.getStateProvince().getId(),
		"deleted"		: User.getDeleted()
		});
	}


function put(required numeric id,
	required string firstname,
	required string lastname,
	required string email,
	required string stateprovinceid){

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData();
		}

	var StateProvince = entityLoadByPK("StatesProvinces", arguments.stateprovinceid);

	if (isNull(StateProvince))	{
		return noData();
		}

	EntitySave(
		EntityLoadByPK("Users", arguments.id)
			.setFirstname(arguments.firstname)
			.setLastname(arguments.lastname)
			.setEmail(arguments.email)
			.setStateProvince(StateProvince)
		);


	return rep({'status' : 'success','time' : GetHttpTimeString(now()),
		'messages' : ['<b>Success:</b> User has been saved.']
		}).withStatus(201);
	}


function delete(required numeric id){

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData();
		}

	EntitySave(
		User.setDeleted(true)
		);

	return rep({'status' : 'success','time' : GetHttpTimeString(now()),
		'messages' : ['<b>Success:</b> User has been set to deleted.']
		});

	}


}