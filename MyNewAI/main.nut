import("pathfinder.road", "RoadPathFinder", 4);

class MyNewAI extends AIController
{
    DIR_NE = 2;
    DIR_NW = 0;
    DIR_SE = 1;
    DIR_SW = 3;

    TD_SELL = 1;
    TD_REPLACE = 2;
    TD_SERVICE = 3;

    routes = null; // a list of all the established routes
    src = null; 
    dst = null; // the Source/Destination ID
    srclist = null; 
    dstlist = null; // list of Source/Destination ID's
    statile = null;
    deptile = null; // the tile of the station;depot
    stafront = null;
    depfront = null; // the tile in front of the station;depot
    statop = null;
    stabottom = null; // the tile on top and bottom of the station
    stationdir = null; // the direction of the station
    stasrc = null;
    stadst = null; // the station source/destination
    homedepot = null; //the depot at the src station
    srcistown = null;
    dstistown = null; // the source/destination is a town
    srcplace = null;
    dstplace = null; // the place of the source;destination (town/industry)
    vehtype = AIVehicle.VT_ROAD; // the current vehicle type selected (hardcoded for road vehicles)
    group = null; // the current vehicle group
    crg = 0; // the cargo index (hardcoded for passengers)
    srcname = null;
    dstname = null; // name of source/destination town
    srctile = null;
    dsttile = null; // source and destination tile for the pathfinding (front of the stations)
    group = null; // the current vehicle group
    groups = AIList(); // a list of all vehicle groups
    lastroute = null; // date of last route built
    todepotlist = AIList(); // list of all vehicles going to a depot
    roadbridges = AITileList(); // list of all the road bridges owned by the company
    bridgesupgraded = null // date of when bridges were last updated

    //ai_parameters static variables (has to be defined in the info.nut file beforehand as a setting)
    initial_vehicles = null; // the initial number of vehicles of a route
    max_distance = null; // the maximum distance between towns for a route to be established
    add_new_vehicle_age = null; // the minimum age the of the newest vehicle in a route before adding a new one
    upgrade_bridge_wait = null; // the amount of time to wait until upgrading bridges (start count from 0)
    new_route_wait = null; // the amount of time to wait before building a new route
    pay_loan_wait = null; // the amount of time to wait before trying to pay back the loan
    max_age_left = null; // the maximum age left of a vehicle before being replaced (in days)
    max_waiting_time = null; // the maximum waiting time of the passengers before adding a new vehicle to the route
}

function MyNewAI::Start()
{
    AILog.Info("MNewyAI started");

    // get a list of all the towns in the map
    local townlist = AITownList();

    // sort the list by in descending order of population (highest population first)
    townlist.Valuate(AITown.GetPopulation);
    townlist.Sort(AITownList.SORT_BY_VALUE, false);

    // set the ai to build only roads
    AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);

    // get the first two towns
    src  = townlist.Begin();
    dst = townlist.Next();   

    routes = [];

    initial_vehicles = AIController.GetSetting("initial_vehicles");
    max_distance = AIController.GetSetting("max_distance");
    add_new_vehicle_age = AIController.GetSetting("add_new_vehicle_age");
    upgrade_bridge_wait = AIController.GetSetting("upgrade_bridge_wait");
    max_age_left = AIController.GetSetting("max_age_left");
    max_waiting_time = AIController.GetSetting("max_waiting_time")

    bridgesupgraded = AIDate.GetYear(AIDate.GetCurrentDate());

    while(!townlist.IsEnd()){

        // get the tile index of the towns
        srcplace = AITown.GetLocation(src);
        dstplace = AITown.GetLocation(dst);

        while (AIMap.DistanceManhattan(srcplace, dstplace) > max_distance) {
            src = dst;
            dst = townlist.Next();

            srcplace = AITown.GetLocation(src);
            dstplace = AITown.GetLocation(dst);

        }

        // get the name of the source and destination town
        srcname = AITown.GetName(src);
        dstname = AITown.GetName(dst);

        // show the name of the towns being connected
        AILog.Info("Connecting " + srcname + " and " + dstname);

        // get the road vehicle at every iteration to account for new vehicles
        local veh = ChooseRoadVeh();
        if (veh == null) {
            AILog.Warning("No suitable road vehicle");
        } else {
            AILog.Info("Selected road vehicle: " + AIEngine.GetName(veh));
        }

        local build_success = true;

        // try to build the source station
        if (BuildRoadStation(true)) {
            AILog.Info("New station successfully built: " + AIStation.GetName(stasrc));
        } else {
            AILog.Error("Could not build source station at " + srcname);
            build_success = false;
        }

        // try to build the destination station
        if (BuildRoadStation(false)) {
            AILog.Info("New station successfully built: " + AIStation.GetName(stadst));
        } else {
            AILog.Error("Could not build destination station at " + dstname);
            DeleteRoadStation(stasrc);
            build_success = false;
        }

        if (build_success) {
            // get the tiles in front of the stations
            srctile = AIRoad.GetRoadStationFrontTile(AIStation.GetLocation(stadst));
            dsttile = AIRoad.GetRoadStationFrontTile(AIStation.GetLocation(stasrc));

            if (MyNewAI.BuildRoad(srctile, dsttile)) {
                AILog.Info("Succesfully established a road between " + srcname + " and " + dstname);
                group = AIGroup.CreateGroup(AIVehicle.VT_ROAD, AIGroup.GROUP_INVALID);
                BuildAndStartVehicles(veh, initial_vehicles, null);
            } else {
                DeleteRoadStation(stasrc);
                DeleteRoadStation(stadst);
            }

            local new_route = RegisterRoute();
        }
        
        src = dst;
        dst = townlist.Next();
        CheckEvents();
        CheckTodepotlist();
        CheckRoutes();
        if (AIDate.GetYear(AIDate.GetCurrentDate()) > bridgesupgraded) { UpgradeRoadBridges(); }
        PayLoan();
        AILog.Info("------------------------------------------------------------");
        AIController.Sleep(700);
    }
}

