#! /bin/bash

source $1

function lynis_scan {
    
    # Check if lynis is installed
    
    if ! command -v lynis &> /dev/null; then
        changed=false
        msg="Lynis is not installed"
        return
    fi
    
    # Check if the user is root
    
    if [ "$EUID" -ne 0 ]; then
        changed=false
        msg="Please run this script as root"
        return
    fi
    
    # Check if the auditor is provided
    
    if [ -z "$auditor" ]; then
        auditor="Ansible"
    fi
    
    lynis audit system --quiet --auditor $auditor > $dest
    
    if [ $? -eq 0 ]; then
        changed=true
        msg="Lynis scan completed successfully"
    else
        changed=false
        msg="Lynis scan failed"
    fi
}

function lynis_scan_schedule {
    
    # Check if lynis is installed
    
    if ! command -v lynis &> /dev/null; then
        changed=false
        msg="Lynis is not installed"
        return
    fi
    
    # Check if the user is root
    
    if [ "$EUID" -ne 0 ]; then
        changed=false
        msg="Please run this script as root"
        return
    fi
    
    lynis audit system --cronjob --quiet --auditor "Ansible"
    
    if [ $? -eq 0 ]; then
        changed=true
        msg="Lynis scan scheduled successfully"
    else
        changed=false
        msg="Lynis scan scheduling failed"
    fi
}


case $state in
    scan)
        lynis_scan
    ;;
    schedule)
        lynis_scan_schedule
    ;;
    *)
        changed=false
        msg="Invalid state"
    ;;
esac

printf '{"changed": %s, "msg": "%s"}' "$changed" "$msg"

exit 0
