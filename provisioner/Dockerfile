FROM python:3.9.4-slim-buster

RUN apt update && \
    apt install -y \
        git \
        ssh \
        jq
RUN python -m pip install --upgrade pip && \
    pip install ansible

COPY ./entrypoint.sh /workspace/entrypoint.sh
COPY ./parser.py /workspace/parser.py
COPY ./playbook.yml /workspace/playbook.yml

WORKDIR /workspace
ENTRYPOINT [ "./entrypoint.sh", "-i", "./identity.pem" ]
