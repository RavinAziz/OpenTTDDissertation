// Backus-Naur Form grammar for grammatical evolution in OpenTTD

<rule>:= <money>|<bus>

<equals>:= =|!=|<|>|<=|>=

<digits>:= "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"



<maintain>:= <upgrade_vehicle>|<remove_unprofitable>

<build>:= if 

<money>:= 


so what do we want to check?

- given that waiting time is a fitness function
	- have a variable that checks waiting time
	
- profit and cost is a thing
	- have a variable that checks the profitability of a bus


What alterations do we have to make to the code?

- need to define some aspects as a function

	- removal of unprofitable vehicles
	- replacement of vehicle with newer ones
	- check waiting time
	- need to add a variable to each route to track when it was built/when it was last maintained or updated
