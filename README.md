# chemTalentVisSystem: 区域化工人才适配度可视化决策支持系统

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R Version](https://img.shields.io/badge/R-%3E%3D4.0.0-blue.svg)](https://www.r-project.org/)
[![Shiny](https://img.shields.io/badge/Shiny-Dashboard-0099E5.svg)](https://shiny.rstudio.com/)

> **System Ver 1.0.0** | Shiny Dashboard | GIS Visualization | Decision Support

**chemTalentVisSystem** 是一款基于 R/Shiny 开发的交互式决策支持平台，作为"化工人才适配生态"的前端展示层，通过 GIS 地理信息技术与交互式图表，将后端计算引擎输出的数据转化为可视化的**区域热力图**与**团队心理雷达图**。

---

## ✨ 核心功能

### 🗺️ 区域热力图 (Regional Heatmap)
- **GIS可视化**：基于四川省21个市州矢量地图，红-黄-绿三色渐变展示人才适配度
- **交互操作**：支持地图缩放、平移、悬停查看详情
- **实时更新**：数据更新后自动重新渲染

### 📈 团队雷达图 (Team Radar Chart)
- **心理特质分析**：基于大五人格理论(OCEAN模型)的五维诊断
- **交互模拟**：通过滑块实时调整团队特质，观察适配度变化
- **决策支持**：辅助人力资源配置与人岗匹配决策

### 📊 数据控制台 (Data Console)
- **标准接口**：支持CSV格式数据上传，自动匹配空间数据
- **即时预览**：上传数据后自动验证并生成预览
- **批量处理**：支持多数据集切换对比

---

## 🏗️ 系统架构

本系统采用"松耦合、强关联"的分层架构设计：

```
├── 表现层 (Presentation Layer)
│   └── Shiny Dashboard UI + 交互组件
│
├── 逻辑层 (Logic Layer)
│   ├── sf (GIS空间数据处理)
│   ├── echarts4r (交互图表渲染)
│   └── shiny (业务逻辑控制)
│
└── 数据层 (Data Layer)
    ├── CSV接口标准
    ├── 空间数据缓存
    └── 计算结果存储
```

## 📦 安装部署

### 前置要求
- R (≥ 4.0.0)
- RStudio (推荐)

### 安装方法

**方法一：从GitHub安装（推荐）**
```r
# 安装开发工具包（如未安装）
# install.packages("devtools")

# 从GitHub安装本系统
devtools::install_github("ekt-ops/chemTalentVisSystem")
```

**方法二：本地安装**
```r
# 下载源码后，在项目目录中运行
install.packages("path/to/chemTalentVisSystem", repos = NULL, type = "source")
```

## 🚀 快速开始

安装完成后，运行以下代码启动系统：

```r
library(chemTalentVisSystem)

# 启动应用
run_app()

# 或者指定端口（可选）
# run_app(host = "0.0.0.0", port = 8080)
```

### 数据格式要求
系统需要包含以下字段的CSV文件：
- `city`: 城市名称（如"成都市"、"绵阳市"）
- `score`: 适配度得分（0-100）

示例数据：
```csv
city,score
成都市,85.3
绵阳市,72.1
宜宾市,68.9
...
```

## 🔗 生态集成

### 上游系统
- **计算引擎**: [`chemTalentMatchEngine`](https://github.com/ekt-ops/chemTalentMatchEngine)（数据清洗与AHP权重计算）
- **数据处理**: 标准化CSV输出接口

### 下游应用
- 可直接嵌入企业HR系统
- 支持API接口调用（需配置）
- 导出PDF/PNG报告功能

## 📁 项目结构

```
chemTalentVisSystem/
├── R/                      # R函数模块
│   ├── app.R              # 主应用逻辑
│   ├── modules_map.R      # 地图模块
│   ├── modules_radar.R    # 雷达图模块
│   └── utils_data.R       # 数据处理工具
├── inst/
│   └── app/
│       ├── www/           # 静态资源
│       └── data/          # 示例数据
├── man/                   # 文档
├── tests/                 # 测试文件
├── README.md              # 本文档
├── DESCRIPTION            # 包描述
└── LICENSE                # 许可证
```

## 🛠️ 依赖包

系统主要依赖以下R包：
- **shiny** (≥1.7.0): Web应用框架
- **shinydashboard** (≥0.7.2): 仪表板界面
- **sf** (≥1.0.0): GIS空间数据处理
- **echarts4r** (≥0.4.3): 交互图表
- **dplyr** (≥1.1.0): 数据处理
- **readr** (≥2.1.0): CSV文件读取

完整依赖列表请查看 `DESCRIPTION` 文件。


## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 📞 支持与联系

如有问题或建议：
- 提交 [Issue](https://github.com/ekt-ops/chemTalentVisSystem/issues)

---

**开发团队** © 2026 Yan Jintai  
*数据驱动决策，可视化创造价值*