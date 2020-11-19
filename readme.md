# Queer Haus Ansible definition
These files describe and define how all servers and service are run on queer.haus. This repository is used to handle changes in configuration and to set up and start new servers.

## Requirements

### Ansible 
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

```bash
macos$ brew install ansible
linux$ sudo apt install ansible
```

### Bitwarden CLI tool 
https://bitwarden.com/help/article/cli/#download-and-install

```bash
macos$ brew install bitwarden-cli
linux$ sudo snap install bw
```


## Usage examples
Running these commands will ask for `BECOME password:`, then enter your personal queerhaus linux user sudo password.

To run all configuration commands on our staging hosts:
```bash
make stage
```

To run all configuration updates in PRODUCTION:
```bash
make production
```

To download a local copy of all staging data as a backup
```bash
make download-staging
```

Download a local copy of all production data as a backup
```bash
make download-production
```

Deploy a new version of our hometown repo in production
```bash
make deploy-hometown-production
```

Restart hometown services in production (queer.haus)
```bash
make restart-hometown-production
```


## Ansible vault
Many secret values in this repo like tokens, passwords and other sensitive data is encrypted using Ansible Vault. An encrypted value in the YAML file looks like this.

```yaml
smtp_user: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  39653634343538343236373065376364326635323966363035616532316161386136626566366262
```

Many encrypted values are also stored in a single file `group_vars/all/vault`. These are then referenced in `group_vars/all/vars` as `{{ vault_variable_name }}`.

To decrypt these values you need the master password that was used to encrypt them. We use the open source password manager BitWarden to store this vault password. Included in this repo is a small script that will automatically ask you to login to and unlock your bitwarden account to retrieve this password.

Once BitWarden is unlocked and the password retrieved, all encrypted values will automatically be decrypted as you run Ansible commands.


## Add a new linux user
To be able to run any of these commands you need to have access to the servers. We do this with a personal user that has your SSH public key. All linux users that exist on our servers are defined in `group_vars/all/vars`.

### Generate ssh key
First you need an SSH key. If you already have one you can use that. Check if you have a key:
```bash
cat ~/.ssh/id_rsa.pub
```

If you do not have a key, you can generate a new modern key using the ed25519 method like this. Make sure that you enter a passphrase for your key.
```bash
ssh-keygen -t ed25519
```

Then you need to take the generated public key and put it in the `group_vars/all/vars` file.
```bash
cat ~/.ssh/id_ed25519.pub
```

### Generate new user password
Your linux user that will be created on our servers also needs a password. This will be used for "sudo" operations. You can generate one that is directly encrypted like this. 
```bash
ansible-vault encrypt_string $(mkpasswd --method=sha-512) --name sudo_password
```
https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module

### Create a Github personal access token
We are using Github actions to build our docker images. These images are then stored in Github Packages. For the server to access packages we need to authenticate. This is done via a "Personal Access Token".

Go to this link and generate a new token: https://github.com/settings/tokens/new

Give it a name so you know what it is used for, and select the scope "read:packages".

Then run this token through the Ansible Vault crypto like this:
```bash
ansible-vault encrypt_string "token_here" --name github_personal_access_token
```

### Create your user
Add the SSH public key and the encrypted password that you've created to the `group_vars/all/vars` file. A full entry looks something like this.

```yaml
queer_users:
  - name: myuser
    ssh_public_keys:
    - "ssh-ed25519 AAAAC3Nz...LMVyT"
    sudo_password: !vault |
        $ANSIBLE_VAULT;1.1;AES256
        3135643764653863623662633133396131313665303036360a386264623139336238386337336462
    github_personal_access_token: !vault |
        $ANSIBLE_VAULT;1.1;AES256
        6639306334336538353133626663643538643266616132630a323632623036343132356630313530
```
