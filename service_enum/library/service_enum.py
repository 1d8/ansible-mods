#!/usr/bin/python


DOCUMENTATION = r'''
---
module: service_enum
short_description: Gather all stopped or started services.
description:
- Gather all stopped or started service(s).
options:
  desired_state:
    description:
    - The state of services to be returned. If you want to see what services have been stopped, provide the argument "stopped". If you want to see what services are currently running, provide the argument "started".
    type: str
author:
- Issac (@1d8)
'''

EXAMPLES = r'''
- name: Return names of all running services
  hosts: all
  vars:
    ansible_shell_type: powershell
    ansible_shell_executable: powershell.exe
  tasks:
    - name: Enumerate running services
      service_enum:
        desired_state: running
      register: result

- name: Return names of all stopped services
  hosts: all
  vars:
    ansible_shell_type: powershell
    ansible_shell_executable: powershell.exe
  tasks:
    - name: Enumerate stopped services
      service_enum:
        desired_state: stopped
      register: result
'''

RETURN = r'''
services:
  service name
'''
