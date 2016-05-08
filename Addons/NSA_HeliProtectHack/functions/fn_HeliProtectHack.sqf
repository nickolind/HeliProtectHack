/*
	To activate - in init.sqf enter:
		
		NSA_protectHelis = true;
*/

if (isNil {NSA_protectHelis}) exitWith {};
if (typeName NSA_protectHelis != "BOOL") exitWith {};
if !(NSA_protectHelis) exitWith {};


NSA_hph_heliProtectHack = {
	if !((_this select 0) getVariable ["NSA_heliProtect", true]) exitWith {
		
		if (!isNil { (_this select 0) getVariable "NSA_hph_vehEH" }) then {
			(_this select 0) removeEventHandler ["local", ((_this select 0) getVariable "NSA_hph_vehEH")];
			(_this select 0) setVariable ["NSA_hph_vehEH", nil];
		};
	};
	
	(_this select 0) allowDamage false;
	
	[(_this select 0)] spawn {
		private ["_cHeli"];
		
		_cHeli = _this select 0;
		while {local _cHeli} do {
			
			if ( 
				( (getPosATL _cHeli select 2) > 10 ) 
				|| 
				(((getPosATL _cHeli) distance (_cHeli getVariable "NSA_hph_oriPos")) > 50) 
				|| 
				( ((serverTime / 60) - ((_cHeli getVariable "NSA_hph_misStartTime") / 60)) > 30 )
			
			) exitWith {
				_cHeli allowDamage true;
				_cHeli setVariable ["NSA_heliProtect", false, true];
				
				if ( (!isNil {(_cHeli getVariable "NSA_hph_vehEH")}) ) then {
					_cHeli removeEventHandler ["local", (_cHeli getVariable "NSA_hph_vehEH")];
					_cHeli setVariable ["NSA_hph_vehEH", nil];
				};
			};
			
			sleep 0.54;
		};
	};
};


{
	if ( (_x isKindOf "Helicopter") && (_x getVariable ["NSA_heliProtect", true]) ) then {
		
		if (isServer) then {
			if ( isNil{_x getVariable "NSA_hph_oriPos"} ) then {
				_x setVariable ["NSA_hph_oriPos", position _x, true];
			};
			
			if ( isNil{_x getVariable "NSA_hph_misStartTime"} ) then {
				_x setVariable ["NSA_hph_misStartTime", serverTime, true];
			};
		};
		
		_hph_EH = _x addEventHandler ["local", { 
			if ( _this select 1 ) then {
				[_this select 0] call NSA_hph_heliProtectHack;
			};
		}];
		_x setVariable ["NSA_hph_vehEH", _hph_EH];
		
		if (local _x) then { [_x] call NSA_hph_heliProtectHack; };
	
	};
} forEach vehicles;