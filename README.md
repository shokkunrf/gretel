# Gretel

## 概要

Minecraft Spigot サーバを運用するためのサービス

## 動作環境(EC2)

- OS: Amazon Linux 2
- Instance Type: t2.medium
- Security Group:
  - TCP: 22
  - TCP: 25565
  - UDP: 25565

## 使い方

### インストール方法

```sh
sudo yum install -y git
git clone https://github.com/shokkunrf/gretel.git
cd ./gretel
bash ./setup.sh install <Minecraft Version>
```

### ゲームサーバ実行方法

- EC2 インスタンス起動時に自動で起動する
- 以下で手動で起動/停止する

```sh
# start
sudo systemctl start spigot
# stop
sudo systemctl stop spigot
```

### ゲームサーバの移行方法

```sh
# import
scp -r ./spigot-server ec2-user@<ipアドレス>:~/opt/spigot
# export
scp -r ec2-user@<ipアドレス>:~/opt/spigot ./spigot-server
```
