	for "_x" from 1 to 4 do {
		_point = format ["city1p%1", _x];
		_null = [_point] call compile preprocessFileLineNumbers "spawnSquad.sqf";
		sleep 0.1;
	};
	for "_i" from 1 to 4 do {
		_point = format ["city1f%1", _i];
		_null = [_point, 5] call compile preprocessFileLineNumbers "createForestPatrol.sqf";
		sleep 0.1;
	};
	_null = ["city1", 2, 445, 285] execVM "createFortification.sqf";
	_truckTrigger = createTrigger["EmptyDetector",getMarkerPos "city1"];
	_truckTrigger setTriggerArea[300,300,0,false];
	_truckTrigger setTriggerActivation["ANY","PRESENT",false];
	_truckTrigger setTriggerStatements["{_x in thislist} count units group player >= 1", "_null = ['city1','truck1'] execVM 'truckSpawn.sqf';", ""];
	_winTrigger = createTrigger["EmptyDetector",getMarkerPos "city1"];
	_winTrigger setTriggerArea[600,600,0,false];
	_winTrigger setTriggerActivation["ANY","PRESENT",false];
	_winTrigger setTriggerStatements["({side _x==resistance} count thislist == 0) AND ({_x in thislist} count units group player >= 1)", "enemyDown = 1; [-2, {_null = [] execVM _this}, 'task2.sqf'] call CBA_fnc_globalExecute; for '_x' from 1 to 2 do {_montblanc = format ['city1a%1', _x];_null = ['city1', _montblanc] execVM 'spawnAttackers.sqf';};", ""];