function MyNewAI::BuildRoadStation(is_source)
{
    local dir, tilelist, otherplace = null;
    local rad = AIStation.GetCoverageRadius(AIStation.STATION_BUS_STOP);

    // determine the possible list of tiles to build station on
    if (is_source) {
        dir = GetDirection(srcplace, dstplace);
        tilelist = GetTilesAroundTown(src, 1, 1);
        otherplace = dstplace;
    } else {
        dir = GetDirection(dstplace, srcplace);
        tilelist = GetTilesAroundTown(dst, 1, 1);
        otherplace = srcplace;
    }

    local stationtype = AIRoad.ROADVEHTYPE_BUS;
    
    // filter the tile list
    tilelist.Valuate(AITile.IsBuildable);
    tilelist.KeepValue(1);

    // check how much passenger each tile accepts 
    // keep the ones above value of 10
    tilelist.Valuate(AITile.GetCargoAcceptance, 0, 1, 1, rad);
    tilelist.KeepAboveValue(10)

    // Sort the list by descending order
    tilelist.Sort(AIList.SORT_BY_VALUE, false);

    local success = false;
    // find a tile to where the station can be built
    foreach(tile, dummy in tilelist) {
        if (CanBuildRoadStation(tile, dir)) {
            success = true;
            break;
        } else { continue; }
    }

    // build the station/depot
    if (!success) { return false; }    
    AIRoad.BuildRoad(stafront, statile);
    AIRoad.BuildRoad(depfront, deptile);
    AIRoad.BuildRoad(stafront, depfront);
    
    if (!AIRoad.BuildRoadStation(statile, stafront, stationtype, AIStation.STATION_NEW)) {
        AILog.Error("Station cannot be built: " + AIError.GetLastErrorString());
        DeleteRoadStationPlace(statile, stafront);
        return false;
    }

    if (is_source) {
    if (!AIRoad.BuildRoadDepot(deptile, depfront)) {
        AILog.Error("Depot cannot be built: " + AIError.GetLastErrorString());
        DeleteRoadStationPlace(deptile, depfront);
        return false;
        }
    }

    if (is_source) {
        stasrc = AIStation.GetStationID(statile);
        homedepot = deptile;
    } else {
        stadst = AIStation.GetStationID(statile);
    }
    
    return true;
}

// function to get the vehicle type (temp hardcoding for buses)
function MyNewAI::ChooseRoadVeh()
{
    // create a list object to store the vehicle objects
    local vehlist = AIEngineList(AIVehicle.VT_ROAD);

    // get a list of all vehicle engines and only keep only the road vehicles
    vehlist.Valuate(AIEngine.GetRoadType);
    vehlist.KeepValue(AIRoad.ROADTYPE_ROAD);

    // exclude articulated vehicles
    vehlist.Valuate(AIEngine.IsArticulated);
    vehlist.KeepValue(0);

    // remove all the 0 price engines
    vehlist.Valuate(AIEngine.GetPrice);
    vehlist.RemoveValue(0);

    // filter by passenger cargo type to get bus (temp)
    vehlist.Valuate(AIEngine.CanRefitCargo, crg);
    vehlist.KeepValue(1);

    // sort the vehicle list by efficiency
    vehlist.Valuate(GetEngineRawEfficiency, 0, true);
    vehlist.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);

    local veh = null;
    
    veh = vehlist.Begin();
    if (vehlist.Count() == 0) { veh = null; }
    return veh;
}

