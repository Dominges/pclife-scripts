//Zombie horde script by Celery

if (!isServer) exitWith {};

_trigger=_this select 0;
_amount=round (_this select 1);
_hordename=_this select 2;
_zombietype=if (count _this>3) then {_this select 3} else {"normal"};
_triggerpos=[getPos _trigger select 0,getPos _trigger select 1,0];
_radius=(triggerArea _trigger select 0) max (triggerArea _trigger select 1);

sleep random 1;

//Create altitude detector
_altlogic="HeliHEmpty" createVehicleLocal _triggerpos;

//Prepare positions
_positions=[];
for "_x" from 1 to _amount do {
	_pos=[0,0,0];
	_relocate=true;
	//Relocate if position is on water or on a structure or close to player
	while {_relocate} do {
		_pos=[(_triggerpos select 0)-_radius+random _radius*2,(_triggerpos select 1)-_radius+random _radius*2,0];
		_altlogic setPos [_pos select 0,_pos select 1,1000];
		if ([_trigger,_pos] call BIS_fnc_inTrigger and !surfaceIsWater _pos and (getPos _altlogic select 2)==(getPosATL _altlogic select 2)) then {_relocate=false};
	};
	//Add to array
	_positions set [count _positions,_pos];
};

//Spawn zombies
for "_x" from 0 to (count _positions)-1 do {
	waitUntil {{side _x==east or side _x==west or side _x==resistance} count allGroups<432};
	//Create unit
	_side=resistance;
	if ({side _x==resistance} count allGroups>=144) then {_side=west};
	if (_side==west and {side _x==west} count allGroups>=144) then {_side=east};
	_group=createGroup _side;
	_class=if !(_zombietype in ["armored","slow armored"]) then {
		call CLY_randomzombie;
	} else {
		call CLY_randomarmoredzombie;
	};
	_zombie=_group createUnit [_class,getPos zombiespawner,[],50,"NONE"];
	_zombie enableSimulation false;
	_victim=CLY_players select (floor random count CLY_players);
	_horde=true;
	
	//Initialize zombification
	[_zombie,_zombietype,_victim,_horde,0,_positions select _x] exec "zombie_scripts\cly_z_init.sqs";
};

//deleteVehicle _trigger;
//deleteVehicle _altlogic;