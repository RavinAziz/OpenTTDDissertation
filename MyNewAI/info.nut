class MyNewAI extends AIInfo 
{
  function GetAuthor()      { return "Ravin"; }
  function GetName()        { return "MyNewAI"; }
  function GetDescription() { return "My AI"; }
  function GetVersion()     { return 1; }
  function GetDate()        { return "2024-07-12"; }
  function CreateInstance() { return "MyNewAI"; }
  function GetShortName()   { return "MYAI"; }
  function GetAPIVersion()  { return "12"; }

  function GetSettings()
  {
    AddSetting(
        {
          name = "Base",
          description = "Base attempt",
          min_value = 0,
          max_value = 100,
          easy_value = 30,
          medium_value = 20,
          hard_value = 10,
          custom_value = 60,
          flags = 0
        });
    AddLabels("Base", {
            _0 = "It's off now",
            _100 = "Maximum"
        });
        
    AddSetting(
      {
        name = "initial_vehicles",
        description = "The initial amount of vehicles in a new route"
        min_value = 3,
        max_value = 3,
        easy_value = 3,
        medium_value = 3,
        hard_value = 3,
        custom_value = 3,
        flags = CONFIG_INGAME
      });
    
    AddSetting({
      name = "max_distance",
      description = "The maximum distance betwen towns for a route",
      min_value = 100,
      max_value = 500,
      easy_value = 100,
      medium_value = 150,
      hard_value = 500,
      custom_value = 150,
      flags = CONFIG_INGAME
    });

    AddSetting({
      name = "add_new_vehicle_age",
      description = "The minimum age of the newest vehicle before adding another vehicle to a route (in days)",
      min_value = 0,
      max_value = 365,
      easy_value = 45,
      medium_value = 90,
      hard_value = 135,
      custom_value = 90,
      flags = CONFIG_INGAME
    });

    AddSetting({
      name = "max_age_left",
      description = "The maximum age left of a vehicle before being replaced",
      min_value = 0,
      max_value = 7300,
      easy_value = 7300,
      medium_value = 3650,
      hard_value = 0,
      custom_value = 3650,
      flags = CONFIG_INGAME
    });
    
  AddSetting({
    name = "upgrade_bridge_wait",
    description = "How many years to wait until upgrading the existing bridges",
    min_value = 0,
    max_value = 2,
    easy_value = 2,
    medium_value = 0,
    hard_value = 0,
    custom_value = 1, 
    flags = CONFIG_INGAME
  });

  AddSetting({
    name = "maxvehicles",
    description = "The maximum amount of vehicles in one route",
    min_value = 1,
    max_value = 10, 
    easy_value = 1,
    medium_value = 3,
    hard_value = 5,
    custom_value = 3,
    flags = CONFIG_INGAME
  });

  AddSetting({
    name = "pay_loan_wait",
    description = "The number of days to wait before paying off a loan",
    min_value = 0,
    max_value = 730,
    easy_value = 730,
    medium_value = 0,
    hard_value = 365,
    custom_value = 0,
    flags = CONFIG_INGAME
  });

  AddSetting({
    name = "max_waiting_time",
    description = "The maximum waiting time of passengers before adding a new vehicle to a route"
    min_value = 0,
    max_value = 1000,
    easy_value = 300,
    medium_value = 150,
    hard_value = 100,
    custom_value = 0,
    flags = CONFIG_INGAME
  });
  }
}

RegisterAI(MyNewAI());