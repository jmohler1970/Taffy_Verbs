# Taffy for REST: Part 3 Verbs 


I talked so much during my first Taffy example, I had to split it into two videos.

This is the second set of code, but it is the third video. Sorry for the confusion

The main goal of this Repository is to build upon the previous. I want a much more flexible kind of resource.


# What is Taffy?

It is a quick and easy way to make REST resources in ColdFusion.

In our previous videos, we already setup

dot gitignore
box.json
server.json
and application.cfc

Are all present and accounted for. There is not anything new going on with these.

## Let's talk about some new stuff.

Previously, We had only one endpoint. And that was slash statesandprovinces. For this video I have renamed it to slash statesprovinces.
We didn't need the and.

# This one is going to have many more endpoints. Lets take a looks

We have `/statesprovinces`. That hasn't changed. It just has `GET`

We have `/users` and `/users/{id}`

`/users` has `GET` and `POST`

`/users/{id}` has `GET`, `PUT`, and `DELETE`

Without even looking at the code, I have an idea as to what these are supposed to do.

`/users` 		`GET`	should return a list of all users
`/users` 		`POST`	should add a user
`/users/{id}` 	`GET`	should return one user. It may return zero
`/users/{id}` 	`PUT`	should return update one user
`/users/{id}` 	`DELETE`	should delete one user

I supposet if `/users` had `DELETE`, that would empty the entire database table.

# Let's take a look at the beans

`StateProvinces.cfc` has not changed, so lets not spend too much time on that.

## beans/Users.cfc is new

Line 1: persistent is true, so that tells me it will be a Entity. It also tells me that the database better have a table called `dbo.Users`

Line 3: `property name="id"` and `fieldtype="id"` OK so it is the primary key. generator equals identity. This means that ORM is expecting the SQL Server will create a number everytime a new Entity is saved.

Line 5: This is where ORM becomes very different databases. When I pull this Entity, one of its attributes will be another Entity inside of it. It is not going to be returning a foreign key or anything like that. When we have to interact with this Entity, you will see how how it is a little bit different.

Firstname, lastname, email seem straight forward.

On line 11: Deleted is a flag. I have worked for a lot of big companies over the years. We don't like deleting data. If you just flag it as deleted, you can recover it later. Just in case.

# About Resource Responses

I want my responses to have a boring consistency. When you are designing your REST API, figure out one way to do, and stick to it. Here is what I have got. A struct will be returned all the time with the following keys

```
{
status 		: 'success', 				// This status will go all the way through to context class in Bootstrap, or Bulma, or Material Design
time 		: GetHttpTimeString(now()), 	// This is just easy to do, and can quickly be seen
message_i18n 	: 'HELLO_WORLD', 			// When I get to i18n, this will be the raw key. This is for debuggin i18n
message 		: 'Hello, world!', 			// This is the 'post i18n' lookup. It is possible tht there will not be a match
data 		: [] or {}				// This one may be non existant depending on the nature of the request
}
```

Not it is not a part of the data, but there is also an HTTP response code. It should be set as appropriate too.

## Word of advice

We want our rest endpoint to be used by a wide variety system. There are a lot of client side technologies. The more of them you can keep happy, the better.


# On to the resources


## Moving on to /resource/users/users.cfc

Line 1: This is a Taffy resource object. It responds to requests to slash users. The fact that this file is in a subdirectory off of resources does not impact the REST path


Line 3: tells me that this is a `GET`

Line 5: Give me an array of all User Entitys. Don't filter. Order by id

Starting at Line 8 or so, I am going to be working this data very differently from how I did stateprovinces. First off, when this system starts, there will be zero users. I don't want my code to crash with zero users.

More importantly, on line 14, I need to some extra work to get the Stateprovinceid. I cannot just pick it off. I need to do an extra step. If I were to do a `<cfdump>` of `User.getStateProvince()`, I would see that it is an Entity. I got to make a function call even deeper to get to its ID field.

In short, I have to build this result array piece by piece.

