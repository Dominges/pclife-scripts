// by Bon_Inf*
// gets
//	- position,
//	- radius
//	- max. gradient (optional) in [0,1],
//	- gradient area size (optional) in metres
// returns
//	either: a flat area regarding to input away from roads,
//	or: a random position in given radius


private ['_position','_radius','_pos','_maxgradient','_gradientarea'];


_position = _this select 0;
_radius = _this select 1;
if(count _this > 2) then {_maxgradient = _this select 2} else {_maxgradient = 0.1};   // in [0,1]
if(count _this > 3) then {_gradientarea = _this select 3} else {_gradientarea = 5};   // in metres



for "_i" from 1 to 10000 do {
	_pos = [(_position select 0) + _radius - random (2*_radius),(_position select 1) + _radius - random (2*_radius),0];
	_pos = 	_pos isflatempty [
		10,				//--- Minimal distance from another object
		0,				//--- If 0, just check position. If >0, select new one
		_maxgradient,			//--- Max gradient
		_gradientarea,			//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		ObjNull				//--- Ignored object
	];
	if(if(count _pos > 0) then{_pos set [2,0]; if(count (_pos nearRoads 20) == 0) then{true} else{false}} else{false}) exitWith{};
};
if(count _pos == 0) then{_pos = [(_position select 0) + _radius - random (2*_radius),(_position select 1) + _radius - random (2*_radius),0];};





_pos;