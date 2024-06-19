# AnsibleLynisModule
an Ansible Module to perform a scan with Lynis

## How to use

1. Add the code to your Ansible library "/library"

2. Execute it

adhoc
```bash
ANSIBLE_LIBRARY=./library ansible -m lynis_scan -a 'state=scan' localhost --ask-become-pass
```

playbook
```yml
- name: Perform Lynis Audit
  become: true
  become_method: sudo
  lynis_scan:
    state: scan
```
