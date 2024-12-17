Prestatu:

* UnrealPak.exe deskargatu eta direktorio batean utzi. (adibidez, /home/josu/git/itzulpenak/UnrealPak/UnrealPak.exe)
* Bi direktorio gottigo, Engine izeneko direktorio bat sortu: (adibidez, /home/josu/git/Engine)
  - Engine
    - Plugins
      - Compression
        - OodleData (Oodle konpresioarekin egindako pak fitxategiak deskonprimitzeko, adibide Cavaran SandWitch)
          - OoldeData.uplugin
          - Binaries
            - Win64
              - UnrealPak.modules
              - UnrealPak-OodleDataCompressionFormat.dll
    - Programs
      - UnrealPak
        - Saved
          - Config
            - Windows
              - Engine.ini
    - Saved
      - Config
        - Windows
          - Manifest.ini

* scripts/extract_pak.sh - PAK fitxategitik lokalizazio fitxategiak ateratzen ditu *.locres fitxategietan
* scripts/export_locres.sh - *.locres fitxategitik editatzeko moduko CSV bat exportatzen du
* itzulpenak egin
* scripts/import_locres.sh - *.locres-en fitxategia itzuli dugun CSVko datuekin eguneratzen du
  * en/Game.locres eguneratzen du eta sortutako Game.locres.new berria es/Game.locres-en ordez jartzen du
* scripts/create_pak.sh - *.locres eta horiek guztiekin PAK berria sortu
* scripts/list_pak.sh
  * hemen bilatu zein den es/Game.locres-en offset eta size
  * extract_loc_from_pak/src/main.zig-en offset eta size horiek jarri.
    * cd extract_loc_from_pak
    * zig build run (honek PAK fitxategitik itzulpeneko byteak erauzi eta data/eu_itzulpena.dat-en gordeko du)
  * (behin egin beharrekoa)
    * bilatu zein den fr/Game.locres-en offset eta size. es_offset/fr_offset eta es_size/fr_size data/installer.zig-eko aldagaietan jarri


* import_locres.sh
* create_loc_paks.sh

* split_loc_data