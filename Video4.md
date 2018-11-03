# Taffy for REST: Part 4 More Verbs 


# Introduction

Without even looking at the code, I have an idea as to what these are supposed to do.

`/users` 		`GET`	should return a list of all users
`/users` 		`POST`	should add a user
`/users/{id}` 	`GET`	should return one user. It may return zero
`/users/{id}` 	`PUT`	should return update one user
`/users/{id}` 	`DELETE`	should delete one user

I supposet if `/users` had `DELETE`, that would empty the entire database table.


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


## Our last HTTP Verb is DELETE. 

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



# Resources:

- https://github.com/atuttle/Taffy

- http://taffy.io/

- https://stackoverflow.com/questions/tagged/taffy

- https://github.com/jmohler1970/Taffy_Verbs


