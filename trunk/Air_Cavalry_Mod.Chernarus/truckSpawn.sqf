if(isServer) then
{
//player globalchat "Truckspawn activated";
_point = _this select 1;
_dest = _this select 0;
_rand = random 1;
if (_rand <= 0.7) then {
	//player globalchat "you're really fucking dead!";
	_myGroup = createGroup resistance;
	_tempSoldier1 = _myGroup createUnit ["GUE_Commander",getMarkerPos _point,[],0.8,"Sergeant"];
	_tempSoldier2 = _myGroup createUnit ["GUE_Soldier_Medic",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier3 = _myGroup createUnit ["GUE_Soldier_MG",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier4 = _myGroup createUnit ["GUE_Soldier_AR",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier5 = _myGroup createUnit ["GUE_Soldier_AT",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier6 = _myGroup createUnit ["GUE_Soldier_GL",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier7 = _myGroup createUnit ["GUE_Soldier_2",getMarkerPos _point,[],0.6,"Private"];
	_tempSoldier8 = _myGroup createUnit ["GUE_Soldier_3",getMarkerPos _point,[],0.6,"Private"];

	removeAllWeapons _tempSoldier7;
	for "_x" from 1 to 6 do {_tempSoldier7 addMagazine "30Rnd_762x39_AK47"};
	_tempSoldier7 addWeapon "ACE_AKM";
	_tempSoldier7 addMagazine "HandGrenade_West";

	removeAllWeapons _tempSoldier8;
	for "_x" from 1 to 6 do {_tempSoldier8 addMagazine "30Rnd_762x39_AK47"};
	_tempSoldier8 addWeapon "ACE_AKM";
	_tempSoldier8 addMagazine "HandGrenade_West";

sleep 0.1;

_truck = "V3S_Gue" createVehicle (getMarkerPos _point);
_tempSoldier1 moveInDriver _truck;
_tempSoldier2 moveInCargo _truck;
_tempSoldier3 moveInCargo _truck;
_tempSoldier4 moveInCargo _truck;
_tempSoldier5 moveInCargo _truck;
_tempSoldier6 moveInCargo _truck;
_tempSoldier7 moveInCargo _truck;
_tempSoldier8 moveInCargo _truck;

wp = _myGroup addwaypoint [getMarkerPos _dest, 0];
wp setWaypointType "SAD";
wp setWaypointSpeed "FULL";
};
};