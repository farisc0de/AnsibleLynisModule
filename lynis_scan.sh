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
    
    lynis audit system --auditor "Ansible" > /tmp/lynis_scan.log
    
    if [ $? -eq 0 ]; then
        changed=true
        msg="Lynis scan completed successfully"
        contents=$(cat " /tmp/lynis_scan.log" 2>&1 | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
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

printf '{"changed": %s, "msg": "%s", "contents": %s}' "$changed" "$msg" "$contents"

exit 0
