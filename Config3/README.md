# Домашнее задание к занятию "Использование Ansible"

**1-2-3**.	
> Playbook дописан
```
---     #начало

- name: Install Clickhouse   # Имя
  hosts: clickhouse          # Хост или группа хостов на которых выполняется
  handlers: # Список задач после другой задачи
    - name: Start clickhouse service # cписок задач с условием
      become: true # выполнение от имени суперпользователя
      ansible.builtin.service: # модуль
        name: clickhouse-server # имя модуля
        state: restarted # задача обработчику на рестарт сервиса
  tasks: # задачи описывающие состояние
    - block: # объеденение задач
        - name: Get clickhouse distrib
          ansible.builtin.get_url: 
            url: "https://packages.clickhouse.com/deb/pool/main/c/{{ item }}/{{ item }}_{{ clickhouse_version }}_amd64.deb" # url для скачивания пакета
            dest: "./{{ item }}_{{ clickhouse_version }}.amd64.deb" # формируемый файл на целевом хосте из предыдущего пакета
          with_items: "{{ clickhouse_packages }}" # принимает имя списка пакетов на выходе
      rescue: № набор задач которые будут исполняться, если в блоке произойдет ошибка
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_{{ clickhouse_version }}_amd64.deb"
            dest: "./clickhouse-common-static_{{ clickhouse_version }}.amd64.deb"
    - name: Install clickhouse packages # установка пакетов
      apt:
            clickhouse-common-static_{{ clickhouse_version }}.amd64.deb
            clickhouse-client_{{ clickhouse_version }}.amd64.deb
            clickhouse-server_{{ clickhouse_version }}.amd64.deb
      notify: Start clickhouse service # вызывается, если произошли изменения
    - name: Flush handlers
      meta: flush_handlers # метозадача которая выполняется сразу после предшествующей операции
    - name: Create database 
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'" # вызов клиента
      register: create_db # добавление базы
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: vector
  handlers:
    - name: Start Vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: started
  tasks:
    - name: Vector | Download packages
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector_{{ vector_version }}-1_amd64.deb"
        dest: "./vector-{{ vector_version }}-1.amd64.deb"
    - name: Vector | Install packages
      become: true
      apt:
        deb: 
              ./vector-{{ vector_version }}-1.amd64.deb
    - name: Vector | template config
      become: true
      ansible.builtin.template:
        src: "vector.yml.j2" # ресурс из которого будут браться конфиги
        dest: "{{ vector_config_dir }}/vector.yml" # пусть куда будут положены данные на целевой машине
        mode: "0644" # далее 3 строчки с назначением групы и владельца
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"

    - name: Vector | service
      become: true
      ansible.builtin.template:
        src: vector.service.j2
        dest: /lib/systemd/system/vector.service
        mode: "0644"
        owner: "{{ ansible_user_id }}"
        group: "{{ ansible_user_gid }}"
        backup: true
      notify: Start Vector service

- name: install nginx
  hosts: lighthouse
  handlers:
   - name: start-nginx
     become: true
     service: 
       name: nginx
       state: started  
   - name: reload-nginx
     become: true
     service: 
       name: nginx
       state: restarted
  tasks:
   - name: Install nginx and git # Установка пакетов
     become: true
     apt:
       name: "{{ lighthouse_packages }}"
       update_cache: yes
     notify: start-nginx # вызываем обработчика handlers

   - name: set config nginx
     become: true
     template: # добавляем на целевой сервер конфигурацию nginx
       src: templates/nginx.conf.j2
       dest: /etc/nginx/nginx.conf
       mode: "0644"
     notify: reload-nginx
- name: install lighthouse
  hosts: lighthouse
  handlers: 
   - name: reload-nginx
     become: true
     service: 
       name: nginx
       state: restarted
  tasks:
   - name: lighthouse | Copy from git 
     become: true
     git: # берем ветку из гита и кладем себе на целевой сервер
       repo: https://github.com/VKCOM/lighthouse.git
       version: master
       dest: "{{ lighthouse_data }}"

   - name: lighthouse | set config site
     become: true
     template:
       src: templates/default.conf.j2
       dest: /etc/nginx/conf.d/nginx.conf
       mode: "0644"
     notify: reload-nginx
```

**4**.
> Подготовил inventory-файл prod-yml
```
---
clickhouse:
  hosts:
    clickhouse:
      ansible_host: 158.160.63.232
lighthouse:
  hosts:
    lighthouse:
      ansible_host: 84.201.128.70
vector:
  hosts:
    vector:
      ansible_host: 51.250.74.83

```

**5-6**.
> с флагом --check
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config3/foto/6.JPG)

**7**.
> prod.yml c флагом --diff
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config3/foto/7.JPG)


**8**.
> prod.yml c флагом --diff повторно
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config3/foto/8.JPG)

> Результат: на веб интерфейсе видим *lighthouse*

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/Config3/foto/9.JPG)