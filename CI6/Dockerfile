FROM centos:7
RUN yum install python3 python-pip -y
COPY requirments.txt requirments.txt
RUN pip3 install -r requirments.txt
COPY /python_api/app.py app.py
CMD ["python3", "app.py"]