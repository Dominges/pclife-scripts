disableSerialization;

hunger=0;

while {alive player} do {
_unit=player;
if (!isNil {player getVariable "spectating"}) then {_unit=player getVariable "spectating"};
if (true) then {
hunger=hunger+1;
sleep 0.5;
1 cutRsc ["hud4","PLAIN"];
_ui=uiNamespace getVariable "hud4";
_hud=_ui displayCtrl 23501;
_hud ctrlSetPosition [safeZoneX+SafeZoneW-.2,safeZoneY+safeZoneH-0.059];
_Food="";
if (hunger<0) then {_Food="FoodFull.jpg";hunger=0;};
if (hunger==0) then {_Food="FoodFull.jpg";};
if (hunger==1) then {_Food="Food10.jpg";};
if (hunger==2) then {_Food="Food20.jpg";};
if (hunger==3) then {_Food="Food30.jpg";};
if (hunger==4) then {_Food="Food40.jpg";};
if (hunger==5) then {_Food="Food50.jpg";};
if (hunger==6) then {_Food="Food60.jpg";};
if (hunger==7) then {_Food="Food70.jpg";};
if (hunger==8) then {_Food="Food80.jpg";};
if (hunger==9) then {_Food="Food90.jpg";};
if (hunger==10) then {player setdammage (getdammage player) + hunger/100;_Food="Food100.jpg";};
if (hunger>10) then {player setdammage (getdammage player) + hunger/100;hunger=10;_Food="Food100.jpg";};
_hud ctrlSetText _Food;
_hud ctrlCommit 0;
sleep 1;
};
sleep 400;
};