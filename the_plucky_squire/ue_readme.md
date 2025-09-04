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

* scripts/extract_pak.sh -> PAK fitxategitik lokalizazio fitxategiak ateratzen ditu *.locres fitxategietan
* scripts/export_locres.sh -> *.locres fitxategitik editatzeko moduko CSV bat exportatzen du
* itzulpenak egin
* scripts/import_locres.sh -> *.locres-en fitxategia itzuli dugun CSVko datuekin eguneratzen du
  * en/Game.locres eguneratzen du eta sortutako Game.locres.new berria es/Game.locres-en ordez jartzen du
* scripts/create_loc_paks.sh -> *.locres hori bakarrik duen PAK fitxategi bat sortzen du jokoak espero duen egiturarekin