// taken from SimpleAI
// check if you can build the station on top of the tile and direction
function MyNewAI::CanBuildRoadStation(tile, direction) 
{
	if (!AITile.IsBuildable(tile)) { return false; }
	local offsta = null;
	local offdep = null;
    //used to determine the orientation of the station
	local middle = null;
	local middleout = null;

	// calculate the offsets depending on the direction and relative index values
	switch (direction) {
		case DIR_NE:
			offdep = AIMap.GetTileIndex(0, -1);
			offsta = AIMap.GetTileIndex(-1, 0);
			middle = AITile.CORNER_W;
			middleout = AITile.CORNER_N;
			break;
		case DIR_NW:
			offdep = AIMap.GetTileIndex(1, 0);
			offsta = AIMap.GetTileIndex(0, -1);
			middle = AITile.CORNER_S;
			middleout = AITile.CORNER_W;
			break;
		case DIR_SE:
			offdep = AIMap.GetTileIndex(-1, 0);
			offsta = AIMap.GetTileIndex(0, 1);
			middle = AITile.CORNER_N;
			middleout = AITile.CORNER_E;
			break;
		case DIR_SW:
			offdep = AIMap.GetTileIndex(0, 1);
			offsta = AIMap.GetTileIndex(1, 0);
			middle = AITile.CORNER_E;
			middleout = AITile.CORNER_S;
			break;
	}
	statile = tile;
	deptile = tile + offdep;
	stafront = tile + offsta;
	depfront = tile + offsta + offdep;

    // check if the current tile for depot is buildable
    if (!AITile.IsBuildable(deptile)) {
		return false;
	}

    // check if the tile in front of the station is buildable and is a road
	if (!AITile.IsBuildable(stafront) && !AIRoad.IsRoadTile(stafront)) {
		return false;
	}

    // check if the tile in front of the depot is buildable and is a road
	if (!AITile.IsBuildable(depfront) && !AIRoad.IsRoadTile(depfront)) {
		return false;
	}

	local height = AITile.GetMaxHeight(statile);
	local tiles = AITileList();
	tiles.AddTile(statile);
	tiles.AddTile(stafront);
	tiles.AddTile(deptile);
	tiles.AddTile(depfront);

    // check if any tile is sloped if the build on slope setting is active
	if (!AIGameSettings.GetValue("construction.build_on_slopes")) {
		foreach (idx, dummy in tiles) {
			if (AITile.GetSlope(idx) != AITile.SLOPE_FLAT) return false;
		}
	} else {
        // check that at least the height of one the tile's corners are the same as the centre of the tile
		if ((AITile.GetCornerHeight(stafront, middle) != height) && (AITile.GetCornerHeight(stafront, middleout) != height)) return false;
	}

    // check that each tile is of the same height and not a steep slope
	foreach (idx, dummy in tiles) {
		if (AITile.GetMaxHeight(idx) != height) return false;
		if (AITile.IsSteepSlope(AITile.GetSlope(idx))) return false;
	}

	// check if the road can be built
	local test = AITestMode();
	if (!AIRoad.BuildRoad(stafront, statile)) {
		if (AIError.GetLastError() != AIError.ERR_ALREADY_BUILT) return false;
	}
	if (!AIRoad.BuildRoad(depfront, deptile)) {
		if (AIError.GetLastError() != AIError.ERR_ALREADY_BUILT) return false;
	}
	if (!AIRoad.BuildRoad(stafront, depfront)) {
		if (AIError.GetLastError() != AIError.ERR_ALREADY_BUILT) return false;
	}

    // check if the station and depot can be built
	if (!AIRoad.BuildRoadStation(statile, stafront, AIRoad.ROADVEHTYPE_TRUCK, AIStation.STATION_NEW)) return false;
	if (!AIRoad.BuildRoadDepot(deptile, depfront)) return false;
	test = null;
	return true;

}

// taken from DictatorAI
function MyNewAI::GetEngineRawEfficiency(engine, cargoID, fast)
{
	local price = AIEngine.GetPrice(engine);
	local capacity = AIEngine.GetCapacity(engine);
	local speed = AIEngine.GetMaxSpeed(engine);
	local lifetime = AIEngine.GetMaxAge(engine);
	local runningcost = AIEngine.GetRunningCost(engine);
	if (capacity <= 0)	return 9999999;
	if (price <= 0)	return 9999999;
	local eff = 0;
	if (fast)	eff = 1000000 / ((capacity*0.9)+speed).tointeger();
		else	eff = 1000000-(capacity * speed);
	return eff;
}

// taken from SimpleAI to return the tiles around a town
function MyNewAI::GetTilesAroundTown(town_id, width, height)
{
	local tiles = AITileList();
	local townplace = AITown.GetLocation(town_id);
	local distedge = AIMap.DistanceFromEdge(townplace);
	local offset = null;
	local radius = 15;
	if (AITown.GetPopulation(town_id) > 5000) radius = 30;
	// A bit different is the town is near the edge of the map
	if (distedge < radius + 1) {
		offset = AIMap.GetTileIndex(distedge - 1, distedge - 1);
	} else {
		offset = AIMap.GetTileIndex(radius, radius);
	}
	tiles.AddRectangle(townplace - offset, townplace + offset);
	tiles.Valuate(IsRectangleWithinTownInfluence, town_id, width, height);
	tiles.KeepValue(1);
	return tiles;
}

