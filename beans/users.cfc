component persistent="true" output="false" {

property name="id" fieldtype="id" generator="identity";

property name="stateprovince" fieldtype="many-to-one" cfc="statesprovinces" fkcolumn="stateprovinceid" lazy="false";

property name="firstname" 		default = '';
property name="lastname" 		default = '';
property name="email" 			default = '';

property name="deleted"			default = 0;
}

