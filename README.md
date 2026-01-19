# Assorted Scripts and Configs

## Ubuntu 20 Specific Setup

``` bash
sudo apt update && sudo apt -y upgrade
sudo apt install -y git gnome-tweaks vim xclip curl tree flameshot cmake xorg-dev libglu1-mesa-dev git-lfs ffmpeg kazam gpustat meshlab liburdfdom-tools terminator python3.8-venv python3-wheel python3-pip python3.8-dev caffeine

python3.8 -m pip install --upgrade pip
git config --global user.email "jsmorgan6@gmail.com"

# Install python3.10
# download source from https://www.python.org/downloads/release/python-3100/
cd ~/Downloads/Python-3.10.0
./configure --enable-optimizations
make -j 5
sudo make altinstall
python3.10


# snap installs need to be entered one by one for some reason
sudo snap install chromium
sudo snap install slack
sudo snap install okular
sudo snap install code --classic
sudo snap install sublime-text --classic
sudo snap install gnome-terminator --beta
sudo snap install standard-notes
sudo snap connect standard-notes:password-manager-service


# System settings
Tweaks -> Keyboard and Mouse -> Additional Layout Options -> Ctrl position -> Caps Lock as Ctrl
Settings -> Power -> Screen Blank -> 15 minutes
Settings -> Accessibility -> Repeat Keys -> Delay/Speed more aggressive 
Terminator -> Prefereces -> Profiles -> Scrolling, check 'Infinite Scrollback'

# CUDA INSTALL
...
# check
nvcc --version
```

## Ubuntu 22 Specific Setup
```bash
# apts
sudo apt update && sudo apt upgrade
sudo apt install -y gnome-shell-extension-manager gnome-tweaks git gnome-tweaks vim xclip curl tree cmake xorg-dev libglu1-mesa-dev git-lfs ffmpeg kazam gpustat meshlab liburdfdom-tools terminator python3-wheel caffeine

# snaps
sudo snap install standard-notes slack
sudo snap install tmux --classic

# System settings
Tweaks -> Keyboard and Mouse -> Additional Layout Options -> Ctrl position -> Caps Lock as Ctrl
Settings -> Power -> Screen Blank -> 15 minutes
Settings -> Accessibility -> Repeat Keys -> Delay/Speed more aggressive 
Settings -> Multitasking -> Hot Corner = true
Settings -> Multitasking -> Application Switching -> "Include applications from the current workspace only"
```


## Ubuntu General Setup
```bash
# add chrome
https://www.google.com/chrome/ # go to and download+install chrome
https://chromewebstore.google.com/detail/keyboard-navigator-for-go/ndlmonkfnjfeglacjljmmnjbklkmdjpm  # web-search-navigator
https://chromewebstore.google.com/detail/fast-scroll/ecnjcglleblahonnenpaiofkabfakgdi           # fast scroll
https://chromewebstore.google.com/detail/adblock-%E2%80%94-block-ads-acros/gighmmpiobklfepjocnamgkkbiglidom   # ad block
https://chromewebstore.google.com/detail/df-tube-new-distraction-f/kchgllkpfcggmdaoopkhlkbcokngahlg # DF Tube New (Distraction Free for YouTube™)

# Install cursor
# Download .deb from https://cursor.com/download
mkdir -p ~/.config/Cursor/User/
curl https://raw.githubusercontent.com/jstmn/r_scripts/refs/heads/master/vscode_keybindings.json > keybindings.json && mv keybindings.json ~/.config/Cursor/User/
curl https://raw.githubusercontent.com/jstmn/r_scripts/refs/heads/master/vscode_settings.json > settings.json && mv settings.json ~/.config/Cursor/User/

# add vscode
https://code.visualstudio.com/download # download + install
cd /tmp/
curl https://raw.githubusercontent.com/jstmn/r_scripts/refs/heads/master/vscode_settings.json > settings.json && mv settings.json ~/.config/Code/User/
curl https://raw.githubusercontent.com/jstmn/r_scripts/refs/heads/master/vscode_keybindings.json > keybindings.json && mv keybindings.json ~/.config/Code/User/

echo "alias pbcopy='xclip -selection clipboard'" >> ~/.bashrc
echo "alias pbpaste='xclip -selection clipboard -o'" >> ~/.bashrc
echo "alias gb='git branch'" >> ~/.bashrc
echo "alias gs='git status'" >> ~/.bashrc
echo "set -g mouse on" >> ~/.tmux.conf
echo "set -g history-limit 50000" >> ~/.tmux.conf
echo "alias gpoh='git push origin HEAD'" >> ~/.bashrc
echo "alias gpcb='git push origin $(git branch --show-current)'" >> ~/.bashrc

# setup github key
ssh-keygen -t ed25519 -C "jsmorgan6@gmail.com"
ssh-add ~/.ssh/id_ed25519
# then go to https://github.com/settings/ssh/new and add key

mkdir ~/Libraries
mkdir ~/Projects
```