// taken from SimpleAI to get the direction (NE, NW, SE, SW) from source to destination tile
function MyNewAI::GetDirection(tilefrom, tileto)
{
	local distx = AIMap.GetTileX(tileto) - AIMap.GetTileX(tilefrom);
	local disty = AIMap.GetTileY(tileto) - AIMap.GetTileY(tilefrom);
	local ret = 0;
	if (abs(distx) > abs(disty)) {
		ret = 2;
		disty = distx;
	}
	if (disty > 0) {
		ret = ret + 1;
	}
	return ret;
}

// taken from SimpleAI
// to remove a road station, if the tile and orientation of the station is already known
function MyNewAI::DeleteRoadStationPlace(place, front)
{
    local offx = AIMap.GetTileX(front) - AIMap.GetTileX(place);
    local offy = AIMap.GetTileY(front) - AIMap.GetTileY(place);
    local dir1 = AIMap.GetTileIndex(offx, offy);
    local placeholder = offx;
    offx = -offy;
    offy = placeholder;
    local dir2 = AIMap.GetTileIndex(offx, offy);
    local depot = place + dir2;
    local front2 = depot + dir1;
    AITile.DemolishTile(place);
    AITile.DemolishTile(depot);
    
    // check for the roads in front of the depot/station
    if (!AIRoad.AreRoadTilesConnected(front, front + dir1) && !AIRoad.AreRoadTilesConnected(front, front - dir2) && !AIRoad.AreRoadTilesConnected(front2, front2 + dir1) && !AIRoad.AreRoadTilesConnected(front2, front2 + dir2)) {
        AITile.DemolishTile(front);
        AITile.DemolishTile(front2);
    }
}

// to remove a road station if the tile and orientation is unknown
function MyNewAI::DeleteRoadStation(sta)
{
    local vehiclelist = AIVehicleList_Station(sta);
    if (vehiclelist.Count() > 0) {
        AILog.Error(AIStation.GetName(sta) + " cannot be removed, it's still in use!");
        return;
    }
    local place = AIStation.GetLocation(sta);
    local front = AIRoad.GetRoadStationFrontTile(place);
    DeleteRoadStationPlace(place, front);
}

// * logic only implemented for bus transportation
function MyNewAI::BuildAndStartVehicles(veh, number, ordervehicle) 
{
    local srcplace = AIStation.GetLocation(stasrc);
    local dstplace = AIStation.GetLocation(stadst);
    local price = AIEngine.GetPrice(veh);

    if (AICompany.GetBankBalance(AICompany.COMPANY_SELF) < price) {
        if (!SetMinimumBankBalance(price)) {
            AILog.Warning("I don't have enough money to buy the road vehicles");
            return false;
        }
    }

    local firstveh = AIVehicle.BuildVehicle(homedepot, veh);
    if (AIEngine.GetCargoType(veh) != crg) { AIVehicle.RefitVehicle(firstveh, crg); }
    if (ordervehicle == null) {
        // if there is no other vehicle to share orders with
        local firstorderflag = AIOrder.OF_NON_STOP_INTERMEDIATE;
        // do not stop at stations that are passed when going to the destination
        local secondorderflag = AIOrder.OF_NON_STOP_INTERMEDIATE;
        // service the vehicle if needed and when it is at its homedepot
        local thirdorderflag = AIOrder.OF_SERVICE_IF_NEEDED | AIOrder.OF_NON_STOP_INTERMEDIATE;

        AIOrder.AppendOrder(firstveh, srcplace, firstorderflag);
        AIOrder.AppendOrder(firstveh, dstplace, secondorderflag);
        AIOrder.AppendOrder(firstveh, homedepot, thirdorderflag);
    } else {
        AIOrder.ShareOrders(firstveh, ordervehicle);
    }

    AIVehicle.StartStopVehicle(firstveh);
    AIGroup.MoveVehicle(group, firstveh);
    //TODO: implement logic for multiple vehicles
    for (local idx = 2; idx <= number; idx++) {
        if (AICompany.GetBankBalance(AICompany.COMPANY_SELF) < price) {
            SetMinimumBankBalance(price);
        }
        local nextveh = AIVehicle.CloneVehicle(homedepot, firstveh, true);
        AIVehicle.StartStopVehicle(nextveh);
    }

    return true;
}

// register the route
function MyNewAI::RegisterRoute()
{
    local route = {
        src = null
        dst = null
        stasrc = null
        stadst = null
        homedepot = null
        group = null
        crg = null
        vehtype = null
        maxvehicles = null
    }

    route.src = src;
    route.dst = dst;
    route.stasrc = stasrc;
    route.stadst = stadst;
    route.homedepot = homedepot;
    route.group = group;
    route.crg = crg;
    route.vehtype = vehtype;
    route.maxvehicles = AIController.GetSetting("max_roadvehs");

    routes.push(route);
    groups.AddItem(group, routes.len() - 1);
    lastroute = AIDate.GetCurrentDate();
    return route;
}

// add a vehicle to an exsiting route
// pass mainvehile to copy the orders
function MyNewAI::AddVehicle(route, mainvehicle, engine)
{
    local roadvehicles = AIVehicleList();
    roadvehicles.Valuate(AIVehicle.GetVehicleType);
    roadvehicles.KeepValue(AIVehicle.VT_ROAD);
    if (roadvehicles.Count() + 1 > AIGameSettings.GetValue("vehicle.max_roadveh")) { return false; }
    if (BuildAndStartVehicles(engine, 1, mainvehicle)) {
        return true;
    } else {
        return false;
    }

}

