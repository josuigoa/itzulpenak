cp ../extracted_backup/Sifu/Content/Localization/Game/en/Game.locres ../extracted/Sifu/Content/Localization/Game/en/
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Game/en/Game.locres ../loc_csv/en/game_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Game/en/Game.locres.new ../loc/es_loc/Sifu/Content/Localization/Game/es/Game.locres
cp ../extracted/Sifu/Content/Localization/Game/en/Game.locres.new ../loc/fr_loc/Sifu/Content/Localization/Game/fr/Game.locres

cp ../extracted_backup/Sifu/Content/Localization/Barks/en/Barks.locres ../extracted/Sifu/Content/Localization/Barks/en/
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres ../loc_csv/en/barks_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres.new ../loc/es_loc/Sifu/Content/Localization/Barks/es/Barks.locres
cp ../extracted/Sifu/Content/Localization/Barks/en/Barks.locres.new ../loc/fr_loc/Sifu/Content/Localization/Barks/fr/Barks.locres

cp ../extracted_backup/Sifu/Content/Localization/Dialogues/en/Dialogues.locres ../extracted/Sifu/Content/Localization/Dialogues/en/
wine ../UnrealLocres.exe import ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres ../loc_csv/en/dialogues_en_eu_locres.csv -f csv
cp ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres.new ../loc/es_loc/Sifu/Content/Localization/Dialogues/es/Dialogues.locres
cp ../extracted/Sifu/Content/Localization/Dialogues/en/Dialogues.locres.new ../loc/fr_loc/Sifu/Content/Localization/Dialogues/fr/Dialogues.locres
