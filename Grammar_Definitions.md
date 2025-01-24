// Backus-Naur Form grammar for grammatical evolution in OpenTTD
// heavily referenced from Frank Bijlsma's thesis paper

<rule>:= <money>|<bus>

<equals>:= =|!=|<|>|<=|>=

// we should normalize the value (especially for financial related matters) because the funds will scale at later 
// stages of the game making it difficult for the conditions to hold consistently 

<digits>:= 0.1 | 0.2 | 0.3 | 0.4 | 0.5 | 0.6 | 0.7 | 0.8 | 0.9 | 1.0



<maintain>:= <upgrade_vehicle>|<remove_unprofitable>

<upgrade_vehicle>:= UpgradeVehicles()
<remove_unprofitable>:= RemoveUnprofitable()

<build>:= 

<fin_var> := balance_left | profit_loan_ratio | current_funds_loan_ratio | debt_taken

<money>:= if (<fin_var> <equals> <num>) <debt>

<debt> := debt(<boolean>, <num>)

<route_var> = waiting | profit | last_build | last_paid_loan | oldest_vehicle_age




------------------------------------------------------------------------------------------------------------------------

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
