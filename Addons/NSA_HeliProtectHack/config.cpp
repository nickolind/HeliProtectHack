class CfgPatches
{
	class NSA_HeliProtectHack
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.5;
		requiredAddons[] = {};
		author[] = { "Nickorr" };
        version = 1.0.0;
        versionStr = "1.0.0";
        versionAr[] = {1,0,0};
	};
};

class CfgFunctions
{
	class NSA
	{
		class HeliProtectHack
		{
			file = "NSA_HeliProtectHack\functions";
			class HeliProtectHack
			{
				postInit = 1;
			};
		};
	};
};