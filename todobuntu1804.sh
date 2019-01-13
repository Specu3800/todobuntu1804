#!/bin/bash

VERSION="1804-alpha1";
HELP="not yet";

swapSnap() {
	declare -a commands=(
		"snap remove gnome-calculator gnome-characters gnome-logs gnome-system-monitor gnome-3-26-1604;"
		"apt install -y gnome-calculator gnome-system-monitor;")

	for i in "${commands[@]}"
	do
	    echo "";
	    echo "Executing: ";
	    echo $i;
	    sleep 1;
		eval $i;
	done
}

configNvidia() {
	declare -a commands=(
		"sudo add-apt-repository -y ppa:graphics-drivers/ppa;"
		"sudo apt update;"
		"sudo ubuntu-drivers autoinstall;")

	for i in "${commands[@]}"
	do
	    echo "";
	    echo "Executing: ";
	    echo $i;
	    sleep 1;
		eval $i;
	done
}

configAMD() {
	declare -a commands=(
		"sudo add-apt-repository -y pa:oibaf/graphics-drivers;"
		"sudo apt update;"
		"sudo ubuntu-drivers autoinstall;")

	for i in "${commands[@]}"
	do
	    echo "";
	    echo "Executing: ";
	    echo $i;
	    sleep 1;
		eval $i;
	done
}









#show version
if [[ ( $1 = -v ) || ( $1 = --version ) ]]; then
	echo "Version $VERSION"; exit;
fi

#show help
if [[ ( $1 = -h ) || ( $1 = --help ) ]]; then
	echo ${HELP}; exit;
fi

#force sudo execution
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi



echo "-------------------------------------"
echo "------Welcome to todobuntu1804!------"
echo "-------------------------------------"


#Actual functionality
while true; do
    echo "";
    read -p "Do you wish to swap snap programs for apt ones? [y or n]: " decision
    case ${decision} in
        [Yy]* )
            swapSnap; break;;
        [Nn]* )
            echo "Skipping programs swap..."; break;;
    esac
done

while true; do
    echo "";
    read -p "Configure graphics drivers? [y or n]: " decision
    case ${decision} in
        [Yy]* )
            while true; do
                echo "";
                read -p "What manufacture does your graphics card comes from, Nvidia or AMD? [n or a or cancel]: " decision
                case ${decision} in
                    [Nn]* )
                        configNvidia; break;;
                    [Aa]* )
                        configAMD; break;;
                    cancel )
                        echo "Skipping graphics drivers configuration..."; break;;
                esac
            done;
            break;;
        [Nn]* )
            echo "Skipping graphics drivers configuration..."; break;;
    esac
done


echo "Let's install few programs, shall we? ";
sleep 1;
programList=();
repoList=();
programInstallCommand="sudo apt install -y ";
addRepositoryCommand="sudo add-apt-repository -y  ";

while true; do
    echo "";
    read -p "Install gimp? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('gimp'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install grub-customizer? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('grub-customizer'); repoList+=('ppa:daniruiz/flat-remix'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install flat-remix? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('flat-remix'); repoList+=('ppa:daniruiz/flat-remix'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install gnome-tweak-tool? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('gnome-tweak-tool'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install chrome-gnome-shell? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('chrome-gnome-shell'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install tlp? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('tlp'); programList+=('tlp-rdw'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install ubuntu-restricted-extras? [y or n]: " decision
    case ${decision} in
        [Yy]* ) programList+=('ubuntu-restricted-extras'); break;;
        [Nn]* ) break;;
    esac
done

while true; do
    echo "";
    read -p "Install git? [y or n]: " decision
    case ${decision} in
        [Yy]* )
            programList+=('git');
            while true; do
                echo "";
                read -p "Show git branch name in prompt? [y or n]: " decision
                case ${decision} in
                    [Yy]* )
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
                        break;;
                    [Nn]* )
                        break;;
                esac
            done;
            break;;
        [Nn]* ) break;;
    esac
done

echo "";
echo "OK! Let's do this! ";
sleep 1;

for i in "${repoList[@]}"
do
    echo "";
    echo "Executing: ";
    echo ${addRepositoryCommand} ${i};
    sleep 1;
    eval ${addRepositoryCommand} ${i};
done

for i in "${programList[@]}"
do
    programInstallCommand+=" $i";
    sleep 1;
done
echo "";
echo "Executing: ";
echo ${programInstallCommand};
eval ${programInstallCommand};


echo "";
echo "Thanks, that's it for now :)";









