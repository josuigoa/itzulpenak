cp ../extracted_backup/Storybook/Content/Localization/Game/en/Game.locres ../extracted/Storybook/Content/Localization/Game/en/
wine ../UnrealLocres.exe import ../extracted/Storybook/Content/Localization/Game/en/Game.locres ../eu_tps.csv -f csv
# mv ../extracted/Storybook/Content/Localization/Game/en/Game.locres.new ../extracted/Storybook/Content/Localization/Game/es/Game.locres
cp ../extracted/Storybook/Content/Localization/Game/en/Game.locres.new ../loc/en_loc/Storybook/Content/Localization/Game/en/Game.locres