As an aside, there are many reasons you may have to do it this way. What if you don't want to return all the fields from the Entity? What if your Entity does some of its own calculations. You may find that this is the most common approach to building your results.



## Let's look at the PUT function

Lines 21 through 26: are going to setup the expected parameters. Taffy will look at these and expose them.

Lines 28 through 32: are for error checking. If you pick an invalid StateProvince, Taffy will return a `noData()`. `noData()` is function that is built into Taffy and can come in useful for when nothing needs to be returned. This is different from a blank string or any empty array or struct. Nothing is coming back.

Line 35: Is where I am goint to create an Entity. By the way, `EntityNew()` does NOT create row in the database. It has to be saved in order for it to stay.

Line 39: Is interesting. I am not saving data. I am saving an entire Entity. The very same Entity I found on line 28

Moving onto Line 41. The data is now going to get committed to the DB. I hope it passes all the validation rules, or else it with through an error. If, for example, firstname is too long, that can cause the save to fail. There are all kinds of ways to make this more robust.

Line 42: is interesting. The short story is that it should not be there. If you are using my code as an example, you should comment out this line.

Let me give the long story on why it is bad. When you are using Entities, you could find yourself using lots and lots of them. When you call `EntitySave()`, Coldfusion will actually put this into a queue to be saved. At the end of the request, it is going to update the database with everything. You could have Insert, Updates, and Deletes all over the place. ColdFusion keeps track of their states. You don't want to pick on the database with all these small requests. ORM takes care of them as a single unit. There is a lot more to talk about on this. I hope to cover that in a future video.


So what does `ORMFlush()` do? It tells ColdFusion to NOT wait until the end of the request. It tells ColdFusion to commit all changes now. This will slow things down. For a single record INSERT, you probably won't notice. But if you dealing with a lot of changes, you almost certainly want to avoid `ORMFlush()`. Always!

I don't want to get too far off topic, but here is a reason to use `ORMFlush()`. If you code base has mixture of traditional SQL queries and Entities, you need to make sure your DB is in a consistent state. I hope to show some examples of this in a future video.


### Back to our code.

Line 44: We are returning a nice struct with a message. Hopefully all this added a User and things will be looking good.

# Let's move on to users_id.cfc

I don't really have too much to say on its GET function.

Line 5: `EntityLoadByPK()` is different than `EntityLoad()`. `EntityLoadByPK()` always return a single Entity. Whereas `EntityLoad()` by default returns an array. When you have a choice, use `EntityLoadByPK()`.

Otherwise `GET` a single User is just a simpler version of get All Users

## Let's look at `PUT`

It is similar to User `POST`

We have to do some error checking to make sure we can load the User before even attempting to save any changes. Once again we return a noData() if we can't find the User.

Line 34 to 38: is the same StateProvince checking we had before

Line 40 to 46: We will be doing a proper `EntitySave()`. No `ORMFlush()` in sight.

Line 49: We are returning a success message. `withStatus(201)` ? What is that? Taffy allows us to return almost any HTTP status we want. I will leave it up to the viewers of this video to decide if status 201 is appropriate.


## Our last HTTP Verb is DELETE. This should be good.

This isn't too strange. We have seen variations of this kind of code in all the examples.

On line 64 we are flagging as deleted as opposed to really deleting it.

# Load database

Load up the database. I am going to be using a different create script. I am going to be using User.sql. It has Stateprovinces built into it too.


# Start up ColdFusion

- Checking Docker (docker ps -a)
- Start CommandBox, wait for default page to show up
- In CommandBox, make sure veryting is installed
- Start

- Check out statesprovinces

- list all users

- add user

- add user incorrectly. Lets put in some bad data.



- list all users

- list single user

- add user



- update user

- list single user

- list all users


- add user

- delete user

- list single user


- list all users

# Thank you for watching



Resources:

https://github.com/atuttle/Taffy

http://taffy.io/

https://stackoverflow.com/questions/tagged/taffy

https://github.com/jmohler1970/Taffy_video


