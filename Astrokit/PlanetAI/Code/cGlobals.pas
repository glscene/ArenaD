unit cGlobals;

interface

uses
  cAISpace,
  cAIReality,
  cAIEnvironment,
  cAIPosition,
  cAIThings,
  cAIForce;

var

gPlanetRadius: single;
gPlanetHeight: integer;
gPlanetWidth: integer;
gWidthSingle: single;
gHeightSingle: single;
gHalfWidthSingle: single;
gHalfHeightSingle: single;

gWorldWidth: single;
gWorldHeight: single;
gHalfWorldWidth: single;
gHalfWorldHeight: single;
gOneQuarterWorldHeight: single;
gThreeQuartersWorldHeight: single;

gUniqueHandle: integer;

gReality: AIReality;
gEnvironment: AIEnvironment;
gSpace: AISpace;
gThings: AIThingList;

gGravity: AIForce;
gAirFriction: AIForce;
gLandFriction: AIForce;
gWaterFriction: AIForce;

gVersion: integer;

function UniqueHandle: integer;

//gWorldState: AIWorldState;

implementation

// 0 is null handle
function UniqueHandle: integer;
begin
  gUniqueHandle := gUniqueHandle + 1;
  result := gUniqueHandle;
end;


end.
