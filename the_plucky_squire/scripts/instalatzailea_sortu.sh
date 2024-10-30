./import_locres.sh
./create_loc_paks.sh

pushd ../pak_diff
zig build run
read -p "Kopiatu goiko zenbakia [split_loc_data/src/main.zig:footer_ind] aldagaiean eta sakatu enter"
popd

pushd ../split_loc_data
zig build run
popd

pushd /home/josu/git/itzulpen_instalatzailea/
./create_installers.sh the_plucky_squire
popd