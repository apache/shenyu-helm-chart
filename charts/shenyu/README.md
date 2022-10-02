# shenyu-helm-chart

Helm deployment documentation written for Apache/Shenyu.

[English]  [[简体中文]](#使用Helm安装ShenYu)

[Apache/ShenYu](https://shenyu.apache.org/docs/index/) is an asynchronous, high-performance, cross-language, responsive API gateway.

## Add Helm repository

```shell
helm repo add shenyu https://apache.github.io/shenyu-helm-chart
helm repo update
```

## Install

### Deployment prerequisites

Before reading this document, you need to read [Deployment prerequisites](https://shenyu.apache.org/docs/deployment/deployment-before/) to complete the environment preparation before deploying ShenYu.

### Instructions

* **Install the application**: By default, both admin and bootstrap are installed.
* **Service Exposure**: Use NodePort to expose the service, the default port is `31095` for admin and `31195` for bootstrap.
* **Database**: Currently supports h2, MySQL, PostgreSQL as database. Default is h2.

### h2 as database

Running the following command will install admin and bootstrap under shenyu namespace and create namespace.

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace
```

### MySQL as database

Modify and copy the following command and execute.

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set dataSource.active=mysql \
      --set dataSource.mysql.ip=127.0.0.1 \
      --set dataSource.mysql.port=3306 \
      --set dataSource.mysql.username=root \
      --set dataSource.mysql.password=123456 
```

## PostgreSQL as database(Version of ShenYu > 2.5.0)

Modify the following command and copy it to execute.

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set dataSource.active=pg \
      --set dataSource.pg.ip=127.0.0.1 \
      --set dataSource.pg.port=5432 \
      --set dataSource.pg.username=postgres \
      --set dataSource.pg.password=123456
```

## Q & A

### 1. you need to modify a lot of configuration information, such as modify the application.yaml, how to install

1. download the complete values.yaml
* Latest chart version: `helm show values shenyu/shenyu > values.yaml`
* Specific chart version, e.g. `0.2.0`: `helm show values shenyu/shenyu --version=0.2.0 > values.yaml`
2. modify the values.yaml file
3. Change the corresponding configuration and execute the `helm install` command with the format `-f values.yaml`.
   For example: `helm install shenyu shenyu/shenyu -n=shenyu --create-namespace -f values.yaml`

### 2. How to install only admin or bootstrap

* Install only admin: add `-set bootstrap.enabled=false` to the end of the helm install command
* Install only bootstrap: add `--set admin.enabled=false` to the end of the helm install command

### 3. How to install old version ShenYu

```shell
helm search repo shenyu -l
```

You will get output similar to

```shell
NAME CHART VERSION APP VERSION DESCRIPTION
shenyu/shenyu 0.2.0 2.5.0 Helm Chart for deploying Apache ShenYu in Kubernetes
...
...
```

where `APP_VERSION` is the version of ShenYu and `CHART_VERSION` is the version of Helm Chart.

Select the corresponding Chart version according to the version of ShenYu you want to install, and add the `-version=CHART_VERSION` parameter at the end of the command. For example

```shell
helm install shenyu shenyu/shenyu -n=shenyu --version=0.2.0 --create-namespace
```

### How to configure JVM options and modify Kubernetes resource quotas(Version of ShenYu > 2.5.0)

* Configure JVM parameters via `admin.jvmOpts` and `bootstrap.jvmOpts`
* Configure Kubernetes resource quotas via `admin.resources` and `bootstrap.resources`.

e.g.

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set admin.javaOpts="-Xms256m -Xmx512m" \
      --set admin.resources.requests.memory=512Mi \
      --set admin.resources.limits.memory=1Gi \
      --set admin.resources.requests.cpu=500m \
      --set admin.resources.limits.cpu=1 \
```

## Values configuration instructions

### Global Configuration
| configuration item | type   | default   | description                                                                                        |
|--------------------|--------|-----------|----------------------------------------------------------------------------------------------------|
| replicas           | int    | `1`       | Number of replicas                                                                                 |
| version            | string | `"2.5.0"` | shenyu version, it is not recommended to modify, please install the corresponding version directly |

### shenyu-admin configuration
| configuration item | type     | default                                                                                                       | description                |
|--------------------|----------|---------------------------------------------------------------------------------------------------------------|----------------------------|
| admin.nodePort     | int      | `31095`                                                                                                       | NodePort port              |
| admin.javaOpts     | string   | [see here](https://github.com/apache/shenyu/blob/master/shenyu-dist/shenyu-admin-dist/docker/entrypoint.sh)   | JVM parameters             |
| admin.resources    | dict     | omit                                                                                                          | K8s resource quota         |

### shenyu-bootstrap configuration
| configuration item    | type     | default                                                                                                           | description                    |
|-----------------------|----------|-------------------------------------------------------------------------------------------------------------------|--------------------------------|
| bootstrap.nodePort    | int      | `31195`                                                                                                           | NodePort Port                  |
| bootstrap.javaOpts    | string   | [see here](https://github.com/apache/shenyu/blob/master/shenyu-dist/shenyu-bootstrap-dist/docker/entrypoint.sh)   | JVM parameters                 |
| bootstrap.resources   | dict     | `{}`                                                                                                              | K8s resource quota             |

Translated with www.DeepL.com/Translator (free version)                                                                     |

### Database configuration

#### General database configuration
| configuration-item     | type   | default | description                                     |
|------------------------|--------|---------|-------------------------------------------------|
| dataSource.active      | string | `"h2"`  | Database to use, supports `h2`, `mysql`         |
| dataSource.initEnabled | bool   | `true`  | Initialize the database, only `h2` is available |

#### h2
| configuration item     | type   | default | description |
|------------------------|--------|---------|-------------|
| dataSource.h2.username | string | `"sa"`  | username    |
| dataSource.h2.password | string | `"sa"`  | password    |

#### MySQL
| Configuration Item                | Type   | Default                      | Description                                                                                            |
|-----------------------------------|--------|------------------------------|--------------------------------------------------------------------------------------------------------|
| dataSource.mysql.ip               | string | `""`                         | IP                                                                                                     |
| dataSource.mysql.port             | int    | `3306`                       | port                                                                                                   |
| dataSource.mysql.username         | string | `"root"`                     | Username                                                                                               |
| dataSource.mysql.password         | string | `""`                         | Password                                                                                               |
| dataSource.mysql.driverClass      | string | `"com.mysql.cj.jdbc.Driver"` | mysql driver class name                                                                                |
| dataSource.mysql.connectorVersion | string | `"8.0.23"`                   | connector version([maven connector list](https://repo1.maven.org/maven2/mysql/mysql- connector-java/)) |

### PostgreSQL
| configuration-item                     | type   | default                   | description                                                                                            |
|----------------------------------------|--------|---------------------------|--------------------------------------------------------------------------------------------------------|
| dataSource.postgresql.ip               | string | `""`                      | IP                                                                                                     |
| dataSource.postgresql.port             | int    | `5432`                    | port                                                                                                   |
| dataSource.postgresql.username         | string | `"postgres"`              | username                                                                                               |
| dataSource.postgresql.password         | string | `"postgres"`              | password                                                                                               |
| dataSource.postgresql.driverClass      | string | `"org.postgresql.Driver"` | postgresql driver class name                                                                           |
| dataSource.postgresql.connectorVersion | string | `"42.2.18"`               | connector version ([maven connector list](https://repo1.maven.org/maven2/org/ postgresql/postgresql/)) |

### application.yml configuration
| configuration-item          | type   | default  | description                                                                                                                                           |
|-----------------------------|--------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| applicationConfig.bootstrap | string | slightly | bootstrap configuration, [bootstrap configuration description](https://shenyu.apache.org/zh/docs/user-guide/property-config/ gateway-property-config) |
| applicationConfig.admin     | string | omit     | admin configuration, [admin configuration description](https://shenyu.apache.org/zh/docs/user-guide/property-config/admin-property- config)           |

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
* **服务暴露**：使用 NodePort 暴露服务，admin 默认端口为 `31095`, bootstrap 为 `31195`。
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

## PostgreSQL 作为数据库(ShenYu 版本 > 2.5.0)

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

### 如何配置 JVM 参数以及修改 Kubernetes 资源配额(ShenYu 版本 > 2.5.0)

* 通过 `admin.javaOpts` 和 `bootstrap.javaOpts` 来配置 JVM 参数
* 通过 `admin.resources` 和 `bootstrap.resources` 来配置 Kubernetes 资源配额。

例：

```shell
helm install shenyu shenyu/shenyu -n=shenyu --create-namespace \
      --set admin.javaOpts="-Xms256m -Xmx512m" \
      --set admin.resources.requests.memory=512Mi \
      --set admin.resources.limits.memory=1Gi \
      --set admin.resources.requests.cpu=500m \
      --set admin.resources.limits.cpu=1 \
```

## Values 配置说明

### 全局配置
| 配置项    | 类型    | 默认值     | 描述                                   |
|----------|--------|-----------|---------------------------------------|
| replicas | int    | `1`       | 副本数量                               |
| version  | string | `"2.5.0"` | shenyu 版本，不建议修改，请直接安装对应版本 |

### shenyu-admin 配置
| 配置项             | 类型      | 默认值                                                                                                         | 描述             |
|-------------------|----------|---------------------------------------------------------------------------------------------------------------|-----------------|
| admin.nodePort    | int      | `31095`                                                                                                       | NodePort 端口    |
| admin.javaOpts    | string   | [详见这里](https://github.com/apache/shenyu/blob/master/shenyu-dist/shenyu-admin-dist/docker/entrypoint.sh)    | JVM 参数         |
| admin.resources   | dict     | 略                                                                                                            | K8s 资源配额     |

### shenyu-bootstrap 配置
| 配置项                 | 类型      | 默认值                                                                                                             | 描述                 |
|-----------------------|----------|-------------------------------------------------------------------------------------------------------------------|---------------------|
| bootstrap.nodePort    | int      | `31195`                                                                                                           | NodePort 端口        |
| bootstrap.javaOpts    | string   | [详见这里](https://github.com/apache/shenyu/blob/master/shenyu-dist/shenyu-bootstrap-dist/docker/entrypoint.sh)    | JVM 参数             |
| bootstrap.resources   | dict     | `{}`                                                                                                              | K8s 资源配额         |

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
| 配置项                             | 类型    | 默认值                        | 描述                                                                                               |
|-----------------------------------|--------|------------------------------|---------------------------------------------------------------------------------------------------|
| dataSource.mysql.ip               | string | `""`                         | IP                                                                                                |
| dataSource.mysql.port             | int    | `3306`                       | 端口                                                                                               |
| dataSource.mysql.username         | string | `"root"`                     | 用户名                                                                                             |
| dataSource.mysql.password         | string | `""`                         | 密码                                                                                               |
| dataSource.mysql.driverClass      | string | `"com.mysql.cj.jdbc.Driver"` | mysql driver class 名字                                                                            |
| dataSource.mysql.connectorVersion | string | `"8.0.23"`                   | connector 版本([maven connector 列表](https://repo1.maven.org/maven2/mysql/mysql-connector-java/)) |

### PostgreSQL
| 配置项                                  | 类型    | 默认值                     | 描述                                                                                              |
|----------------------------------------|--------|---------------------------|--------------------------------------------------------------------------------------------------|
| dataSource.postgresql.ip               | string | `""`                      | IP                                                                                               |
| dataSource.postgresql.port             | int    | `5432`                    | 端口                                                                                              |
| dataSource.postgresql.username         | string | `"postgres"`              | 用户名                                                                                            |
| dataSource.postgresql.password         | string | `""`                      | 密码                                                                                              |
| dataSource.postgresql.driverClass      | string | `"org.postgresql.Driver"` | postgresql driver class 名字                                                                      |
| dataSource.postgresql.connectorVersion | string | `"42.2.18"`               | connector 版本([maven connector 列表](https://repo1.maven.org/maven2/org/postgresql/postgresql/)) |

### application.yml 配置
| 配置项                       | 类型    | 默认值 | 描述                                                                                                                      |
|-----------------------------|--------|-------|--------------------------------------------------------------------------------------------------------------------------|
| applicationConfig.bootstrap | string | 略    | bootstrap 配置，[bootstrap 配置说明](https://shenyu.apache.org/zh/docs/user-guide/property-config/gateway-property-config) |
| applicationConfig.admin     | string | 略    | admin 配置，[admin 配置说明](https://shenyu.apache.org/zh/docs/user-guide/property-config/admin-property-config)           |
