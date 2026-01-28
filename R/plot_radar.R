#' 绘制团队心理特质雷达图
#'
#' @param scores 包含5个分数的向量 (开放性, 责任心, 神经质, 外向性, 宜人性)
#' @return Echarts 交互式雷达图
#' @export
plot_team_radar <- function(scores) {
  # 构建数据框
  df <- data.frame(
    x = c("开放性", "责任心", "神经质", "外向性", "宜人性"),
    y = scores
  )
  
  # 绘图
  df %>%
    echarts4r::e_charts(x) %>%
    echarts4r::e_radar(y, name = "当前团队", max = 10) %>% # 假设满分10分
    echarts4r::e_tooltip(trigger = "item") %>%
    echarts4r::e_color(c("#2c7bb6")) %>%
    echarts4r::e_title("团队心理特质模型")
}