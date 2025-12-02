# Game ES
cp ../extracted_backup/Sifu/Content/Localization/Game/en/Game.locres ../extracted/Sifu/Content/Localization/Game/en/
sed 's/::gaztelera::/Euskara/g' ../loc_csv/en/game_en_eu_locres_lang_tpl.csv > ../loc_csv/en/game_en_eu_locres.csv
sed -i 's/::frantsesa::/Frantsesa/g' ../loc_csv/en/game_en_eu_locres.csv
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Game/en/Game.locres ../loc_csv/en/game_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Game/en/Game.locres.new ../loc/es_loc/Sifu/Content/Localization/Game/es/Game.locres

# Game FR
cp ../extracted_backup/Sifu/Content/Localization/Game/en/Game.locres ../extracted/Sifu/Content/Localization/Game/en/
sed 's/::gaztelera::/Gaztelera/g' ../loc_csv/en/game_en_eu_locres_lang_tpl.csv > ../loc_csv/en/game_en_eu_locres.csv
sed -i 's/::frantsesa::/Euskara/g' ../loc_csv/en/game_en_eu_locres.csv
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Game/en/Game.locres ../loc_csv/en/game_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Game/en/Game.locres.new ../loc/fr_loc/Sifu/Content/Localization/Game/fr/Game.locres

# BARKS
cp ../extracted_backup/Sifu/Content/Localization/Barks/en/Barks.locres ../extracted/Sifu/Content/Localization/Barks/en/
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres ../loc_csv/en/barks_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres.new ../loc/es_loc/Sifu/Content/Localization/Barks/es/Barks.locres
cp ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres.new ../loc/fr_loc/Sifu/Content/Localization/Barks/fr/Barks.locres

# DIALOGUES
cp ../extracted_backup/Sifu/Content/Localization/Dialogues/en/Dialogues.locres ../extracted/Sifu/Content/Localization/Dialogues/en/
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres ../loc_csv/en/dialogues_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres.new ../loc/es_loc/Sifu/Content/Localization/Dialogues/es/Dialogues.locres
cp ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres.new ../loc/fr_loc/Sifu/Content/Localization/Dialogues/fr/Dialogues.locres
