# shenyu-helm-chart

Helm deployment documentation written for Apache/Shenyu.

[English]  [[简体中文]](#使用Helm安装ShenYu)

[Apache/ShenYu](https://shenyu.apache.org/docs/index/) is an asynchronous, high-performance, cross-language, responsive API gateway.

## Get Repo Info

```shell
helm repo add shenyu https://apache.github.io/shenyu-helm-chart
helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

todo: complete English version

---

## 使用Helm安装ShenYu
[[English]](#shenyu-helm-chart)  [简体中文]

[Apache/ShenYu](https://shenyu.apache.org/zh/docs/index) 是一个异步的，高性能的，跨语言的，响应式的 API 网关。

## 添加 Helm 仓库

```shell
helm repo add shenyu https://apache.github.io/shenyu-helm-chart
helm repo update
```

## 安装
* helm 安装方式目前支持 h2 与 MySQL 两种数据库。默认使用 h2。
* 默认同时安装 admin 与 bootstrap。
* 使用 NodePort 暴露服务，admin 默认端口为 31095, bootstrap 为 31195。

### h2 作为数据库

运行以下命令，会在 shenyu namespace 下安装 admin 与 bootstrap ，并创建命名空间。

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace
```

### MySQL 作为数据库

MySQL 安装方式需要提前安装好 MySQ，并提前创建好 pv 以存放 connector

#### 1. 提前创建 pv

可复制以下 yaml，至少**替换以下两处内容**：

* `YOUR_K8S_NODE_NAME`：存放 MySQL connector 的 K8s 节点名称
* `YOUR_PATH_TO_STORE_MYSQL_CONNECTOR`：# 指定节点上的目录, 该目录下面需要包含 mysql-connector.jar

```shell
apiVersion: v1
kind: PersistentVolume
metadata:
  name: shenyu-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: shenyu-local-storage
  local:
    path: YOUR_PATH_TO_STORE_MYSQL_CONNECTOR
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - YOUR_K8S_NODE_NAME
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: shenyu-local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

修改并保存为 `shenyu-store.yaml`, 然后执行：

```shell
kubectl apply -f shenyu-store.yaml -n=shenyu
```

#### 2. 安装

修改以下命令并复制，执行：

其中，storageClass 和上面的 yaml 创建的 StorageClass 的 name 对应。

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set dataSource.active=mysql \
      --set dataSource.mysql.ip=127.0.0.1 \
      --set dataSource.mysql.port=3306 \
      --set dataSource.mysql.password=123456 \
      --set dataSource.mysql.storageClass=shenyu-local-storage
```

## Q&A

### 1. 如果只安装 admin 或 bootstrap

* 只安装 admin:     在 helm 安装命令末尾加上 `--set bootstrap.enabled=false`
* 只安装 bootstrap: 在 helm 安装命令末尾加上 `--set admin.enabled=false`

### 2. 如何安装旧版本 ShenYu

```shell
helm search repo shenyu -l
```

你会得到类似的输出：

```shell
NAME            CHART VERSION	APP VERSION	  DESCRIPTION
shenyu/shenyu	2.4.3        	2.4.3      	  Helm Chart for deploying Apache ShenYu in Kuber...
...
...
```

其中 APP_VERSION 是 ShenYu 的版本，CHART_VERSION 是 helm chart 的版本。

根据要安装的 ShenYu 版本来选择对应的 Chart 版本，在命令末尾加上 `--version=CHART_VERSION` 参数即可。例如：

```shell
helm install shenyu shenyu/shenyu -n=shenyu --version=2.4.3 --create-namespace
```
