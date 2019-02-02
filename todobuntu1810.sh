#!/bin/bash

VERSION="1810-beta1";
HELP="
run: sudo /.todobundu1810
Run with sudo on user you are using daily.
More help will come soon :)";

if [[ ( $1 = -v ) || ( $1 = --version ) ]]; then  
	echo "Version $VERSION"; exit;
fi

if [[ ( $1 = -h ) || ( $1 = --help ) ]]; then 
	echo ${HELP}; exit;
fi

if [[ $UID != 0 ]]; then 
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

displayHeader() {
	printf "\033c"
	echo "--------------------------------------------------------------------------------"
	if $1; then sleep 0.5; fi
	echo "----------------------------Welcome to todobuntu1810!---------------------------"
	if $1; then sleep 0.5; fi
	echo "--------------------------------------------------------------------------------"
	sleep 0.5;
	echo ""
}

executeCommands() {
	commands=("$@")
	for i in "${commands[@]}"
	do
	    echo "";
	    echo "Executing: $i";
	    echo "";
	    sleep 1;
	    eval $i;
	done
	echo "";
	echo "EXECUTED!";
	read -n 1 -s -r -p "Press any key to continue...";
	echo "";
}

#askUserYesOrNo "How YOU doin'?"
askUserYesOrNo (){ 
	while true; do
		read -p "$1 [y or n]: " decision
		case ${decision} in
			[Yy]* ) return 1; break;;
			[Nn]* ) return 0; break;;
		esac
	done	
}
# local result=$?    gives 1 if answear was 'yes' and 0 if 'no'

#askUserForProgrammeInstall "name" "package-name";
#askUserForProgrammeInstall "name" "package-name" "ppa:username/ppaname";
askUserForProgrammeInstall (){ 
	while true; do
		read -p "Install $1? [y or n]: " decision
		case ${decision} in
			[Yy]* ) 
				programList+=($2); 
				if [[ $3 != "" ]]; then
					repoList+=($3);
				fi
				return 1;
				break;;
			[Nn]* ) 
				return 0;
				break;;
		esac
	done	
}
# local result=$?    gives 1 if programme is going to be installed and 0 if not

#askUserForFileInstall "name" "package-name.deb" "wget-link";
askUserForFileInstall (){ 
	displayHeader false;
	askUserYesOrNo "Install $1";
	if [[ $? == 1 ]]; then
		declare -a commands=(
			"wget '$3' -O $2"
			"sudo dpkg -i $2"
			"sudo apt install -f -y"
			"rm -rf $2")
		executeCommands "${commands[@]}";
		return 1;
	else 
		return 0; fi
}
# local result=$?    gives 1 if programme is going to be installed and 0 if not

enableAllRepositories() {
	declare -a commands=(
		"sudo rm -rf /etc/apt/sources.list && touch /etc/apt/sources.list"
		"sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted universe multiverse'" 
		"sudo add-apt-repository -y 'deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner'" 
		"sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-security main restricted universe multiverse'" 
		"sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted universe multiverse'" 
		"sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-proposed main restricted universe multiverse'" 
		"sudo add-apt-repository -y 'deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-backports main restricted universe multiverse'" )
	executeCommands "${commands[@]}";
}

updateAndUpgrade() {
declare -a commands=(
		"sudo apt update"
		"sudo apt upgrade -y")
	executeCommands "${commands[@]}";
}

swapSnap() {
	declare -a commands=(
		"snap remove gnome-calculator gnome-characters gnome-logs gnome-system-monitor gnome-3-26-1604;"
		"apt install -y gnome-calculator gnome-system-monitor;")
	executeCommands "${commands[@]}";
}

configureNvidia() {
	declare -a commands=(
		"sudo add-apt-repository -y ppa:graphics-drivers/ppa;"
		"sudo apt update;"
		"sudo ubuntu-drivers autoinstall;")
	executeCommands "${commands[@]}";
}

configureAMD() {
	declare -a commands=(
		"sudo add-apt-repository -y pa:oibaf/graphics-drivers;"
		"sudo apt update;"
		"sudo ubuntu-drivers autoinstall;")
	executeCommands "${commands[@]}";
}

configureIntel() {
	declare -a commands=(
		"sudo apt update;"
		"sudo ubuntu-drivers autoinstall;")
	executeCommands "${commands[@]}";
}

configureDrivers() {
	while true; do
		echo "";
		read -r -p "What manufacture does your graphics card come from, Nvidia, AMD or intel? [n, a, i or cancel]: " decision
		case ${decision} in
			[Nn]* )
				configureNvidia; break;;
			[Aa]* )
				configureAMD; break;;
			[Ii]* )
				configureIntel; break;;
			cancel )
				break;;
		esac
	done;
}

