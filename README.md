# shenyu-helm-chart

[English] | [中文](#简体中文)

## English

## User Guide

[Apache/ShenYu](https://shenyu.apache.org/docs/index/) is an asynchronous, high-performance, cross-language, responsive API gateway.

Helm installation documentation is available on the official website [Helm Deployment](https://shenyu.apache.org/helm/index/).

### Contributing Guide

Thank you very much for your contribution and look forward to building ShenYu with you!

Please read the [Contributor Guide](https://shenyu.apache.org/community/contributor-guide/) first to understand the basic process of contributing.

#### Environment preparation

* [Kubernetes](https://kubernetes.io/docs/home/)
* [Helm](https://helm.sh/zh/docs/)
* Optional: If you are using the JetBrain family of IDEs, it is recommended to install the [Kubernetes plugin](https://plugins.jetbrains.com/plugin/10485-kubernetes), which supports automatic rendering of values variables, template jumping and other functions.

#### Initialize

```shell
git clone git@github.com:apache/shenyu-helm-chart.git
cd shenyu-helm-chart
helm repo add bitnami https://charts.bitnami.com/bitnami
cd charts/shenyu
helm dependency update
cd -
````

#### Development

See the [Helm documentation](https://helm.sh/docs/).

#### Test

You can use `--dry-run --debug` to simply test the rendering of the template locally without actually installing it into the Kubernetes cluster, for example:

```shell
helm install shenyu-test ./charts/shenyu -n=shenyu --create-namespace --dry-run --debug
````
#### Version

The version number is divided into two, one is the version number of Chart, and the other is the version number of ShenYu.

* Chart version number: defined in the `version` field in `Chart.yaml`.
* ShenYu version number: defined in the `appVersion` field in `Chart.yaml`. This field only serves as an indicator, the real ShenYu version number is defined in the `image.tag` field in `values.yaml`.

The version numbers mentioned below refer to the Chart version numbers.

Version numbers follow **[Semantic Versioning](https://semver.org/)**.

**You must bump version number in each Pull Request**

* If the changes are minor, please update the patch version number, eg: `0.1.0` -> `0.1.1`.
* If the change is relatively large (such as adding a new feature), but it is backward compatible, you can update the minor version number, for example: `0.1.0` -> `0.2.0`.
* If the changes are not backward compatible, you can update the major version number, for example: `0.1.0` -> `1.0.0`.

#### Release

1. Update the `version` field in `charts/shenyu/Chart.yaml`.
2. After the Pull Request is merged, GitHub Actions will be triggered, and the version will be automatically released.

## 简体中文

[English](#English) | [中文]

### 用户指南

[Apache/ShenYu](https://shenyu.apache.org/zh/docs/index) 是一个异步的，高性能的，跨语言的，响应式的 API 网关。

Helm 安装文档详见官网 [Helm 部署](https://shenyu.apache.org/zh/helm/index)。

### 贡献指南

非常感谢你的贡献，期待与你一起共建 ShenYu！

请先阅读 [贡献者指南](https://shenyu.apache.org/zh/community/contributor-guide/) 以了解参与贡献的基本流程。

#### 环境准备

* [Kubernetes](https://kubernetes.io/zh-cn/docs/home/)
* [Helm](https://helm.sh/zh/docs/)
* 可选：如果你使用的是 JetBrain 家族的 IDE，推荐安装 [Kubernetes 插件](https://plugins.jetbrains.com/plugin/10485-kubernetes)，支持 values 变量自动渲染、模板跳转等功能。

#### 初始化

```shell
git clone git@github.com:apache/shenyu-helm-chart.git
cd shenyu-helm-chart
helm repo add bitnami https://charts.bitnami.com/bitnami
cd charts/shenyu
helm dependency update
cd -
```

#### 开发

请参阅 [Helm 文档](https://helm.sh/zh/docs/)。

(注意， Helm 的搜索只支持英文)

#### 测试

可使用 `--dry-run --debug` 在本地单纯测试模板渲染结果，而不真正安装到 Kubernetes 集群中，例如：
```shell
helm install shenyu-test ./charts/shenyu -n=shenyu --create-namespace --dry-run --debug
```

#### 版本

版本号分为两个，一个是 Chart 版本号，一个是 ShenYu 版本号。

* Chart 版本号：在 `Chart.yaml` 中的 `version` 字段中定义。
* ShenYu 版本号：在 `Chart.yaml` 中的 `appVersion` 字段中定义。此字段只起到一个标示作用，真正的 ShenYu 版本号在 `values.yaml` 中的 `image.tag` 字段中定义。

下文提到的版本号均指 Chart 版本号。

版本号遵循 **[语义化版本](https://semver.org/lang/zh-CN/)**。

**每次提交都必须更新版本号**

* 如果改动很小，请更新补丁版本号，例如：`0.1.0` -> `0.1.1`。
* 如果改动比较大（如新增了 feature），但是向下兼容，可以更新次版本号，例如：`0.1.0` -> `0.2.0`。
* 如果改动不向下兼容，可以更新主版本号，例如：`0.1.0` -> `1.0.0`。

#### 发版

1. 更新 `charts/shenyu/Chart.yaml` 中的 `version` 字段。
2. Pull Request 合并后，会触发 GitHub Actions，自动发版。
