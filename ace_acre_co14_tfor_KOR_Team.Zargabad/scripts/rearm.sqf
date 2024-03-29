//rearm sqf. Should be called as: _null = ["servicePoint":Marker,repair radius:Number,thisTrigger] execVM "rearm.sqf";
// by Bon_Inf*. Dirty fixes by Operator.

_point = _this select 0;
_radius = _this select 1;
_activeTrigger = _this select 2;

_unit = ObjNull;
_minDistance = _radius + 0;
_activeTrigger setTriggerArea [0,0,0,false];

{
  _unitDistance = _x distance getMarkerPos _point;
  if (_unitDistance < _minDistance) then {_unit = _x; _minDistance = _unitDistance};
} foreach nearestObjects [getMarkerPos _point, ["Car", "Tank", "Helicopter"], _radius];

if(not isNil {_unit getVariable "repair_spam_protection"}) exitWith {sleep 2; _activeTrigger setTriggerArea [8,8,0,false];_unit vehiclechat "Сервис сейчас недоступен...";};

//Ремонт
_repaired = [_unit, _point, _radius] spawn {
  _unit = _this select 0;
	_point = _this select 1;
	_radius = _this select 2;
	
	_unit engineOn false;
	_unit setVelocity [100, 100, 100];
	sleep 0.1;
	_unit engineOn false;
	_unit setVelocity [100, 100, 100];

	_dmge = getDammage _unit;
	
	_repairtime = (_dmge*240) max 1;
	_repairvalue_per_step = _dmge/_repairtime;
	
	_unit vehicleChat "Начинаем ремонт. Двигатель должен быть выключен.";
	sleep 10;

	while{_unit distance getMarkerPos _point <= _radius && !(isEngineOn _unit) && getPos _unit select 2 < 1 && damage _unit > 0} do {	
		_unit setDamage ((damage _unit) - _repairvalue_per_step);
		sleep 1;
	};
	if(damage _unit == 0) then {_unit vehicleChat "Ремонт выполнен!"}
	else{_unit vehicleChat "Ремонт отменён."};
};

//Заправка
_refueled = [_unit, _point, _radius] spawn {
	_unit = _this select 0;
	_point = _this select 1;
	_radius = _this select 2;
  	  _unit engineOn false;
	sleep 12;
	_fuel_to_fill = 1 - (fuel _unit);

	_refueltime = 1 max (_fuel_to_fill*210);
	_refuelvalue_per_step = _fuel_to_fill/_refueltime;

	_unit vehicleChat "Заправка...";
	_unit engineOn false;

	while{_unit distance getMarkerPos _point <= _radius && !(isEngineOn _unit) && getPos _unit select 2 < 1 && fuel _unit < 0.99} do {
		_unit setFuel (fuel _unit) + _refuelvalue_per_step;
		sleep 1;
	};
	if(fuel _unit >= 0.99) then {_unit vehicleChat "Бак полностью заправлен!"}
	else{_unit vehicleChat "Заправка отменена."};
};

//Боезапас
_rearmed = [_unit, _point, _radius] spawn {
	_unit = _this select 0;
	_point = _this select 1;
	_radius = _this select 2;	
	
	_unit engineOn false;
	sleep 14;

	_usualMagReloadTime = 10; // seconds each step requires when refilling
	_turretMagReloadTime = 2;
	_unit vehicleChat "Перевооружение: сейчас боезапас будет перезаряжен. Это займёт некоторое время.";
	sleep 2;
	_currentAmmo = 0;
	_turretMagazines = [];
	_magazines = [];
  
  _list = magazines _unit;
  {_unit removeMagazine _x;} foreach _list;
  
  //Let's fill non-turret magazines - static pylons for helicopters for example.
	_magazines = getArray (configFile >> "CfgVehicles" >> typeof _unit >> "magazines");
  {_unit addMagazine _x;sleep _usualMagReloadTime;_currentAmmo = _currentAmmo + 1;} foreach _magazines;
  
  //checking, if vehicle have gunturret
  if (count (configFile >> "CfgVehicles" >> typeof _unit >> "turrets") > 0) then {
    _turretMagazines = getArray (((configFile >> "CfgVehicles" >> typeof _unit >> "turrets") select 0) >> "magazines");
    if (count _turretMagazines > 0) then {
        {
        if (!(isEngineOn _unit) && (_unit distance getMarkerPos _point <= _radius)) then {
          _currentAmmo = _currentAmmo + 1;
          _unit addMagazine _x;
          sleep _turretMagReloadTime;
          };
        } foreach _turretMagazines;
    };
  };
  
	if (_currentAmmo == (count _magazines + count _turretMagazines)) then {reload _unit; _unit setVehicleAmmo 1;_unit vehicleChat "Боезапас пополнен!";}
	else{_unit vehicleChat "Перезарядка отменена."};
};

waitUntil {sleep 0.1; scriptDone _repaired && scriptDone _refueled && scriptDone _rearmed};

[_unit] spawn {
  _unit = _this select 0;
  
  _unit setVariable ["repair_spam_protection",true];  
  sleep 60;
  _unit setVariable ["repair_spam_protection",nil];
};
sleep 2;
_unit vehiclechat "Обслуживание завершено! Освободите тех.сервис!";
sleep 1;
_unit vehiclechat "Следующий ремонт будет доступен через минуту.";
sleep 10;
_activeTrigger setTriggerArea [8,8,0,false];


//тема про проверку, села ли вертушка
// http://forums.bistudio.com/showthread.php?t=112537
// Как запасной вариан поставить АСЕшный просты базы реарма :) они нормально рабоатют :))))
//в АЦЕшные можно попробывать вписать слипы на ывполнение функций, или найти функции в АСЕ которвые выполняет объект!
// СЖЫМАТЬ триггер раньше при активации скрипта или уводить его зону под землю с утановкой лимина высоты срабатывания!