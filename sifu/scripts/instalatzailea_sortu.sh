./import_locres.sh
./create_loc_paks.sh

pushd /home/josu/git/itzulpen_instalatzailea/
./create_installers.sh sifu
popd

cp /home/josu/git/itzulpenak/sifu/instalatzailea/sifu_euskaraz_linux /tmp/