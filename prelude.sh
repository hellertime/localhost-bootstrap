#!/bin/sh

set -ex

function die {
    local msg="$1"
    echo "$msg" && exit 1
}

function die_unsupported {
    local system="$1"
    die "Unsupported system $system"
}

function get_os {
    local system="darwin"
    if [[ $(which lsb_release 2> /dev/null) != "" ]]; then
        system=$(lsb_release -si | tr '[:upper:]' '[:lower:]' )
    fi
    echo $system
}

function configure_install {
    local s=$(get_os)
    case $s in
        ubuntu)
            sudo apt-get update
    	    ;;
        fedora)
            die_unsupported $s
    	    ;;
        darwin)
            #/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            die_unsuppoted $s
    	    ;;
        *)
    	    die_unsupported $s
    	    ;;
    esac
}

function install {
    local s=$(get_os)
    case $s in
        ubuntu)
            sudo apt-get install -y $@
            ;;
        fedora)
            die_unsupported $s
            ;;
        darwin)
            die_unsupported $s
            ;;
        *)
            die_unsupported $s
            ;;
    esac
}

function add_apt_repo {
    local s=$(get_os)
    case $s in
        ubuntu)
            sudo apt-get install -y software-properties-common
            sudo apt-add-repository $1
            sudo apt-get update
            ;;
        *)
            # noop
            ;;
    esac
}

configure_install

add_apt_repo ppa:ansible/ansible

install git
install ansible
