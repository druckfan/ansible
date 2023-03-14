#!/bin/bash
# Creates an empty playbook

read -p "playbook dir name: " playbook_name


while true; do
read -p "role name (type \"done\" to finish) : " role_name
if [[ $role_name == "done" ]]; then break; fi

cd /home/linus/git_repos/ansible
mkdir -p Playbooks/${playbook_name}/roles/$role_name/tasks

if [[ ! -f "Playbooks/${playbook_name}/${playbook_name}.yml" ]]; then
cat <<< "- hosts: \"{{ host }}\"
  gather_facts: no
  remote_user: sysdrift
  become: yes
  become_method: sudo
  roles:
  - $role_name" > Playbooks/${playbook_name}/${playbook_name}.yml; else
  echo "  - $role_name" >> Playbooks/${playbook_name}/${playbook_name}.yml
fi

cat <<< "- debug:
    msg: Running playbook on inventory host {{ inventory_hostname }}
- shell: /usr/bin/uptime
  register: result
- debug:
    msg: Uptime of host {{ inventory_hostname }} is {{ result.stdout }}" > Playbooks/${playbook_name}/roles/$role_name/tasks/main.yml

cd Playbooks/${playbook_name}/
done

cd /home/linus/git_repos/ansible

tree Playbooks/${playbook_name}

echo "Run playbook like this:
cd /home/linus/git_repos/ansible/Playbooks/${playbook_name}
ansible-playbook -i inventories/example ${playbook_name}.yml -e host=localhost"
