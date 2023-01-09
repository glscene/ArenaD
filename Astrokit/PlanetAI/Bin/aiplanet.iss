; -- aiplanet.iss --

[Setup]
AppName=ai.planet
AppVerName=Artificial Planet 0.8
DefaultDirName={pf}\aiplanet
DisableProgramGroupPage=yes
; ^ since no icons will be created in "{group}", we don't need the wizard
;   to ask for a group name.
UninstallDisplayIcon={app}\aiplanet.exe
ChangesAssociations=yes

[Files]
Source: "aiplanet.exe"; DestDir: "{app}"
Source: "Readme.txt"; DestDir: "{app}"; Flags: isreadme
Source: "changes.txt"; DestDir: "{app}";
Source: "gpl.txt"; DestDir: "{app}";
Source: "construction.log"; DestDir: "{app}"
Source: "bass.dll"; DestDir: "{app}"
;audio
Source: "audio\707kick.wav"; DestDir: "{app}\audio"
Source: "audio\accessdeniedfemale.wav"; DestDir: "{app}\audio"
Source: "audio\bird-die.wav"; DestDir: "{app}\audio"
Source: "audio\blast.wav"; DestDir: "{app}\audio"
Source: "audio\bliptick.wav"; DestDir: "{app}\audio"
Source: "audio\clamp.wav"; DestDir: "{app}\audio"
Source: "audio\cricket.wav"; DestDir: "{app}\audio"
Source: "audio\crunch.wav"; DestDir: "{app}\audio"
Source: "audio\electronicping.wav"; DestDir: "{app}\audio"
Source: "audio\explode.wav"; DestDir: "{app}\audio"
Source: "audio\fire.wav"; DestDir: "{app}\audio"
Source: "audio\forest.wav"; DestDir: "{app}\audio"
Source: "audio\hawk.wav"; DestDir: "{app}\audio"
Source: "audio\incoming.wav"; DestDir: "{app}\audio"
Source: "audio\lightrainloop.wav"; DestDir: "{app}\audio"
Source: "audio\lion.wav"; DestDir: "{app}\audio"
Source: "audio\mouse1.wav"; DestDir: "{app}\audio"
Source: "audio\mouse2.wav"; DestDir: "{app}\audio"
Source: "audio\nightengale.wav"; DestDir: "{app}\audio"
Source: "audio\ohhh.wav"; DestDir: "{app}\audio"
Source: "audio\pigeon.wav"; DestDir: "{app}\audio"
Source: "audio\plink.wav"; DestDir: "{app}\audio"
Source: "audio\quake3.wav"; DestDir: "{app}\audio"
Source: "audio\rocksmash.wav"; DestDir: "{app}\audio"
Source: "audio\shock.wav"; DestDir: "{app}\audio"
Source: "audio\shutdowninprocess.wav"; DestDir: "{app}\audio"
Source: "audio\Snare1.wav"; DestDir: "{app}\audio"
Source: "audio\sparrow.wav"; DestDir: "{app}\audio"
Source: "audio\START.wav"; DestDir: "{app}\audio"
Source: "audio\superior.wav"; DestDir: "{app}\audio"
Source: "audio\throw.wav"; DestDir: "{app}\audio"
Source: "audio\uproot.wav"; DestDir: "{app}\audio"
Source: "audio\waterdrop.wav"; DestDir: "{app}\audio"
Source: "audio\watersplash.wav"; DestDir: "{app}\audio"
Source: "audio\watersploosh.wav"; DestDir: "{app}\audio"
Source: "audio\whodaman.wav"; DestDir: "{app}\audio"
Source: "audio\Zwarble.wav"; DestDir: "{app}\audio"
Source: "audio\tiger.wav"; DestDir: "{app}\audio"
Source: "audio\quack.wav"; DestDir: "{app}\audio"
;models
Source: "models\asteroid.3ds"; DestDir: "{app}\models"
Source: "models\beacon.3ds"; DestDir: "{app}\models"
Source: "models\bird-1.3ds"; DestDir: "{app}\models"
Source: "models\bird-2.3ds"; DestDir: "{app}\models"
Source: "models\bird-3.3ds"; DestDir: "{app}\models"
Source: "models\bird-4.3ds"; DestDir: "{app}\models"
Source: "models\birddead.3ds"; DestDir: "{app}\models"
Source: "models\bird-sit.3ds"; DestDir: "{app}\models"
Source: "models\newtree.3ds"; DestDir: "{app}\models"
Source: "models\cloud.3ds"; DestDir: "{app}\models"
Source: "models\crab.3ds"; DestDir: "{app}\models"
Source: "models\dynamite.3ds"; DestDir: "{app}\models"
Source: "models\fish.3ds"; DestDir: "{app}\models"
Source: "models\fruit.3ds"; DestDir: "{app}\models"
Source: "models\grassblade.3ds"; DestDir: "{app}\models"
Source: "models\grazer.3ds"; DestDir: "{app}\models"
Source: "models\hawk.3ds"; DestDir: "{app}\models"
Source: "models\orangetree.3ds"; DestDir: "{app}\models"
Source: "models\rain.3ds"; DestDir: "{app}\models"
Source: "models\seed.3ds"; DestDir: "{app}\models"
Source: "models\shark.3ds"; DestDir: "{app}\models"
Source: "models\spirit.3ds"; DestDir: "{app}\models"
Source: "models\terrier.3ds"; DestDir: "{app}\models"
Source: "models\turtle.3ds"; DestDir: "{app}\models"
Source: "models\tyranno.3ds"; DestDir: "{app}\models"
Source: "models\weapon.3ds"; DestDir: "{app}\models"
Source: "models\iceberg.3ds"; DestDir: "{app}\models"
Source: "models\duck.3ds"; DestDir: "{app}\models"
Source: "models\dolphin1.3ds"; DestDir: "{app}\models"
Source: "models\dolphin2.3ds"; DestDir: "{app}\models"
Source: "models\dolphin3.3ds"; DestDir: "{app}\models"
;textures
Source: "textures\alltex.bmp"; DestDir: "{app}\textures"
Source: "textures\sunfire.bmp"; DestDir: "{app}\textures"
Source: "textures\moonshine.bmp"; DestDir: "{app}\textures"
Source: "textures\highlighter.bmp"; DestDir: "{app}\textures"
Source: "textures\cloud-tex.bmp"; DestDir: "{app}\textures"
Source: "textures\glacier.bmp"; DestDir: "{app}\textures"
Source: "textures\beachball.JPG"; DestDir: "{app}\textures"
Source: "textures\soccer.JPG"; DestDir: "{app}\textures"
Source: "textures\rock.JPG"; DestDir: "{app}\textures"
Source: "photos\readme.txt"; DestDir: "{app}\photos"
Source: "worlds\readme.txt"; DestDir: "{app}\worlds"

[Icons]
Name: "{commonprograms}\Artificial Planet 0.8"; Filename: "{app}\aiplanet.exe"
Name: "{userdesktop}\Artificial Planet 0.8"; Filename: "{app}\aiplanet.exe"

[Registry]
Root: HKCR; Subkey: ".air"; ValueType: string; ValueName: ""; ValueData: "Artificial Planet"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "MyProgramFile"; ValueType: string; ValueName: ""; ValueData: "My Program File"; Flags: uninsdeletekey
Root: HKCR; Subkey: "MyProgramFile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\aiplanet.exe,0"
Root: HKCR; Subkey: "MyProgramFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\aiplanet.exe"" ""%1"""

