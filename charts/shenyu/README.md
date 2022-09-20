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

### 部署先决条件

在阅读本文档前，你需要先阅读[部署先决条件](https://shenyu.apache.org/zh/docs/deployment/deployment-before)来完成部署 ShenYu 前的环境准备工作。

### 说明

* **安装应用**：默认同时安装 admin 与 bootstrap。
* **服务暴露**：使用 NodePort 暴露服务，admin 默认端口为 31095, bootstrap 为 31195。
* **数据库**：目前支持 h2, MySQL, PostgreSQL 作为数据库。默认使用 h2。

### h2 作为数据库

运行以下命令，会在 shenyu namespace 下安装 admin 与 bootstrap ，并创建命名空间。

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace
```

### MySQL 作为数据库

修改以下命令并复制，执行：

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set dataSource.active=mysql \
      --set dataSource.mysql.ip=127.0.0.1 \
      --set dataSource.mysql.port=3306 \
      --set dataSource.mysql.username=root \
      --set dataSource.mysql.password=123456 
```

## PostgreSQL 作为数据库

修改以下命令并复制，执行：

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set dataSource.active=pg \
      --set dataSource.pg.ip=127.0.0.1 \
      --set dataSource.pg.port=5432 \
      --set dataSource.pg.username=postgres \
      --set dataSource.pg.password=123456
```

## Q&A

### 1. 需要大量修改配置信息，如修改 application.yaml ，如何安装

1. 下载完整 values.yaml
* 最新 chart 版本：`helm show values shenyu/shenyu > values.yaml`
* 特定 chart 版本, 如 `0.2.0`: `helm show values shenyu/shenyu --version=0.2.0 > values.yaml`
2. 修改 values.yaml 文件
3. 更改相应配置，使用 `-f values.yaml` 的格式执行 `helm install` 命令。
如：`helm install shenyu shenyu/shenyu -n=shenyu --create-namespace -f values.yaml`

### 2. 如何只安装 admin 或 bootstrap

* 只安装 admin:     在 helm 安装命令末尾加上 `--set bootstrap.enabled=false`
* 只安装 bootstrap: 在 helm 安装命令末尾加上 `--set admin.enabled=false`

### 3. 如何安装旧版本 ShenYu

```shell
helm search repo shenyu -l
```

你会得到类似的输出：

```shell
NAME            CHART VERSION	APP VERSION	  DESCRIPTION
shenyu/shenyu   0.2.0           2.5.0         Helm Chart for deploying Apache ShenYu in Kubernetes
...
...
```

其中 `APP_VERSION` 是 ShenYu 的版本，`CHART_VERSION` 是 Helm Chart 的版本。

根据要安装的 ShenYu 版本来选择对应的 Chart 版本，在命令末尾加上 `--version=CHART_VERSION` 参数即可。例如：

```shell
helm install shenyu shenyu/shenyu -n=shenyu --version=0.2.0 --create-namespace
```

## Values 配置说明

### 全局配置
| 配置项              | 类型    | 默认值                       | 描述                                   |
|--------------------|--------|-----------------------------|---------------------------------------|
| replicas           | int    | `1`                         | 副本数量                               |
| version            | string | `"2.5.0"`                   | shenyu 版本，不建议修改，请直接安装对应版本 |
| admin.enabled      | bool   | `true`                      | 是否安装 shenyu-admin                  |
| admin.image        | string | `"apache/shenyu-admin"`     | shenyu-admin 镜像                      |
| admin.nodePort     | int    | `31095`                     | shenyu-admin NodePort 端口             |
| bootstrap.enabled  | bool   | `true`                      | 是否安装 shenyu-bootstrap              |
| bootstrap.image    | string | `"apache/shenyu-bootstrap"` | shenyu-bootstrap 镜像                  |
| bootstrap.nodePort | int    | `31195`                     | shenyu-bootstrap NodePort 端口         |

### 数据库配置

#### 数据库总配置
| 配置项                  | 类型    | 默认值  | 描述                           |
|------------------------|--------|--------|-------------------------------|
| dataSource.active      | string | `"h2"` | 使用的数据库，支持 `h2`, `mysql` |
| dataSource.initEnabled | bool   | `true` | 初始化数据库，仅 `h2` 有效       |

#### h2
| 配置项                  | 类型    | 默认值  | 描述   |
|------------------------|--------|--------|-------|
| dataSource.h2.username | string | `"sa"` | 用户名 |
| dataSource.h2.password | string | `"sa"` | 密码   |

#### MySQL
| 配置项                             | 类型    | 默认值                          | 描述                                                                                               |
|-----------------------------------|--------|------------------------------|---------------------------------------------------------------------------------------------------|
| dataSource.mysql.ip               | string | `""`                         | IP                                                                                                |
| dataSource.mysql.port             | int    | `3306`                       | 端口                                                                                               |
| dataSource.mysql.username         | string | `"root"`                     | 用户名                                                                                             |
| dataSource.mysql.password         | string | `""`                         | 密码                                                                                               |
| dataSource.mysql.connectorVersion | string | `"8.0.23"`                   | connector 版本([maven connector 列表](https://repo1.maven.org/maven2/mysql/mysql-connector-java/)) |
| dataSource.mysql.driverClass      | string | `"com.mysql.cj.jdbc.Driver"` | mysql driver class 名字                                                                            |

### application.yml 配置
| 配置项                       | 类型    | 默认值 | 描述                                                                                                                      |
|-----------------------------|--------|-------|--------------------------------------------------------------------------------------------------------------------------|
| applicationConfig.bootstrap | string | 略    | bootstrap 配置，[bootstrap 配置说明](https://shenyu.apache.org/zh/docs/user-guide/property-config/gateway-property-config) |
| applicationConfig.admin     | string | 略    | admin 配置，[admin 配置说明](https://shenyu.apache.org/zh/docs/user-guide/property-config/admin-property-config)           |
