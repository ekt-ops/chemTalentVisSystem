#' 启动可视化系统
#'
#' @export
run_app <- function() {
  # 找到安装包内的 app 目录
  app_dir <- system.file("app", package = "chemTalentVisSystem")
  
  # 如果是开发模式（还没安装包），则尝试直接定位本地路径
  if (app_dir == "") {
    app_dir <- "inst/app"
  }
  
  if (!dir.exists(app_dir)) {
    stop("无法找到 App 目录，请检查包是否正确安装。")
  }
  
  # 启动 Shiny 应用
  shiny::runApp(app_dir, display.mode = "normal")
}