function MyNewAI::IsRectangleWithinTownInfluence(tile, town_id, width, height)
{
    if (width <= 1 && height <= 1) { return AITile.IsWithinTownInfluence(tile, town_id); }

    local offsetX = AIMap.GetTileIndex(width - 1, 0);
    local offsetY = AIMap.GetTileIndex(0, height - 1);

    return AITile.IsWithinTownInfluence(tile, town_id) ||
                AITile.IsWithinTownInfluence(tile + offsetX + offsetY, town_id) ||
                AITile.IsWithinTownInfluence(tile + offsetX, town_id) ||
                AITile.IsWithinTownInfluence(tile, offsetY, town_id);

}

function MyNewAI::SetGroupName(group, stasrc)
{
    local groupname = AICargo.GetCargoLabel(0) + " - " + AIStation.GetName(stasrc);
    if (groupname.len() > 30) groupname = groupname.slice(0, 30);
    if (!AIGroup.SetName(group, groupname)) {
        // shorten the name if its too long
        while (AIError.GetLastError() == AIError.ERR_PRECONDITION_STRING_TOO_LONG) {
            groupname = groupname.slice(0, groupname.len() - 1);
            AIGroup.SetName(group, groupname);
        }
    }
}

function MyNewAI::BuildRoad(head1, head2)
{
    local pathfinder = RoadPathFinder();

    // set the cost for making a turn high
    pathfinder.cost.turn = 5000;

    pathfinder.InitializePath([head1], [head2]);

    // loop to find a path between the towns using the library implementing A* algorithm
    local path = false;
    while (path == false) {
        path = pathfinder.FindPath(100); //try to find a path in 100 iterations (longer iterations causes slowdown)
        this.Sleep(1);
    }

    if (path == null) {
        //no path was successfully found within the number of iterations
        AILog.Error("pathfinder.FindPath failed to find a path");
        return false;
    }

    // if path was found build a road over it
    while (path != null) {
        local par = path.GetParent();

        if (par != null) {
            local last_node = par.GetTile();

            // if the parent tile and the current tile are adjacent, build a road to connect them
            if (AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) == 1) {

                //try to build a road on top of the tile
                if (!AIRoad.BuildRoad(path.GetTile(), par.GetTile())) {
                    //TODO: Better Error Handling
                }
            } else{ 
                // if the parent tile and the current tile are not adjacent, either build a tunnel or a bridge to connect them
                if (!AIBridge.IsBridgeTile(path.GetTile()) && !AITunnel.IsTunnelTile(path.GetTile())) {
                    // if the tile is a road tile demolish it first
                    if (AIRoad.IsRoadTile(path.GetTile())) AITile.DemolishTile(path.GetTile());
                    // check that the parent tile would be the tile at the other end of the tunnel
                    if (AITunnel.GetOtherTunnelEnd(path.GetTile()) == par.GetTile()) {
                        // check the tunnel succesfully builds for road vehicles
                        if (!AITunnel.BuildTunnel(AIVehicle.VT_ROAD, path.GetTile())) {
                            AILog.Info("An error occured when building a tunnel between " + path.GetTile() + " and " + par.GetTile());
                            //TODO: Better error handling
                        }
                    } else {
                        // if the tunnel doesn't build, build a bridge instead
                        local bridge_list = AIBridgeList_Length(AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) + 1);
                        bridge_list.Valuate(AIBridge.GetMaxSpeed);
                        bridge_list.Sort(AIBridgeList.SORT_BY_VALUE, false);
                        // check the bridge succesfully builds
                        if (!AIBridge.BuildBridge(AIVehicle.VT_ROAD, bridge_list.Begin(), path.GetTile(), par.GetTile())) {
                            AILog.Info("An error occured when building a bridge between " + path.GetTile() + " and " + par.GetTile());
                            if (AIError.GetLastError() == AIError.ERR_NOT_ENOUGH_CASH) {
                                AILog.Warning("Bridge is too expensive. Construction aborted.");
                            }
                        } else {
                            roadbridges.AddTile(path.GetTile());
                        }

                    }
                }
            }
        }
        path = par;
        // check the cash on hand
        if (AICompany.GetBankBalance(AICompany.COMPANY_SELF) < (AICompany.GetLoanInterval() + GetMinimumCashNeeded())) {
			if (!GetMoney(AICompany.GetLoanInterval())) {
				AILog.Warning("I don't have enough money to complete the route.");
				return false;
			}
		}
    }

    return true;
}

// taken from SimpleAI
// in case inflation is enabled
function MyNewAI::GetInflationRate()
{

    return AICompany.GetMaxLoanAmount().tofloat() / AIGameSettings.GetValue("difficulty.max_loan").tofloat();
}
function MyNewAI::InflatedValue(amount)
{
    return (amount * GetInflationRate().tointeger());
}

