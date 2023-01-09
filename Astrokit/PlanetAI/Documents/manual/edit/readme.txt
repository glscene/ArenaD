AI.PLANET MANUAL

This manual is open source and belongs to the ai.planet project.
http://www.aiplanet.org

Created by Dennis Murczak - dennis@aiplanet.org


FILES

i_view32.exe		Graphics converter. Full distribution available at
			http://www.irfanview.com
i_view32.ini		Irfanview's config file. Use to set the JPEG compression.
makeweb.exe		Utility (file parser) for webmanual.bat
webmanual.bat		Use to build a web version of the manual with JPG graphics
[OFFLINE]		Contains the original manual with high-quality PNG images.
[WEB]			This is where the web version is built.
[UNUSED]		Contains files that were prepared but aren't used yet in the
			manual.
[MAKEWEB PROJECT]	The Visual Basic 6 source code of makeweb.exe


HOW TO BUILD

Just launch webmanual.bat. The old build will be wiped out and rebuilt. Note
that ALL files in the WEB directory will be lost. The build process achieves
some disk space saving by converting the high-quality PNG files to JPEG
versions. Of course the HTML files will be parsed and updated to make use
of the JPG versions. Set the JPG compression rate in i_view32.ini if you
don't want to use the default of 85% quality.


VERSION NUMBERING SCHEME

The scheme is <aiplanet_version>.R<build_number>
So the third build based on the 0.98 version of ai.planet would be 0.98.R3
Don't forget to increase the build number in the HTML files manually before
publishing your build. If your build is based on a new version of ai.planet,
i.e. some feature is described that wasn't in an older version, reset the
build number to 1, so in this example the version would go to 0.99.R1


DOC WRITER'S NOTE

I'm preserving the right to change the structure of the help system, i.e.
introduce JavaScript, stylesheets, a new layout or similar.


NOTES

Don't use WYSIWYG editors for the HTML files, as they mess around with the
code. Use a code based editor like 1st Page 2000 from EvrSoft,
http://www.evrsoft.com.
