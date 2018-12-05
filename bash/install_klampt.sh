cd $1
sudo apt-get install g++ cmake git libboost-system-dev libboost-thread-dev freeglut3 freeglut3-dev libglpk-dev python-dev python-opengl libxmu-dev libxi-dev libqt4-dev
sudo apt-get install libassimp-dev
git clone https://github.com/krishauser/Klampt
cd Klampt/Library
make unpack-deps -j8
make deps -j8
cd ..
cmake .
make Klampt -j8
make apps -j8
make python -j8
sudo make python-install -j8
sudo apt-get install ffmpeg