// TODO: implement logic for servicing

// the total amount of money loaned at any given time
function MyNewAI::GetMoney(money)
{
    local toloan = AICompany.GetLoanAmount() + money;
    if (AICompany.SetMinimumLoanAmount(toloan)) { return true; }
    else { return false; }
}

// set the minimum amount of money needed
function MyNewAI::SetMinimumBankBalance(money)
{
    local needed = money - AICompany.GetBankBalance(AICompany.COMPANY_SELF);
    // check if the current balance is greater than the minimum already
    if (needed < 0) { return true; }
    else {
        if (GetMoney(needed)) { return true; }
        else { return false; }
    }
}

// taken from SimpleAI
// tries to at least maintain the loan step value
function MyNewAI::PayLoan()
{
    AILog.Info("Attempting to Pay Loan!!!");
    local balance = AICompany.GetBankBalance(AICompany.COMPANY_SELF);

    // overflow protection from DictatorAI
    // works because an overflow would result in a negative or very small positive number
    if (balance + 1 < balance) {
        if (AICompany.SetMinimumLoanAmount(0)) { return true; }
        else { return false; }
    }

    local money = 0 - (balance - AICompany.GetLoanAmount()) + GetMinimumCashNeeded();
    // if the cash on hand is less than the minimum needed then we take out more loan
    if (money > 0) {
		if (AICompany.SetMinimumLoanAmount(money)) { return true; }
		else return false;
    // if the cash on hand is greater than the minimum needed then we try to reduce the loaned amount to 0 (as close as possible)
	} else {
		if (AICompany.SetMinimumLoanAmount(0)) { return true; }
		else { return false; }
	}
}

// calculate the minimum amount of money needed to cover station maintenance per month
function MyNewAI::GetMinimumCashNeeded()
{
    // first get a list of all station owned by the company
    local stationlist = AIStationList(AIStation.STATION_ANY);

    // to account if inflation is enabled
    // each station cost $50 to maintain per month (from OpenTTD Wiki)
    // maintenance cost could change depending on the game settings of enabling and setting the intensity of maintenance costs
    local maintenance = InflatedValue(stationlist.Count() * 50);

    // loan interval refers to the increment of how much you can increase or decrease your loan at any moment
    return maintenance + AICompany.GetLoanInterval();
}

// calculate the max amount of money on hand if the maximum loan is taken
function MyNewAI::GetMaxBankBalance()
{
    local balance = AICompany.GetBankBalance(AICompany.COMPANY_SELF);
    local maxbalance = balance + AICompany.GetMaxLoanAmount() - AICompany.GetLoanAmount();

    return (maxbalance >= balance) ? maxbalance : balance;
}


// logic to replace a vehicle with a new vehicle
function MyNewAI::ReplaceVehicle(vehicle)
{
    local group = AIVehicle.GetGroupID(vehicle);
    //index the list to get the route object based on the group id
    local route = routes[groups.GetValue(group)];
    local engine = ChooseRoadVeh();
    local vehicles = AIVehicleList_Group(group);
    local ordervehicle = null;
    
    foreach(nextveh, dummy in vehicles) {
        ordervehicle = nextveh;
        // don't share orders with vehicles about to be sold
        if (nextveh != vehicle) { break; }
    }
    
    if (ordervehicle == vehicle) { ordervehicle = null; }
    if (engine != null && (GetMaxBankBalance() > AIEngine.GetPrice(engine))) {
        AIVehicle.SellVehicle(vehicle);
        AddVehicle(route, ordervehicle, engine);
    } else {
        AIVehicle.StartStopVehicle(vehicle);
    }
}

