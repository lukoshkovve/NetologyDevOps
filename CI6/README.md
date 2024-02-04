# Домашнее задание к занятию "GitLab"

**ИТОГ**.	
> файл gitlab-ci.yml (DID не стал использовать, потому как в реальных проектах это мало где используется. Связанно это с безопасностью т.к.  при таком методе необходимо включать privileged = true. Подход с kaniko решает данную проблему и на мой взгляд работает стабильнее)
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/CI6/foto/3.JPG)

> Dockerfile

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/CI6/foto/4.JPG)


> Лог pipeline
```Running with gitlab-runner 16.8.0 (c72a09b6)
  on my-runner BEL1jgPv, system ID: s_f7a7f29eb06a
Preparing the "docker" executor
00:02
Using Docker executor with image gcr.io/kaniko-project/executor:v1.12.1-debug ...
Pulling docker image gcr.io/kaniko-project/executor:v1.12.1-debug ...
Using docker image sha256:68aaceaa620b8a0bed42ce812f4994747b8ad69365806aa8883008f574e8054a for gcr.io/kaniko-project/executor:v1.12.1-debug with digest gcr.io/kaniko-project/executor@sha256:a7ea9f69d77d7e7a0ea821f15069be45420a536f81ab5787a988659e48c25377 ...
Preparing environment
00:01
Running on runner-bel1jgpv-project-1-concurrent-0 via epd4trca5rmmcnr30fvn...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Reinitialized existing Git repository in /builds/nolar/netology/.git/
Checking out 9bf7c8bd as detached HEAD (ref is main)...
Skipping Git submodules setup
Executing "step_script" stage of the job script
01:03
Using docker image sha256:68aaceaa620b8a0bed42ce812f4994747b8ad69365806aa8883008f574e8054a for gcr.io/kaniko-project/executor:v1.12.1-debug with digest gcr.io/kaniko-project/executor@sha256:a7ea9f69d77d7e7a0ea821f15069be45420a536f81ab5787a988659e48c25377 ...
$ echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
$ /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $CI_REGISTRY/nolar/netology/$IMAGE_NAME:gitlab-$CI_COMMIT_SHORT_SHA
INFO[0000] Retrieving image manifest centos:7           
INFO[0000] Retrieving image centos:7 from registry index.docker.io 
INFO[0001] Built cross stage deps: map[]                
INFO[0001] Retrieving image manifest centos:7           
INFO[0001] Returning cached image manifest              
INFO[0001] Executing 0 build triggers                   
INFO[0001] Building stage 'centos:7' [idx: '0', base-idx: '-1'] 
INFO[0001] Unpacking rootfs as cmd RUN yum install python3 python-pip -y requires it. 
INFO[0005] RUN yum install python3 python-pip -y        
INFO[0005] Initializing snapshotter ...                 
INFO[0005] Taking snapshot of full filesystem...        
INFO[0011] Cmd: /bin/sh                                 
INFO[0011] Args: [-c yum install python3 python-pip -y] 
INFO[0011] Running: [/bin/sh -c yum install python3 python-pip -y] 
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.sale-dedic.com
 * extras: mirror.sale-dedic.com
 * updates: mirror.yandex.ru
No package python-pip available.
Resolving Dependencies
--> Running transaction check
---> Package python3.x86_64 0:3.6.8-21.el7_9 will be installed
--> Processing Dependency: python3-libs(x86-64) = 3.6.8-21.el7_9 for package: python3-3.6.8-21.el7_9.x86_64
--> Processing Dependency: python3-setuptools for package: python3-3.6.8-21.el7_9.x86_64
--> Processing Dependency: python3-pip for package: python3-3.6.8-21.el7_9.x86_64
--> Processing Dependency: libpython3.6m.so.1.0()(64bit) for package: python3-3.6.8-21.el7_9.x86_64
--> Running transaction check
---> Package python3-libs.x86_64 0:3.6.8-21.el7_9 will be installed
--> Processing Dependency: libtirpc.so.1()(64bit) for package: python3-libs-3.6.8-21.el7_9.x86_64
---> Package python3-pip.noarch 0:9.0.3-8.el7 will be installed
---> Package python3-setuptools.noarch 0:39.2.0-10.el7 will be installed
--> Running transaction check
---> Package libtirpc.x86_64 0:0.2.4-0.16.el7 will be installed
--> Finished Dependency Resolution
Dependencies Resolved
================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Installing:
 python3                  x86_64       3.6.8-21.el7_9       updates        71 k
Installing for dependencies:
 libtirpc                 x86_64       0.2.4-0.16.el7       base           89 k
 python3-libs             x86_64       3.6.8-21.el7_9       updates       7.0 M
 python3-pip              noarch       9.0.3-8.el7          base          1.6 M
 python3-setuptools       noarch       39.2.0-10.el7        base          629 k
Transaction Summary
================================================================================
Install  1 Package (+4 Dependent packages)
Total download size: 9.3 M
Installed size: 48 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/libtirpc-0.2.4-0.16.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for libtirpc-0.2.4-0.16.el7.x86_64.rpm is not installed
Public key for python3-3.6.8-21.el7_9.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               42 MB/s | 9.3 MB  00:00     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-9.2009.0.el7.centos.x86_64 (@CentOS)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : libtirpc-0.2.4-0.16.el7.x86_64                               1/5 
  Installing : python3-setuptools-39.2.0-10.el7.noarch                      2/5 
  Installing : python3-pip-9.0.3-8.el7.noarch                               3/5 
  Installing : python3-3.6.8-21.el7_9.x86_64                                4/5 
  Installing : python3-libs-3.6.8-21.el7_9.x86_64                           5/5 
  Verifying  : libtirpc-0.2.4-0.16.el7.x86_64                               1/5 
  Verifying  : python3-libs-3.6.8-21.el7_9.x86_64                           2/5 
  Verifying  : python3-3.6.8-21.el7_9.x86_64                                3/5 
  Verifying  : python3-setuptools-39.2.0-10.el7.noarch                      4/5 
  Verifying  : python3-pip-9.0.3-8.el7.noarch                               5/5 
Installed:
  python3.x86_64 0:3.6.8-21.el7_9                                               
Dependency Installed:
  libtirpc.x86_64 0:0.2.4-0.16.el7   python3-libs.x86_64 0:3.6.8-21.el7_9       
  python3-pip.noarch 0:9.0.3-8.el7   python3-setuptools.noarch 0:39.2.0-10.el7  
Complete!
INFO[0022] Taking snapshot of full filesystem...        
INFO[0037] COPY requirments.txt requirments.txt         
INFO[0037] Taking snapshot of files...                  
INFO[0037] RUN pip3 install -r requirments.txt          
INFO[0037] Cmd: /bin/sh                                 
INFO[0037] Args: [-c pip3 install -r requirments.txt]   
INFO[0037] Running: [/bin/sh -c pip3 install -r requirments.txt] 
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting flask (from -r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/cd/77/59df23681f4fd19b7cbbb5e92484d46ad587554f5d490f33ef907e456132/Flask-2.0.3-py3-none-any.whl (95kB)
Collecting flask_restful (from -r requirments.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/d7/7b/f0b45f0df7d2978e5ae51804bb5939b7897b2ace24306009da0cc34d8d1f/Flask_RESTful-0.3.10-py2.py3-none-any.whl
Collecting flask_jsonpify (from -r requirments.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/60/0f/c389dea3988bffbe32c1a667989914b1cc0bce31b338c8da844d5e42b503/Flask-Jsonpify-1.5.0.tar.gz
Collecting itsdangerous>=2.0 (from flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/9c/96/26f935afba9cd6140216da5add223a0c465b99d0f112b68a4ca426441019/itsdangerous-2.0.1-py3-none-any.whl
Collecting Werkzeug>=2.0 (from flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/f4/f3/22afbdb20cc4654b10c98043414a14057cd27fdba9d4ae61cea596000ba2/Werkzeug-2.0.3-py3-none-any.whl (289kB)
Collecting Jinja2>=3.0 (from flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/20/9a/e5d9ec41927401e41aea8af6d16e78b5e612bca4699d417f646a9610a076/Jinja2-3.0.3-py3-none-any.whl (133kB)
Collecting click>=7.1.2 (from flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/4a/a8/0b2ced25639fb20cc1c9784de90a8c25f9504a7f18cd8b5397bd61696d7d/click-8.0.4-py3-none-any.whl (97kB)
Collecting pytz (from flask_restful->-r requirments.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/9c/3d/a121f284241f08268b21359bd425f7d4825cffc5ac5cd0e1b3d82ffd2b10/pytz-2024.1-py2.py3-none-any.whl (505kB)
Collecting six>=1.3.0 (from flask_restful->-r requirments.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/d9/5a/e7c31adbe875f2abbb91bd84cf2dc52d792b5a01506781dbcf25c91daf11/six-1.16.0-py2.py3-none-any.whl
Collecting aniso8601>=0.82 (from flask_restful->-r requirments.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/e3/04/e97c12dc034791d7b504860acfcdd2963fa21ae61eaca1c9d31245f812c3/aniso8601-9.0.1-py2.py3-none-any.whl (52kB)
Collecting dataclasses; python_version < "3.7" (from Werkzeug>=2.0->flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/fe/ca/75fac5856ab5cfa51bbbcefa250182e50441074fdc3f803f6e76451fab43/dataclasses-0.8-py3-none-any.whl
Collecting MarkupSafe>=2.0 (from Jinja2>=3.0->flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/fc/d6/57f9a97e56447a1e340f8574836d3b636e2c14de304943836bd645fa9c7e/MarkupSafe-2.0.1-cp36-cp36m-manylinux1_x86_64.whl
Collecting importlib-metadata; python_version < "3.8" (from click>=7.1.2->flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/a0/a1/b153a0a4caf7a7e3f15c2cd56c7702e2cf3d89b1b359d1f1c5e59d68f4ce/importlib_metadata-4.8.3-py3-none-any.whl
Collecting zipp>=0.5 (from importlib-metadata; python_version < "3.8"->click>=7.1.2->flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/bd/df/d4a4974a3e3957fd1c1fa3082366d7fff6e428ddb55f074bf64876f8e8ad/zipp-3.6.0-py3-none-any.whl
Collecting typing-extensions>=3.6.4; python_version < "3.8" (from importlib-metadata; python_version < "3.8"->click>=7.1.2->flask->-r requirments.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/45/6b/44f7f8f1e110027cf88956b59f2fad776cca7e1704396d043f89effd3a0e/typing_extensions-4.1.1-py3-none-any.whl
Installing collected packages: itsdangerous, dataclasses, Werkzeug, MarkupSafe, Jinja2, zipp, typing-extensions, importlib-metadata, click, flask, pytz, six, aniso8601, flask-restful, flask-jsonpify
  Running setup.py install for flask-jsonpify: started
    Running setup.py install for flask-jsonpify: finished with status 'done'
Successfully installed Jinja2-3.0.3 MarkupSafe-2.0.1 Werkzeug-2.0.3 aniso8601-9.0.1 click-8.0.4 dataclasses-0.8 flask-2.0.3 flask-jsonpify-1.5.0 flask-restful-0.3.10 importlib-metadata-4.8.3 itsdangerous-2.0.1 pytz-2024.1 six-1.16.0 typing-extensions-4.1.1 zipp-3.6.0
INFO[0045] Taking snapshot of full filesystem...        
INFO[0054] COPY /python_api/app.py app.py               
INFO[0054] Taking snapshot of files...                  
INFO[0054] CMD ["python3", "app.py"]                    
INFO[0054] Pushing image to netology-nolar.gitlab.yandexcloud.net:5050/nolar/netology/hello:gitlab-9bf7c8bd 
INFO[0062] Pushed netology-nolar.gitlab.yandexcloud.net:5050/nolar/netology/hello@sha256:3da3d0ee0d423c958e23908fe6265382b81ca010a731675f514ddc69e463575e 
Cleaning up project directory and file based variables
00:00
Job succeeded
```


> В результате у нас в репо создался образ с необходимым названием
![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/CI6/foto/6.JPG)


> решённый Issue

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/CI6/foto/5.JPG)

> проверка контейнера на внесенные изменения

![](https://github.com/lukoshkovve/NetologyDevOps/blob/main/CI6/foto/6.JPG)