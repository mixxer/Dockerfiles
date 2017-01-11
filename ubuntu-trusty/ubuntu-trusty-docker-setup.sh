#!/bin/bash

list_tasks_to_be_installed=(
"openssh-server"
)

list_pkgs_to_be_uninstalled=(
)

list_pkgs_to_be_prohibited=(

)

list_pkgs_to_be_installed=(
"cmake"
"automake"
"autotools-dev"
"autoconf"
"autopoint"
"libtool"
"sudo"
"curl"
"git"
"htop"
"tig"
"bzip2"
"gzip"
"tar"
"wget"
"gcc-multilib"
"g++-multilib"
"libstdc++6:i386"
"zlib1g:i386"
"bison"
"build-essential"
"chrpath"
"diffstat"
"gawk"
"language-pack-en"
"python3"
"python3-jinja2"
"texi2html"
"texinfo"
"ruby"
"libpulse-dev"
)

pre_process()
{
	echo "bash bash/sh boolean false" | debconf-set-selections
	dpkg-reconfigure --frontend noninteractive bash

	echo "debconf debconf/frontend select noninteractive" | debconf-set-selections

	rm -f /etc/apt/apt.conf.d/docker-clean

	user="$(getent passwd 1000 | cut -d: -f1)"
	home="$(getent passwd 1000 | cut -d: -f6)"
}

install_prerequisites()
{
	dpkg --add-architecture i386
	apt-get -y update
	apt-get -y install apt-transport-https ca-certificates tasksel
}

install_all()
{
	# tasksel
	aptitude_install_command="apt-get -y install"
	for task in "${list_tasks_to_be_installed[@]}"; do
		list_pkg=($(tasksel --task-packages ${task}))
		aptitude_install_command="${aptitude_install_command} ${list_pkg[@]}"
		eval $aptitude_install_command
	done

	# purge exist packages
	aptitude_remove_command="apt-get -y purge"
	aptitude_remove_command="${aptitude_remove_command} ${list_pkgs_to_be_uninstalled[@]}"
	eval $aptitude_remove_command

	apt-get -y autoclean

	# install packages
	aptitude_install_command="apt-get -y install"
	aptitude_install_command="${aptitude_install_command} ${list_pkgs_to_be_installed[@]}"
	eval $aptitude_install_command
}

post_process()
{
	echo "debconf debconf/frontend select dialog" | debconf-set-selections

	user="$(getent passwd 1000 | cut -d: -f1)"
	home="$(getent passwd 1000 | cut -d: -f6)"
}

main()
{
	pre_process
	install_prerequisites
	install_all
	post_process
}

main