// taken from SimpleAI
// function to check and handle events
function MyNewAI::CheckEvents()
{
    local event = null;
    local eventtype = null;
    
    while (AIEventController.IsEventWaiting()) {
        event = AIEventController.GetNextEvent();
        eventtype = event.GetEventType();
    }

    if (eventtype == null) {
        return;
    }

    switch (eventtype) {
        case AIEvent.ET_SUBSIDY_AWARDED:
            break;

        case AIEventEnginePreview.Convert(event):
            if (event.AcceptPreview()) { AILog.Info("New engine available for preview: " + event.GetName()); }
            break;
        
        case AIEvent.ET_ENGINE_AVAILABLE:
            event = AIEventEngineAvailable.Convert(event);
            local engine = event.GetEngineID();
            AILog.Info("New engine available: " + AIEngine.GetName(engine));
            break;
        
        case AIEvent.ET_VEHICLE_CRASHED:
            local vehicle = event.GetVehicleID();

            event = AIEventVehicleCrashed.Convert(event);
            
            AILog.Info("One of my vehicles has crashed.");
            // remove it from the todepotlist if it's there. It might be another vehicle, but that's not a big problem
            if (todepotlist.HasItem(vehicle)) todepotlist.RemoveItem(vehicle);
            // check if it still exists
            if (!AIVehicle.IsValidVehicle(vehicle)) break;
            // check if it is still the same vehicle
            if (AIVehicle.GetState(vehicle) != AIVehicle.VS_CRASHED) break;
            local group = AIVehicle.GetGroupID(vehicle);
            if (!root.groups.HasItem(group)) break;
            local route = root.groups.GetValue(group);
            local newveh = AIVehicle.CloneVehicle(root.routes[route].homedepot, vehicle, true);
            if (AIVehicle.IsValidVehicle(newveh)) {
                AIVehicle.StartStopVehicle(newveh);
                AILog.Info("Cloned the crashed vehicle.");
            }
            break;

        case AIEvent.ET_COMPANY_IN_TROUBLE:
            // Some more serious action is needed, currently it is only logged
			event = AIEventCompanyInTrouble.Convert(event);
			local company = event.GetCompanyID();
			if (AICompany.IsMine(company)) AILog.Error("I'm in trouble, I don't know what to do!");
			break;

        case AIEvent.ET_COMPANY_NEW:
            // Welcome the new company
			event = AIEventCompanyNew.Convert(event);
			local company = event.GetCompanyID();
			AILog.Info("Welcome " + AICompany.GetName(company));
			break;

        case AIEvent.ET_VEHICLE_LOST:
            // No action taken, only logged
			event = AIEventVehicleLost.Convert(event);
			local vehicle = event.GetVehicleID();
			AILog.Error(AIVehicle.GetName(vehicle) + " is lost, I don't know what to do with that!");
			/* TODO: Handle it. */
			break;
        
        case AIEvent.ET_VEHICLE_UNPROFITABLE:
            local vehicle = event.GetVehicleID();
            event = AIEventVehicleUnprofitable.Convert(event);

            AILog.Info(AIVehicle.GetName(vehicle) + " is unprofitable sending it to depot");
            if (!AIVehicle.SendVehicleToDepot(vehicle)) {
                AIVehicle.ReverseVehicle(vehicle);
                AIController.Sleep(75);
                if (!AIVehicle.SendVehicleToDepot(vehicle)) { break; }
            }
            todepotlist.AddItem(vehicle, TD_SELL);
            break;

        case AIEvent.ET_VEHICLE_WAITING_IN_DEPOT:
            local vehicle = null;
            event = AIEventVehicleWaitingInDepot.Convert(event);
            vehicle = event.GetVehicleID();
            
            if (todepotlist.HasItem(vehicle)) {
                switch (todepotlist.GetValue(vehicle)) {
                    case TD_SELL:
                        // Sell a vehicle because it is old or unprofitable
                        AILog.Info("Sold " + AIVehicle.GetName(vehicle) + ".");
                        AIVehicle.SellVehicle(vehicle);
                        todepotlist.RemoveItem(vehicle);
                        break;
                    case TD_REPLACE:
                        // Replace an old vehicle with a newer model
                        ReplaceVehicle(vehicle);
                        break;
                }
            } else {
                // The vehicle is not in todepotlist
                AILog.Info("I don't know why " + AIVehicle.GetName(vehicle) + " was sent to the depot, restarting it...");
                AIVehicle.StartStopVehicle(vehicle);
            }
            break;

        case AIEvent.ET_TOWN_FOUNDED:
            event = AIEventTownFounded.Convert(event);
            local town = event.GetTownID;
            AILog.Info("New town founded: " + AITown.GetName(town));
            break;
    }
    
}

