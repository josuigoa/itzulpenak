* scripts/extract_pak.sh - PAK fitxategitik lokalizazio fitxategiak ateratzen ditu *.locres fitxategietan
* scripts/export_locres.sh - *.locres fitxategitik editatzeko moduko CSV bat exportatzen du
* itzulpenak egin
* scripts/import_locres.sh - *.locres-en fitxategia itzuli dugun CSVko datuekin eguneratzen du
  * en/Game.locres eguneratzen du eta sortutako Game.locres.new berria es/Game.locres-en ordez jartzen du
* scripts/create_pak.sh - *.locres eta horiek guztiekin PAK berria sortu
* scripts/list_pak.sh
  * hemen bilatu zein den es/Game.locres-en offset eta size
  * extract_loc_from_pak/src/main.zig-en offset eta size horren bidez PAK berritik euskarazko itzulpena ateri.
  * itzulpen hori data/eu_itzulpena.dat-en utzi