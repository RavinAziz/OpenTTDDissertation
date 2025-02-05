grammar OpenTTD_grammar_definitions;

// Starting point
script : (build NEWLINE)+ (rule NEWLINE)* EOF;

// Matches for both windows and unix newlines/line endings
NEWLINE
    : ('\r'? '\n')+;
 
// Rules
rule
    : money
    | bus;

// Operators
op
    : '='
    | '!='
    | '<'
    | '>'
    | '<='
    | '>=';

// Normalized values (to negate the economic scaling of the game at later stages)
num 
    : '0.0'
    | '0.1'
    | '0.2'
    | '0.3'
    | '0.4'
    | '0.5'
    | '0.6'
    | '0.7'
    | '0.8'
    | '0.9'
    | '1.0';

// Standard boolean values
boolean
    : 'true'
    | 'false';

// Maintenance actions
maintain
    : upgrade_bus
    | remove_unprofitable
    | add_bus;

// Upgrade all buses function
upgrade_bus
    : 'UpgradeBus()'; // Either it should upgrade all buses or just upgrade the oldest bus in the route?

// Remove all unprofitable buses function
remove_unprofitable
    : 'RemoveUnprofitable()';

// Adds buses to a route if that route has not reached the maximum number of buses yet
add_bus
    : 'AddBus()';

// Logic to build the routes
build
    : 'BuildRoute('num')';

// Financial Variables
fin_var
    : 'balance_left'
    | 'profit_loan_ratio'
    | 'current_funds_loan_ratio'
    | 'debt_taken';

// Debt Condition (false to pay loan, true to take loan)
debt
    : 'debt('boolean', 'num')';

// Money Condition
money
    : 'if ('fin_var op num')' debt;

// Route variables
route_var
    : 'waiting'
    | 'profit'
    | 'last_build'
    | 'last_paid_loan'
    | 'youngest_vehicle_age'; // or should it be oldest vehicle age? 

// Bus Condition
bus
    :' if ('route_var op num')' maintain;

// Ignore spaces and tabs
WS
    : [ \t\r\n]+ -> skip;