./import_locres.sh
./create_loc_paks.sh

pushd /home/josu/git/itzulpen_instalatzailea/
./create_installers.sh the_plucky_squire
popd

cp ../instalatzailea/the_plucky_squire_euskaraz_linux /tmp/
chmod 777 /tmp/the_plucky_squire_euskaraz_linux 
# cp ../eu_tps.csv /tmp/