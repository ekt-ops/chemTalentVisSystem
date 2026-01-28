#' 绘制四川省人才适配度热力图
#'
#' @param data 数据框，必须包含 "city" (市州名) 和 "score" (匹配度)
#' @return Echarts 交互式地图对象
#' @export
plot_sichuan_heatmap <- function(data) {
  # 1. 寻找地图文件路径
  map_path <- system.file("extdata", "sichuan_map.json", package = "chemTalentVisSystem")
  if (map_path == "") map_path <- "inst/extdata/sichuan_map.json" # 开发模式回退路径
  
  # 2. 读取地图数据
  sichuan_json <- jsonlite::read_json(map_path)
  
  # 3. 绘制交互式地图
  data %>%
    echarts4r::e_charts(city) %>%
    echarts4r::e_map_register("sichuan", sichuan_json) %>%
    echarts4r::e_map(score, map = "sichuan") %>%
    echarts4r::e_visual_map(
      score, 
      inRange = list(color = c("#66bd63", "#ffffbf", "#d73027")), # 绿-黄-红渐变
      min = 0, max = 100
    ) %>%
    echarts4r::e_title("四川省化工人才适配度热力图") %>%
    echarts4r::e_tooltip(trigger = "item", formatter = "{b}: {c}分")
}