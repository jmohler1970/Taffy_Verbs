component extends="taffy.core.resource" taffy_uri="/users/{id}" {

function get(required numeric id){

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData().withStatus(404);;
		}

	return rep({
		'time' 		: GetHttpTimeString(now()),
		'data' 		: {
			"id"			: User.getId(),	
			"firstName" 	: User.getFirstName(),
			"lastName" 	: User.getLastName(),
			"emailName"	: User.getEmail(),
			"stateProvinceId" : User.getStateProvince().getId(),
			"deleted"		: User.getDeleted()
			}
		});

	return rep();
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
		return noData().withStatus(404);
		}

	EntitySave(
		User .setFirstname(arguments.firstname)
			.setLastname(arguments.lastname)
			.setEmail(arguments.email)
			.setStateProvince(StateProvince)
		);

	return rep({
		'status' : 'success',
		'time' : GetHttpTimeString(now()),
		'message_i18n' : 'OK',
		'messages' : '<b>Success:</b> User has been saved.'
		}).withStatus(201);
	}


function patch(required numeric id,
	string firstname = "",
	string lastname = "",
	string email = ""){

	if (arguments.firstname == "" && arguments.lastName == "" && arguments.email == "")	{
		return rep({
			'time' : GetHttpTimeString(now())
			}).withStatus(304);
		}

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData().withStatus(404);
		}

	if (arguments.firstName 	!= "") User.setFirstName(arguments.firstName);
	if (arguments.lastName 	!= "") User.setLastName( arguments.lastName );
	if (arguments.email 	!= "") User.setEmail(	arguments.email);

	EntitySave(User);

	return rep({
		'status' : 'success',
		'time' : GetHttpTimeString(now()),
		'message_i18n' : 'OK',
		'messages' : '<b>Success:</b> User has been saved.'
		});
	}



function delete(required numeric id){

	var User = EntityLoadByPK("Users", arguments.id);

	if (isNull(User))	{
		return noData().withStatus(404);
		}

	EntitySave(
		User.setDeleted(true)
		);

	return rep({'status' : 'success','time' : GetHttpTimeString(now()),
		'messages' : ['<b>Success:</b> User has been set to deleted.']
		});

	}


}