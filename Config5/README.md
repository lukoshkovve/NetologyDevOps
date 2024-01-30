# Домашнее задание к занятию "Тестирование roles"

**1-2**.	
> Запустил molecule init scenario -r vector --driver-name docker (данная команда применяется, когда у нас уже есть роли которые надо проверить, если бы с нуля создавали "scenario" надо было исключить из команды)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config5/foto/1.JPG)

**3**.
> В файл molecule.yml добавил два дистрибутива
```
platforms:
  - name: netology:latest
    image: aragast/netology:latest
    pre_build_image: true
  - name: ubuntu:latest
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
```
**4**.
> Добавил assert на проверку переменных на STRING и соответствие пути конфига

```- name: Verify
  hosts: all
  gather_facts: false
  vars_files:
    - "/home/nolar/ansible-venv/roles/vars/main.yml"
  tasks:
  - name: Example assertion
    assert:
      that: true
  - name: Check config dir
    assert:
      that:
       - vector_config_dir is string
       - vector_config_dir == "/etc/vector"

```

**4**.
> molecule test:
```
(ansible-venv) nolar@vector:~/ansible-venv/roles$ sudo molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
COMMAND: ansible-lint . yamllint .

Passed: 0 failure(s), 0 warning(s) on 7 files. Last profile that met the validation criteria was 'production'.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
[WARNING]: The "community.docker.docker" connection plugin has an improperly
configured remote target value, forcing "inventory_hostname" templated value
instead of the string
ok: [netology:latest]
ok: [ubuntu:latest]

TASK [Dump instance config] ****************************************************
skipping: [netology:latest]
skipping: [ubuntu:latest]

PLAY RECAP *********************************************************************
netology:latest            : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu:latest              : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/nolar/ansible-venv/roles/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [netology:latest]
skipping: [ubuntu:latest]

TASK [Convert instance config dict to a list] **********************************
skipping: [netology:latest]
skipping: [ubuntu:latest]

TASK [Dump instance config] ****************************************************
skipping: [netology:latest]
skipping: [ubuntu:latest]

PLAY RECAP *********************************************************************
netology:latest            : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
ubuntu:latest              : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************

PLAY RECAP *********************************************************************

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Include vector] **********************************************************

PLAY RECAP *********************************************************************

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
[WARNING]: The "community.docker.docker" connection plugin has an improperly
configured remote target value, forcing "inventory_hostname" templated value
instead of the string
ok: [netology:latest] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu:latest] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Check config dir] ********************************************************
ok: [netology:latest] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu:latest] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
netology:latest            : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu:latest              : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
[WARNING]: The "community.docker.docker" connection plugin has an improperly
configured remote target value, forcing "inventory_hostname" templated value
instead of the string
ok: [netology:latest]
ok: [ubuntu:latest]

TASK [Dump instance config] ****************************************************
skipping: [netology:latest]
skipping: [ubuntu:latest]

PLAY RECAP *********************************************************************
netology:latest            : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu:latest              : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
***TOX***

**1**.
> Необходимые файлы для работы tox добавлены

**2**.
> Запущен контейнер 
```
sudo docker run --privileged=True -v /home/nolar/ansible-venv/roles:/opt/vector -w /opt/vector -it aragast/netology:latest /bin/bash
```
**3-4**.
> создал облегченный сценарий molecuke.yml:
```
dependency:
  name: galaxy
driver:
  name: podman
platforms:
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
role_name_check: 1
scenario:
  test_sequence:
    - destroy
    - create
    - verify
    - destroy
``` 
**5**.
> tox.ini:
```
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s tox --destroy always}
```
**6**.
> Код tox отработал успешно:
```
[root@f98e55738452 vector]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.1,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.2,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='781929628'
py37-ansible210 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: destroy, create, verify, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/8e33c6/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/8e33c6/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/8e33c6/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/glennbell.linux_administration symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [centos7]

TASK [Convert instance config dict to a list] **********************************
skipping: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running tox > verify
INFO     Running Ansible Verifier
WARNING  Skipping, verify playbook not configured.
INFO     Verifier completed successfully.
INFO     Running tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,arrow==1.2.3,bcrypt==4.1.2,binaryornot==0.4.4,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.11.17,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.2,click==8.1.7,click-help-colors==0.9.4,cookiecutter==2.5.0,cryptography==42.0.1,distro==1.9.0,enrich==1.2.7,idna==3.6,importlib-metadata==6.7.0,Jinja2==3.1.3,jmespath==1.0.1,lxml==5.1.0,markdown-it-py==2.2.0,MarkupSafe==2.1.4,mdurl==0.1.2,molecule==3.6.1,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pluggy==1.2.0,pycparser==2.21,Pygments==2.17.2,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.2,PyYAML==6.0.1,requests==2.31.0,rich==13.7.0,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='781929628'
py37-ansible30 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: destroy, create, verify, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/8e33c6/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/8e33c6/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/8e33c6/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.ansible/roles/glennbell.linux_administration symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [centos7]

TASK [Convert instance config dict to a list] **********************************
skipping: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running tox > verify
INFO     Running Ansible Verifier
WARNING  Skipping, verify playbook not configured.
INFO     Verifier completed successfully.
INFO     Running tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [centos7]

TASK [Dump instance config] ****************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
__________________________________________________________________________________________________________________ summary __________________________________________________________________________________________________________________
  py37-ansible210: commands succeeded
  py37-ansible30: commands succeeded
  congratulations :)
```