addGitBranchNameInPrompt() {
	echo "" >> /home/${SUDO_USER}/.bashrc;
	echo "force_color_prompt=yes" >> /home/${SUDO_USER}/.bashrc;
	echo "color_prompt=yes" >> /home/${SUDO_USER}/.bashrc;
	echo "parse_git_branch() {" >> /home/${SUDO_USER}/.bashrc;
	echo "    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'" >> /home/${SUDO_USER}/.bashrc;
	echo "}" >> /home/${SUDO_USER}/.bashrc;
	echo "if [ \"\$color_prompt\" = yes ]; then" >> /home/${SUDO_USER}/.bashrc;
	echo "    PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\\$ '" >> /home/${SUDO_USER}/.bashrc;
	echo "else" >> /home/${SUDO_USER}/.bashrc;
	echo "    PS1='\${debian_chroot:+(\$debian_chroot)}\u@\h:\w\$(parse_git_branch)\\$ '" >> /home/${SUDO_USER}/.bashrc;
	echo "fi" >> /home/${SUDO_USER}/.bashrc;
	echo "unset color_prompt force_color_prompt" >> /home/${SUDO_USER}/.bashrc;
}

#################################################################################
############################### --- START HERE --- ##############################
#################################################################################

displayHeader true;
askUserYesOrNo "Enable all default repositories?";
if [[ $? == 1 ]]; then enableAllRepositories; fi

displayHeader false;
askUserYesOrNo "Perform an update of all packages?";
if [[ $? == 1 ]]; then updateAndUpgrade; fi

displayHeader false;
askUserYesOrNo "Swap snap programs for apt ones?";
if [[ $? == 1 ]]; then swapSnap; fi

displayHeader false;
askUserYesOrNo "Configure drivers? ";
if [[ $? == 1 ]]; then configureDrivers; fi

displayHeader false;
echo "Chose what programmes you want to install: (instalation from repositories)";
sleep 1;
programList=();
repoList=();
programInstallCommand="sudo apt install -y";
addRepositoryCommand="sudo add-apt-repository -y";

askUserForProgrammeInstall "GIMP" "gimp";
askUserForProgrammeInstall "Steam" "steam"; 
askUserForProgrammeInstall "KolourPaint" "kolourpaint"; 
askUserForProgrammeInstall "VLC Media Player" "vlc"; 
askUserForProgrammeInstall "TLP" "tlp tlp-rdw";
askUserForProgrammeInstall "Ubuntu Restricted Extras" "ubuntu-restricted-extras";
askUserForProgrammeInstall "GNOME Tweak Tool (Tweaks)" "gnome-tweak-tool";
askUserForProgrammeInstall "GRUB Customizer" "grub-customizer" "ppa:danielrichter2007/grub-customizer";
askUserForProgrammeInstall "Flat Remix (icon theme)" "flat-remix" "ppa:daniruiz/flat-remix";
askUserForProgrammeInstall "Git" "git";
if [[ $? == 1 ]]; then
	askUserYesOrNo "Show git branch name in prompt?";
	if [[ $? == 1 ]]; then addGitBranchNameInPrompt; fi
fi

displayHeader false;
echo "Installing...";
sleep 1;

#Add repositories
for i in "${repoList[@]}"
do
	executeCommands "${addRepositoryCommand} ${i}";
	executeCommands "sudo apt update";
done

#Install programmes
for i in "${programList[@]}"
do
    programInstallCommand+=" $i";
    sleep 1;
done
if [[ ${#programInstallCommand[@]} != 0]]; then executeCommands "${programInstallCommand}"; fi

displayHeader false;
echo "Chose what programmes you want to install: (instalation from .deb files)";
sleep 2;
SPOTIFY_URL=http://repository.spotify.com/pool/non-free/s/spotify-client/
wget $SPOTIFY_URL &> /dev/null
SPOTIFY_URL+=$(awk -F\" '/href=/{print $2}' index.html | grep amd64 | sed '1 d')
rm -rf index.html
askUserForFileInstall "Google Chrome" "chrome.deb" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb";
askUserForFileInstall "Spotify"      "spotify.deb" "$SPOTIFY_URL$SPOTIFY_NAME";
askUserForFileInstall "Skype"        "skype.deb"   "https://go.skype.com/skypeforlinux-64.deb";
askUserForFileInstall "Team Viewer"  "tv.deb"      "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb";
askUserForFileInstall "Etcher"       "etcher.deb"  "https://github.com/resin-io/etcher/releases/download/v1.4.9/balena-etcher-electron_1.4.9_amd64.deb";
askUserForFileInstall "Discord"      "discord.deb" "https://discordapp.com/api/download?platform=linux&format=deb";

displayHeader false;
echo "Thanks, that's it for now :)";
sleep 1;



################################################################################
###############################-TODO-###########################################
################################################################################
#
#Test more thoroughly!!!
#
#
#Enable flat-remix after installing
#gsettings set org.gnome.desktop.interface icon-theme 'MyIconTheme'
#
#
#Install gnome extensions (dash-to-panel, alternatab, drop-down-terminal, arc-menu), and propose preconfigured config files
#
################################################################################
################################################################################
################################################################################