function MyNewAI::CheckRoutes()
{
    AILog.Info("Checking Routes!!!");
    foreach(idx, route in routes) {
        local vehicles = AIVehicleList_Group(route.group);

        if (vehicles.Count() == 0) {
            AILog.Info("Removing empty route: " + AIStation.GetName(route.stasrc) + " - " + AIStation.GetName(route.stadst));
            route.vehtype = null;
            groups.RemoveItem(route.group);
            AIGroup.DeleteGroup(route.group);
            DeleteRoadStation(route.stasrc);
            DeleteRoadStation(route.stadst);
            break;
        }

        // logic for adding vehicles to a route
        if ((vehicles.Count() < route.maxvehicles) && (AIStation.GetCargoWaiting(route.stasrc, route.crg) > max_waiting_time)) {
            AILog.Info("Adding Vehicles!");
            vehicles.Valuate(AIVehicle.GetProfitThisYear);
            // do not add new vehicles if there are unprofitable ones
            if (vehicles.GetValue(vehicles.Begin()) <= 0) { break; }

            // only add new vehicles if the newest one is at least of some age
            vehicles.Valuate(AIVehicle.GetAge);
            vehicles.Sort(AIList.SORT_BY_VALUE, true);
            if (vehicles.GetValue(vehicles.Begin()) > add_new_vehicle_age) { //add_new_vehicle_age
                local engine = ChooseRoadVeh();

                if (engine == null) { break; }
                if (GetMaxBankBalance() > (GetMinimumCashNeeded() + AIEngine.GetPrice(engine))) {
                    if (AddVehicle(route, vehicles.Begin(), engine)) {
                        AILog.Info("Added road vehicle to route: " + AIStation.GetName(route.stasrc) + " - " + AIStation.GetName(route.stadst));
                    }
                }
            }
        }

        // logic for replacing old vehicles in the route
        vehicles.Valuate(AIVehicle.GetAgeLeft);
        vehicles.KeepBelowValue(max_age_left);
        foreach(vehicle, dummy in vehicles) {
            AILog.Info("I'm here");
            if (todepotlist.HasItem(vehicle)) { continue; }
            local engine = ChooseRoadVeh();
            if (engine == null) { continue; }
            if (GetMaxBankBalance() > (GetMinimumCashNeeded() + AIEngine.GetPrice(engine))) {
                AILog.Info(AIVehicle.GetName(vehicle) + " is getting old, sending it to the depot...");
                if (!AIVehicle.SendVehicleToDepot(vehicle)) {
                    AIVehicle.ReverseVehicle(vehicle);
                    AIController.Sleep(75);
                    if (!AIVehicle.SendVehicleToDepot(vehicle)) { break; }
                }
                todepotlist.AddItem(vehicle, TD_REPLACE);
            }
        }

        // logic for checking vehicles in depot
        vehicles = AIVehicleList_Group(route.group);
        vehicles.Valuate(AIVehicle.IsStoppedInDepot);
        vehicles.KeepValue(1);
        foreach (vehicle, dummy in vehicles) {
            // a vehicle has probably been sitting there for ages if its current year/last year profits are both 0, and it's at least 2 months old
            if (AIVehicle.GetProfitLastYear(vehicle) != 0 || AIVehicle.GetProfitLastYear(vehicle) != 0 || AIVehicle.GetAge(vehicle) < 60) { continue; }
            if (todepotlist.HasItem(vehicle)) {
                todepotlist.RemoveItem(vehicle);
                AIVehicle.StartStopVehicle(vehicle);
            } else {
                AILog.Warning("Sold " + AIVehicle.GetName(vehicle) + ", as it has been sitting in the depot for ages.");
                AIVehicle.SellVehicle(vehicle);
            }
        }
    }
    CheckDefaultGroup();
}

function MyNewAI::CheckTodepotlist()
{
    local itemstoremove = [];
    foreach(vehicle, dummy in todepotlist) {
        if (!AIVehicle.IsValidVehicle(vehicle)) {
            AILog.Warning("There was an invalid vehicle in the todepotlist.");
            itemstoremove.push(vehicle);
            continue;
        }
        // if it's already in the depot it's ok
        if (AIVehicle.IsStoppedInDepot(vehicle)) { continue; }
        
        // check the vehicle destination
        local vehicle_destination = AIOrder.GetOrderDestination(vehicle, AIOrder.ORDER_CURRENT);
        
        if (!AIRoad.IsRoadDepotTile(vehicle_destination)) {
            itemstoremove.push(vehicle);
            AILog.Warning(AIVehicle.GetName(vehicle) + " is not heading for the depot even though it's supposed to!")
        }
    }

    foreach(item in itemstoremove) {
        todepotlist.RemoveItem(item);
    }
}

function MyNewAI::CheckDefaultGroup()
{
    local vehtype = AIVehicle.VT_ROAD;
    local vehicles = AIVehicleList_DefaultGroup(vehtype);
    vehicles.Valuate(AIVehicle.IsStoppedInDepot);
    vehicles.KeepValue(1);
    foreach (vehicle, dummy in vehicles) {
        // check for the vehicles sitting in the depot
        if (AIVehicle.GetProfitThisYear != 0 || AIVehicle.GetProfitLastYear != 0 || AIVehicle.GetAge(vehicle) < 60) { continue; }
        if (todepotlist.HasItem(vehicle)) {
            todepotlist.RemoveItem(vehicle);
            AIVehicle.StartStopVehicle(vehicle);
        } else {
            AILog.Warning("Sold " + AIVehicle.GetName(vehicle) + ", as it has been sitting in the depot for ages.");
            AIVehicle.SellVehicle(vehicle);
        }
    }
}

function MyNewAI::UpgradeRoadBridges()
{
    AILog.Info("Upgrading Road Bridges");
    foreach (tile, dummy in roadbridges) {
        // set the minimum cash on hand to be 50,000 so we stop building if we go below that value (inflation adjusted)
        if (!SetMinimumBankBalance(InflatedValue(50000))) { return; }
        if (!AITile.HasTransportType(tile, AITile.TRANSPORT_ROAD) || !AIBridge.IsBridgeTile(tile)) { continue; }
        local otherend = AIBridge.GetOtherBridgeEnd(tile);
        local bridgelist = AIBridgeList_Length(AIMap.DistanceManhattan(tile, otherend) + 1);
        bridgelist.Valuate(AIBridge.GetMaxSpeed);
        if (AIBridge.GetBridgeID(tile) == bridgelist.Begin()) { continue; }
        AIBridge.BuildBridge(AIVehicle.VT_ROAD, bridgelist.Begin(), tile, otherend);
    }

    bridgesupgraded = AIDate.GetYear(AIDate.GetCurrentDate());
}