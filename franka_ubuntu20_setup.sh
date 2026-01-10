=============== librealsense 

sudo apt-get install -y libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev git wget cmake build-essential libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev 

# download librealsense-2.50.0.tar.gz from https://github.com/IntelRealSense/librealsense/releases/tag/v2.50.0
mv Downloads/librealsense-2.50.0.tar.gz Libraries/
cd Libraries/
tar xf librealsense-2.50.0.tar.gz
cd librealsense-2.50.0
./scripts/setup_udev_rules.sh
# skipping the kernel patching stuff
# The following instructions are from https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md
mkdir build && cd build
cmake ../ -DBUILD_EXAMPLES=true -DCMAKE_BUILD_TYPE=Release
sudo make uninstall
make clean
make -j 4   # make sure to do a low number. Getting a compiler error otherwise
sudo make install
# check:
realsense-viewer



=============== Ros

# Install ros noetic if it isn't installed already (from https://wiki.ros.org/noetic/Installation/Ubuntu):
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install ros-noetic-desktop
# Then:
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential



=============== RealSense Ros
# Download realsense-ros-2.3.2 from https://github.com/IntelRealSense/realsense-ros/releases/tag/2.3.2 and move to ~/src/franka_ws/src
# - This is the latest realsense-ros release latest that supports LibRealSense v2.50.0

sudo apt install ros-noetic-ddynamic-reconfigure




=============== Ros Noetic / Franka
# noetic install: https://wiki.ros.org/noetic/Installation/Ubuntu
# ros cheat sheet: https://mirror.umd.edu/roswiki/attachments/de/ROScheatsheet.pdf
# catkin cheat sheet: https://catkin-tools.readthedocs.io/en/latest/cheat_sheet.html

sudo apt install ros-noetic-franka-ros

source /opt/ros/noetic/setup.bash
mkdir -p ~/ros/franka_ws/src
cd ~/ros/franka_ws
catkin_make
source devel/setup.bash



=============== Deoxys
# follow tutorial from here: https://zhuyifengzju.github.io/deoxys_docs/html/installation/codebase_installation.html
# USE 0.8.0
cd ~
git clone https://github.com/jstmn/deoxys_control.git  

# Once you create a virtual environment with deoxys installed (`pip install -U -r path/to/deoxys/requirements.txt`) you'll need to also run this:
pip install matplotlib tqdm "protobuf<3.21"





=============== Ros Noetic / Franka

source /home/jstm/Projects/mpcm2/deoxys_venv/bin/activate
PYTHONPATH=$PYTHONPATH:/home/jstm/Libraries/deoxys_control/deoxys
#rosrun franka_extrinsics panda_joint_state_publisher.py interface_cfg_filepath:=/home/jstm/Projects/mpcm2/configs/charmander.yml
rosrun franka_extrinsics panda_joint_state_publisher /home/jstm/Projects/mpcm2/configs/charmander.yml

lsof -i :5555 # to get PID of process using port 5555 (the port used by deoxys)


# Terminal 1
source /opt/ros/noetic/setup.bash; source /home/jstm/ros/franka_ws/devel/setup.bash; source /home/jstm/Projects/mpcm2/deoxys_venv/bin/activate; cd /home/jstm/ros/franka_ws
python /home/jstm/ros/franka_ws/src/franka_extrinsics/scripts/panda_joint_state_publisher.py deoxys_interface_cfg_filepath:=/home/jstm/Projects/mpcm2/configs/charmander.yml

# Temp
source /opt/ros/noetic/setup.bash; source /home/jstm/ros/franka_ws/devel/setup.bash; source /home/jstm/Projects/mpcm2/deoxys_venv/bin/activate; cd /home/jstm/ros/franka_ws
python /home/jstm/ros/franka_ws/src/franka_extrinsics/scripts/tf_publisher.py


# Terminal 2
roslaunch franka_extrinsics main.launch \
	json_file_path:=/home/jstm/Projects/mpcm2/realsense_config.json \
	deoxys_interface_cfg_filepath:=/home/jstm/Projects/mpcm2/configs/charmander.yml





# Running:
roslaunch realsense2_camera demo_pointcloud.launch json_file_path:=/home/jstm/Projects/mpcm2/realsense_config.json

