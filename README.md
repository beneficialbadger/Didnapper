# Didnapper

## Open the project in RPG Maker XP

RPG Maker XP uses Ruby encoded binary files during development and runtime. In order to convert the json files, here in source control, to the correct format, follow the steps below to encode the files.

* Clone the repository

   `git clone https://github.com/Didnapper/Didnapper`
* Merge CommonEvents.json

   `python mergeCommonEvents.py (requires Python 3)`
* Open RpgMakerEncoder, and click `Encode`

   `./Didnapper/RpgMakerEncoder/RpgMakerEncoder.exe`
* Open the project file in RPG Maker XP

   `./Didnapper/Didnapper/Game.rxproj`

## Save changes for source control

* Save the changes made in RPG Maker XP
* Open RpgMakerEncoder, and click `Decode`

   `./Didnapper/RpgMakerEncoder/RpgMakerEncoder.exe`
* Split CommonEvents.json

   `python splitCommonEvents.py (requires Python 3)`
* Commit the changes

   `git commit`
