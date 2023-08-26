# NAS Infra

> Based on Fedora Server

1. Generate ssh pass for `user`
1. Push ssh pass: `ssh-copy-id user@host`
1. Create `/hosts`
1. Create `/vars/main.yml`
1. Run ansible
   `ansible-playbook --inventory ./hosts --ask-become-pass ./site.yml`

## Ansible dev

```
ansible-playbook \
  --inventory ./hosts \
  --extra-vars "ansible_ssh_pass=\"${PASSWORD}\"" \
  --extra-vars "ansible_become_pass=\"${PASSWORD}\"" \
  ./site.yml
```
