library(shiny)
library(shinydashboard)
library(sf)
library(dplyr)
library(echarts4r)
# 注意：在开发阶段，需要先运行 devtools::load_all() 加载包内函数
# 安装后，这行代码 library(chemTalentVisSystem) 会自动生效

# ==========================================
# 1. 用户界面 (UI)
# ==========================================
ui <- dashboardPage(
  skin = "green", # 呼应“绿色化工”主题
  
  # 标题栏
  dashboardHeader(title = "化工人才可视化决策系统"),
  
  # 侧边栏
  dashboardSidebar(
    sidebarMenu(
      menuItem("区域热力图", tabName = "map_dashboard", icon = icon("map")),
      menuItem("团队雷达图", tabName = "radar_dashboard", icon = icon("users")),
      menuItem("数据下载", tabName = "data_export", icon = icon("download"))
    )
  ),
  
  # 主体内容
  dashboardBody(
    tabItems(
      # --- 页面 1: 区域热力图 ---
      tabItem(tabName = "map_dashboard",
        fluidRow(
          # 左侧：控制面板
          box(
            title = "数据控制台", status = "success", solidHeader = TRUE, width = 3,
            fileInput("file_map", "上传区域数据 (.csv)",
                      accept = ".csv", buttonLabel = "浏览..."),
            helpText("提示：CSV需包含 'city' 和 'score' 两列。"),
            downloadButton("download_demo_csv", "下载测试数据模板")
          ),
          # 右侧：地图展示
          box(
            title = "四川省化工人才适配度热力图", status = "primary", width = 9,
            echarts4rOutput("heatmap_plot", height = "600px")
          )
        )
      ),
      
      # --- 页面 2: 团队雷达图 ---
      tabItem(tabName = "radar_dashboard",
        fluidRow(
          # 左侧：输入面板
          box(
            title = "团队心理特质评分", status = "warning", solidHeader = TRUE, width = 4,
            sliderInput("trait_open", "开放性 (Openness)", 0, 10, 8),
            sliderInput("trait_cons", "责任心 (Conscientiousness)", 0, 10, 7),
            sliderInput("trait_neur", "神经质 (Neuroticism)", 0, 10, 3), # 注意：此处为原始分
            sliderInput("trait_extra", "外向性 (Extraversion)", 0, 10, 6),
            sliderInput("trait_agree", "宜人性 (Agreeableness)", 0, 10, 8)
          ),
          # 右侧：雷达图
          box(
            title = "特质匹配诊断模型", status = "primary", width = 8,
            echarts4rOutput("radar_plot", height = "500px")
          )
        )
      ),
      
      # --- 页面 3: 数据导出 ---
      tabItem(tabName = "data_export",
        h3("系统说明"),
        p("本系统支持软著申请材料中提到的‘多格式输出’功能。"),
        p("当前版本版本号：V1.0.0")
      )
    )
  )
)

# ==========================================
# 2. 服务器逻辑 (Server)
# ==========================================
server <- function(input, output, session) {
  
  # --- 逻辑 1: 处理热力图 ---
  
  # 读取上传的数据
  map_data <- reactive({
    req(input$file_map)
    read.csv(input$file_map$datapath)
  })
  
  # 生成演示数据下载
  output$download_demo_csv <- downloadHandler(
    filename = "demo_sichuan_data.csv",
    content = function(file) {
      # 创建一个覆盖四川主要城市的模拟数据
      demo <- data.frame(
        city = c("成都市", "绵阳市", "自贡市", "攀枝花市", "泸州市", "德阳市", 
                 "广元市", "遂宁市", "内江市", "乐山市", "南充市", "眉山市", 
                 "宜宾市", "广安市", "达州市", "雅安市", "巴中市", "资阳市", 
                 "阿坝藏族羌族自治州", "甘孜藏族自治州", "凉山彝族自治州"),
        score = sample(60:95, 21, replace = TRUE)
      )
      write.csv(demo, file, row.names = FALSE)
    }
  )
  
  # 渲染地图
  output$heatmap_plot <- renderEcharts4r({
    # 如果用户还没上传数据，显示默认演示数据
    data_to_plot <- NULL
    
    if (is.null(input$file_map)) {
      # 默认演示数据
      data_to_plot <- data.frame(
        city = c("成都市", "宜宾市", "南充市"), 
        score = c(95, 88, 70)
      )
      showNotification("当前显示为默认演示数据，请上传 CSV 文件。", type = "message")
    } else {
      data_to_plot <- map_data()
    }
    
    # 调用我们在 plot_heatmap.R 里写的核心函数
    # 注意：在包开发模式下，确保 plot_sichuan_heatmap 已加载
    tryCatch({
      chemTalentVisSystem::plot_sichuan_heatmap(data_to_plot)
    }, error = function(e) {
      # 如果找不到函数（比如直接运行app.R而非加载包），尝试直接调用本地环境的函数
      # 这里是一个容错处理
      plot_sichuan_heatmap(data_to_plot) 
    })
  })
  
  # --- 逻辑 2: 处理雷达图 ---
  
  output$radar_plot <- renderEcharts4r({
    # 获取滑块的输入值
    scores <- c(
      input$trait_open,
      input$trait_cons,
      input$trait_neur,
      input$trait_extra,
      input$trait_agree
    )
    
    # 调用我们在 plot_radar.R 里写的核心函数
    tryCatch({
      chemTalentVisSystem::plot_team_radar(scores)
    }, error = function(e) {
      plot_team_radar(scores)
    })
  })
}

# 启动 App
shinyApp(ui, server)