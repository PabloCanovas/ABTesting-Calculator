library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(pwr)
library(ggplot2)
library(ggthemes)
library(PerformanceAnalytics)


ui = navbarPage(
  title = "My cool app",
  theme = shinytheme("united"),
  header = tagList(
    useShinydashboard()
  ),
  tabPanel("A/B Test Calculator",
           tags$style(".bg-aqua { background-color: #f39c12 !important; color: #000000 !important; }"),
           tags$head(
             tags$style(
               # HTML(".small-box {height: 100px}"),
               HTML('.info-box {min-height: 80px;} .info-box-icon {height: 80px; line-height: 80px;} .info-box-content {padding-top: 0px; padding-bottom: 0px;}')
             )
           ),
           fluidRow(
             # shinythemes::themeSelector(),
             column(8,
                    offset = 3,
                    box(collapsible = F,
                        width = 4,
                        # footer = "asd",
                        status = "warning",
                        title = "Settings",
                        
                        column(width = 6,
                               numericInput(inputId = "n_a", label = "Participants", value = 2000, min = 0, max = 1e8),
                               numericInput(inputId = "n_b", label = NULL, value = 2000, min = 0, max = 1e8)
                        ),
                        # div(style = "font-size: 10px; padding: 0px 0px; margin-top:1.4em",
                        # column(1, br(), h5(), HTML(">")),
                        # ),
                        column(width = 5,
                               numericInput(inputId = "x_a", label = "Conversions", value = 500, min = 0, max = 1e8),
                               numericInput(inputId = "x_b", label = NULL, value = 540, min = 0, max = 1e8)
                        )
                        
                    ),
                    box(
                      # offset = 5,
                      width = 4,
                      title = "Confidence level",
                      status = "warning", solidHeader = F,
                      
                      selectInput(inputId = "confidence_level",multiple = F, label = NULL, selectize = T,
                                  choices = list("80%" = .8, "90%" = .9, "95%" = .95, "99%" = .99), selected = .9),
                      # div(style = "font-size: 14px; padding: 0px 0px; margin-top:-1.5em",
                      # column(width = 6,
                      #        radioButtons(inputId = "test_type", label = "Test Type",
                      #                     choices = list("One-tailed" = 1, "Two-tailed" = 2), selected = 1),
                      # ),
                      # column(width = 6,
                      #        radioButtons(inputId = "test_type", label = " ",
                      #                     choices = list("Two-tailed" = 2), selected = 1))
                      # ),
                      # br(),
                      # br(),
                      # tags$style(".bg-aqua { background-color: #f39c12 !important; color: #000000 !important; }"),
                      div(style = "font-size: 10px; padding: 0px 0px; margin-top:4.4em",
                          column(
                            offset = 3,
                            width = 4,
                            actionButton(inputId = "go",
                                         label = paste0(stringi::stri_dup(intToUtf8(160), 4),"TEST"),
                                         width = 125,
                                         icon = icon("calculator", lib = "font-awesome"),
                                         style="color: #000000; background-color: #f39c12; border-color: #f39c12"
                            )
                          )
                      )
                      
                    ),
                    # column(3,
                    #        actionButton("go", "Check")
                    # )
             )
             # wellPanel (
             #   div(textOutput("year"),style = "font-size:500%")
             # )
           ),
           
           fluidRow(
             # box(
             #   width = NULL,
             #   status = ,
             #   background = "black",
             #   "You can be confident the difference between ratios is not due to randomness"
             # ),
             # tags$style(".small-box.bg-green { background-color: #FFFF00 !important; color: #000000 !important; }"),
             
             # tags$style(".small-box.bg-red { background-color: #e95420 !important; color: #000000 !important; }"),
             # tags$head( 
             #   tags$style(HTML(".fa { font-size: 50px; }"))
             # ),
             column(width = 12,
                    offset = 3,
                    valueBoxOutput("boxMessage", 6),
                    style = "height:110px;"
             )
             # valueBoxOutput("boxMessage", 6),
             # valueBoxOutput("conversionRateA", 2),
             # valueBoxOutput("conversionRateB", 2),
             # valueBoxOutput("uplift", 2)
             
             
             
             # infoBoxOutput("boxMessage", 5)
             # infoBoxOutput("boxMessage2",5),
             # verbatimTextOutput("cajita")
           ),
           
           
           fluidRow(
             column(8,
                    offset = 2,
                    box(
                      width = NULL,
                      # width = 10,
                      height = 350,
                      plotOutput("binomials"),
                      status = "warning",
                      # title = "aaa"
                    )
             )
           ),
           
           # tags$style(".bg-aqua { background-color: #e95420 !important; color: #000000 !important; }"),
           fluidRow(style = "height:10px;",
                    column(12,
                           offset = 2,
                           style = "height:10px;",
                           valueBoxOutput("conversionRateA", 3),
                           valueBoxOutput("conversionRateB", 3),
                           valueBoxOutput("uplift", 3),
                           # valueBoxOutput("powerBox", 3)
                    )
           )
           
           
           
  ),
  
  
  tabPanel("Statistical Significance and Power",
           shinyjs::useShinyjs(),
           fluidRow(
             column(8,
                    offset = 2,
                    box(width = 2,
                        status = "warning", 
                        title = "Solve for",
                        
                        selectInput(inputId = "solve_for", multiple = F, label = NULL, selectize = T,
                                    choices = list(
                                      "Alpha" = "alpha",
                                      "Sample Size" = "n",
                                      "Effect Size" = "d",
                                      "Power" = "power"),
                                    selected = "power"),
                        
                        div(style = "font-size: 10px; padding: 0px 0px; margin-top:4.3em",
                            column(
                              width = 4,
                              actionButton(inputId = "solve",
                                           label = paste0(stringi::stri_dup(intToUtf8(160), 4), "SOLVE"), 
                                           width = 100, 
                                           icon = icon("calculator", lib = "font-awesome"),
                                           style="color: #000000; background-color: #f39c12; border-color: #f39c12"
                              )
                            )
                        )
                        
                    ),
                    
                    
                    box(
                      width = 10,
                      status = "warning", 
                      column(width = 6,
                             # tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: purple}")),
                             # tags$style(HTML(".js-irs-1 .irs-single, .js-irs-1 .irs-bar-edge, .js-irs-1 .irs-bar {background: red}")),
                             # tags$style(HTML(".js-irs-2 .irs-single, .js-irs-2 .irs-bar-edge, .js-irs-2 .irs-bar {background: green}")),
                             # tags$style(HTML(".js-irs-3 .irs-single, .js-irs-3 .irs-bar-edge, .js-irs-3 .irs-bar {background: darkorange}")),
                             
                             setSliderColor(c("#656bb2 ", "#fdac4c", "firebrick", "green"), c(1, 2, 3, 4)),
                             
                             sliderInput(inputId = "alpha", label = "Alpha", min = 0.01, max = 1, value = 0.1, step = 0.01, ticks = F),
                             sliderInput(inputId = "power", label = "Power (1 - Beta)", min = 0.01, max = 1, value = 0.75, step = 0.01, ticks = F)
                             
                             ## conditional panels -----
                             
                             # conditionalPanel(
                             #   condition = "input.solve_for=='power'",
                             #   sliderInput(inputId = "alpha", label = "Alpha", min = 0, max = 1, value = 0.05, step = 0.01, ticks = F),
                             #   sliderInput(inputId = "n", label = "Sample Size", min = 50, max = 200, value = 100, step = 10, ticks = F),
                             #   sliderInput(inputId = "d", label = "Effect Size", min = 0, max = 0.5, value = 0.25, step = 0.01, ticks = F),
                             # ),
                             # 
                             # conditionalPanel(
                             #   condition = "input.solve_for=='alpha'",
                             #   sliderInput(inputId = "power", label = "Power", min = 0.01, max = 1, value = 0.8, step = 0.01, ticks = F),
                             #   sliderInput(inputId = "n", label = "Sample Size", min = 50, max = 200, value = 100, step = 10, ticks = F),
                             #   sliderInput(inputId = "d", label = "Effect Size", min = 0, max = 0.5, value = 0.25, step = 0.01, ticks = F),
                             # ),
                             # 
                             # conditionalPanel(
                             #   condition = "input.solve_for=='n'",
                             #   sliderInput(inputId = "alpha", label = "Alpha", min = 0.01, max = 1, value = 0.05, step = 0.01),
                             #   sliderInput(inputId = "power", label = "Power", min = 0.01, max = 1, value = 0.8, step = 0.01, ticks = F),
                             #   sliderInput(inputId = "d", label = "Effect Size", min = 0, max = 0.5, value = 0.25, step = 0.01, ticks = F),
                             # ),
                             # 
                             # conditionalPanel(
                             #   condition = "input.solve_for=='d'",
                             #   sliderInput(inputId = "alpha", label = "Alpha", min = 0.01, max = 1, value = 0.05, step = 0.01),
                             #   sliderInput(inputId = "n", label = "Sample Size", min = 30, max = 300, value = 100, step = 5),
                             #   sliderInput(inputId = "power", label = "Power", min = 0.01, max = 1, value = 0.8, step = 0.01, ticks = F),
                             # )
                             
                             
                             ### ----
                      ),
                      # box(width = 4,
                      column(width = 6,offset = 0,
                             sliderInput(inputId = "n", label = "Sample Size", min = 30, max = 200, value = 80, step = 10, ticks = F),
                             sliderInput(inputId = "d", label = "Effect Size", min = 0.01, max = 0.5, value = 0.22, step = 0.01, ticks = F),
                      ),
                      
                    ))
           ),
           fluidRow(
             column(8,
                    offset = 2,
                    box(
                      width = NULL,
                      # width = 10,
                      height = 400,
                      plotOutput("binomials2"),
                      status = "warning",
                      # title = "aaa"
                    )
             )
           ),
           fluidRow(
             # box(width = NULL,
             column(3, offset = 0,flexdashboard::gaugeOutput("gauge_alpha", width = 400)),
             column(3,flexdashboard::gaugeOutput("gauge_power", width = 400)),
             column(3,flexdashboard::gaugeOutput("gauge_n", width = 400)),
             column(3,flexdashboard::gaugeOutput("gauge_d", width = 400))
             # )
           )
  )
)


## Server ---------------------------

server <- function(input, output, session) {
  
  do_math <- function(){
    
    x_steps <- 150
    
    p1 <- input$x_a/input$n_a
    p2 <- input$x_b/input$n_b
    
    
    min_x <- min(input$x_a, input$x_b)
    max_x <- max(input$x_a, input$x_b)
    min_n <- min(input$n_a, input$n_b)
    max_n <- max(input$n_a, input$n_b)
    
    x_dens <- seq(max(min_x-x_steps, 0),  max_x+x_steps, by = 1)
    density_a <- dbinom(x_dens, input$n_a, p1)
    density_b <- dbinom(x_dens, input$n_b, p2)
    
    xlimits <- c(min(x_dens)/max_n, max(x_dens)/min_n)
    
    max_density_a <- max(density_a)
    max_density_b <- max(density_b)
    
    tbl_a <- tibble(case = "A", x = x_dens/input$n_a, y = density_a)
    tbl_b <- tibble(case = "B", x = x_dens/input$n_b, y = density_b)
    
    confidence_level <- as.numeric(input$confidence_level)
    
    # if(input$test_type == 2){
    #   
    #   alternative_prop <- "two.sided"
    #   alternative_pow <- "two.sided"
    #   
    #   z <- switch(input$confidence_level,
    #               "0.8" = 1.28,
    #               "0.85" = 1.44,
    #               "0.9" = 1.64,
    #               "0.95" = 1.96,
    #               "0.98" = 2.33,
    #               "0.99" = 2.58
    #   )
    # } else {
    
    alternative_pow <- "one.sided"
    
    z <- switch(input$confidence_level,
                "0.8" = 0.84,
                "0.85" = 1.035,
                "0.9" = 1.28,
                "0.95" = 1.645,
                "0.98" = 2.055,
                "0.99" = 2.33
    )
    # }
    
    conf_intervals <- z * sqrt(p1*(1-p1) / input$n_a   +   p2*(1-p2) / input$n_b)
    
    # if(input$test_type == 2)
    #   conf_intervals[2] <- conf_intervals
    
    
    # Si es 2tailed el pvalue tiene que cambiar
    
    if(p1 < p2){
      
      # if(input$test_type == 1)
      alternative_prop <- "less"
      
      tbl <- bind_rows(tbl_a, tbl_b) %>%
        mutate(p_area = if_else(x >= p2 & case == "A", y, NA_real_),
               # y_conf = if_else(x %>% between(p1 - conf_intervals, p1 + conf_intervals) & case == "A", y, NA_real_))
               # y_conf = if_else(x %>% between(p1, p1 + conf_intervals) & case == "A", y, NA_real_))
               # y_conf = if_else(x %>% between(min(x), p1 + conf_intervals) & case == "A", y, NA_real_))
               y_conf = if_else(x %>% between(p1 + conf_intervals, p2) & case == "A", y, NA_real_))
      
      prop <- prop.test(c(input$x_a,input$x_b),
                        c(input$n_a,input$n_b),
                        conf.level = confidence_level,
                        alternative = alternative_prop,
                        correct = F)
      
      # test_power <- power.prop.test(n = floor((input$n_a + input$n_b)/2),
      #                               p1 = p1,
      #                               p2 = p2,
      #                               sig.level = 1-confidence_level,
      #                               power = NULL,
      #                               alternative = alternative_pow)$power
      
    } else {
      
      # if(input$test_type == 1)
      alternative_prop <- "greater"
      
      tbl <- bind_rows(tbl_a, tbl_b) %>%
        mutate(p_area = if_else(x <= p2 & case == "A", y, NA_real_),
               # y_conf = if_else((x <= p1 - conf_intervals) & case == "A", y, NA_real_),
               # y_conf = if_else(x %>% between(p1 - conf_intervals, p1) & case == "A", y, NA_real_))
               # y_conf = if_else(x %>% between(p1 - conf_intervals, max(x)) & case == "A", y, NA_real_))
               # y_conf = if_else(x %>% between(p1 - conf_intervals, max(min(x), p2)) & case == "A", y, NA_real_))
               y_conf = if_else(x %>% between(p2, p1 - conf_intervals) & case == "A", y, NA_real_))
      
      prop <- prop.test(c(input$x_a,input$x_b),
                        c(input$n_a,input$n_b),
                        conf.level = confidence_level,
                        alternative = alternative_prop,
                        correct = F)
      
      # test_power <- power.prop.test(n = floor((input$n_a + input$n_b)/2),
      #                               p1 = p2,
      #                               p2 = p1,
      #                               sig.level = 1-confidence_level,
      #                               power = NULL,
      #                               alternative = alternative_pow)$power
      
      conf_intervals <- -conf_intervals
    }
    
    
    return(list(tbl = tbl, p1 = p1, p2 = p2, xlimits = xlimits, 
                conf_intervals = conf_intervals,
                p_value = prop$p.value, confidence_level = confidence_level, #power = test_power,
                max_density_a = max_density_a, max_density_b = max_density_b))
    
  } 
  
  get_message <- eventReactive(input$go, {
    
    calc <- do_math()
    
    significance <- 1-calc$p_value
    
    if(significance >= calc$confidence_level){
      message <- paste0("You can be ", floor(significance*100), 
                        "% confident that the difference between conversion rates
                        is due to changes you made")
      significative <- T
    } else {
      message <- paste0("You cannot be confident that this result is not due to randomness")
      significative <- F
    }
    
    return(list(message = message, significance = significance, significative = significative))
  }, ignoreNULL = F)
  
  
  plot_binomial <- eventReactive(input$go, {
    
    calc <- do_math()
    
    p <- calc$tbl %>%
      ggplot() +
      geom_ribbon(aes(x, ymin = 0, ymax = y, fill = case, col = case), alpha = .25, size = .5) +
      geom_ribbon(aes(x, ymin = 0, ymax = y_conf, fill = case), alpha = .35) +
      
      geom_ribbon(data = . %>% filter(case == "A"), aes(x, ymin=0,ymax=p_area), fill = "red", alpha = .5) +
      
      geom_segment(aes(x = calc$p1, xend = calc$p1, y = 0, yend = calc$max_density_a), col = "cadetblue3") +
      geom_segment(aes(x = calc$p2, xend = calc$p2, y = 0, yend = calc$max_density_b), col = "tan3") +
      # geom_text(aes(x = calc$p1 , y = -0.001), label = "CR[A]", parse = T, size = 5, family = "serif") +
      # geom_text(aes(x = calc$p2 , y = -0.001), label = "CR[B]", parse = T, size = 5, family = "serif") +
      
      # geom_vline(xintercept = calc$p1 + calc$conf_intervals, size = 0.5, col = "gray35") +
      # annotate(geom = "rect", xmin = calc$p1 , xmax = calc$p1 + calc$conf_intervals,
      #              ymin = 0, ymax = calc$max_density_a, alpha = .1) +
      
      # geom_curve(aes(x = calc$p1 - calc$p1*0.05, y = calc$max_density_a/2,
      #                xend = calc$p1, yend = calc$max_density_a/4),
      #            arrow = arrow(length = unit(0.1, "inch")), size = 1,  col = "orangered1", curvature = 0.3) +
      # annotate(geom = "text", col = "orangered1", x = calc$p1 - calc$p1*0.05, y = calc$max_density_a/2,
    #          size = 3.7, label = "Fall of the \nWestern Empire", fontface = "bold") +
    
    
    
    labs(x = "Conversion Rate") +
      theme_minimal() +
      scale_fill_tableau() +
      scale_color_tableau() +
      # xlim(calc$xlimits) +
      theme(
        axis.text.x = element_text(size = 16),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        # legend.position = "right"
        legend.position = "none"
      )
    
    # if(input$test_type == 2){
    #   
    #   p2 <- p + 
    #     # geom_vline(xintercept = calc$p1 - calc$conf_intervals, size = 0.5, col = "gray35") + 
    #     annotate(geom = "rect", xmin = calc$p1 , xmax = calc$p1 - calc$conf_intervals, 
    #              ymin = 0, ymax = calc$y, alpha = .1) 
    #   
    # } else {
    #   p2 <- p
    # }
    
    return(p)
    
  }, ignoreNULL = F)
  
  do_math2 <- function(){
    
    alpha <- input$alpha
    power <- input$power
    d <- input$d
    n <- input$n
    
    
    switch(input$solve_for,
           "alpha" = {alpha <- NULL},
           "n" = {n <- NULL},
           "d" = {d <- NULL},
           "power" = {power <- NULL}
    )
    
    power_test <- pwr.t.test(n = n, d = d, sig.level = alpha, power = power, alternative = "greater", type = "one.sample")
    
    switch(input$solve_for,
           "alpha" = {alpha <- power_test$sig.level},
           "n" = {n <- ceiling(power_test$n)},
           "d" = {d <- power_test$d},
           "power" = {power <- power_test$power}
    )
    
    std <- 1/sqrt(power_test$n)
    
    p1 <- 0
    p2 <-  d + p1
    
    z_crit <- qnorm(p = 1-alpha, mean = p1, sd = std)
    
    x_dens <- seq(p1-0.5, p2+0.5, by = 0.001)
    
    density_a <- dnorm(x_dens, mean = p1, sd = std)
    density_b <- dnorm(x_dens, mean = p2, sd = std)
    max_density_a <- max(density_a)
    max_density_b <- max(density_b)
    
    
    tbl <- bind_rows(tibble(case = "A", x = x_dens, y = density_a), 
                     tibble(case = "B", x = x_dens, y = density_b)) %>%
      mutate(p_area = if_else(x >= p2 & case == "A", y, NA_real_),
             a_area = if_else(x > z_crit & case == "A", y, NA_real_),
             b_area = if_else(x < z_crit & case == "B", y, NA_real_))
    
    aux <- tbl %>% 
      mutate(aux_a = if_else(is.na(a_area), 0, a_area),
             aux_b = if_else(is.na(b_area), 0, b_area),
             floor = aux_a + aux_b) %>% 
      select(case, x, floor) %>% 
      mutate(case = if_else(case == "A", "C", case), 
             case = if_else(case == "B", "A", case),
             case = if_else(case == "C", "B", case))
    
    tbl <- tbl %>% inner_join(aux, by = c("case", "x"))
    
    
    
    
    return(list(tbl = tbl, z_crit = z_crit, p1 = p1, p2 = p2,
                alpha = alpha, power = power, n = n, d = d,
                max_density_a = max_density_a, max_density_b = max_density_b))
    
  }
  
  plot_binomial2 <- eventReactive(input$solve, {
    
    calc <- do_math2()
    
    calc$tbl %>%
      ggplot() +
      geom_ribbon(aes(x, ymin = floor, ymax = y, fill = case, col = case), alpha = .3, size = .5) +
      # geom_ribbon(data = . %>% filter(case == "A"), aes(x, ymin=0,ymax=p_area), fill = "navy", alpha = .6) +
      geom_ribbon(data = . %>% filter(case == "A"), aes(x, ymin=0,ymax=a_area), fill = "navy", alpha = .5) +
      geom_ribbon(data = . %>% filter(case == "B"), aes(x, ymin=0,ymax=b_area), fill = "darkorange", alpha = .6) +
      geom_segment(aes(x = calc$p1, xend = calc$p1, y = 0, yend = calc$max_density_a), size = 0.75, col = "cadetblue3", linetype = "dotdash") +
      geom_segment(aes(x = calc$p2, xend = calc$p2, y = 0, yend = calc$max_density_b), size = 0.75, col = "tan3", linetype = "dotdash") +
      geom_vline(xintercept = calc$z_crit) + 
      geom_segment(aes(x = calc$p1, y = calc$max_density_a*1.1, xend = calc$p2, yend = calc$max_density_a*1.1), color = "darkgreen",
                   lineend = "round", linejoin = "round", size = 1.5, arrow = arrow(length = unit(0.125, "inches"))) +
      geom_segment(aes(x = calc$p2, y = calc$max_density_a*1.1, xend = calc$p1, yend = calc$max_density_a*1.1), color = "darkgreen",
                   lineend = "round", linejoin = "round", size = 1.5, arrow = arrow(length = unit(0.125, "inches"))) +
      annotate(geom = "text", col = "black", x = calc$p1, y = -0.25, size = 6, label = "H[0]", parse = T, fontface = "bold") +
      annotate(geom = "text", col = "black", x = calc$p2, y = -0.25, size = 6, label = "H[A]", parse = T, fontface = "bold") +
      annotate(geom = "text", x = calc$z_crit - 0.015, y = calc$max_density_a/1.05, size = 5, label = "Zc", fontface = "bold") +
      annotate(geom = "text", x = (calc$p2 - calc$p1)/2, y = calc$max_density_a*1.15, size = 4.5, 
               label = "Effect size", fontface = "bold", color = "darkgreen") +
      
      
      # Para poner las flechas y etiquetas
      
      # annotate(geom = "text", x = calc$p2*1, y = calc$max_density_b/1.7, size = 5, label = "Power", fontface = "bold") +
      # annotate(geom = "text", x = calc$z_crit*1.175, y = calc$max_density_b/15, size = 8, label = expression(alpha), fontface = "bold") +
      # annotate(geom = "text", x = calc$z_crit*0.65, y = calc$max_density_b/8, size = 8, label = expression(beta), fontface = "bold") +
      # 
      # geom_curve(aes(x = calc$p2 + calc$p2*0.1, y = calc$max_density_a/25,
      #                xend = calc$p2 + 0.1, yend = calc$max_density_a/3.2),
      #            arrow = arrow(length = unit(0.1, "inch")), size = 1,  col = "red", curvature = -0.3) +
    # annotate(geom = "text", col = "red", x = calc$p2 + 0.14, y = calc$max_density_a/3.05,
    #          size = 5, label = "p-value", fontface = "bold") +
    
    theme_minimal() +
      scale_fill_tableau() +
      scale_color_tableau() +
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        legend.position = "none"
      ) +
      
      NULL
    
  }, ignoreNULL = F)
  
  
  
  output$binomials <- renderPlot({ plot_binomial() }, height = 350)
  output$boxMessage <- renderValueBox({
    
    message <- get_message()
    
    if(message$significative){
      valueBox(
        value = paste0(floor(message$significance*100),"%"), 
        subtitle = message$message, 
        icon = icon("thumbs-up", lib = "font-awesome"),
        color = "green"
      )
    } else {
      valueBox(
        value = paste0(floor(message$significance*100),"%"), 
        subtitle = message$message, 
        icon = icon("thumbs-down", lib = "font-awesome"),
        color = "red"
      )
    }
  })
  
  get_cra <- eventReactive(input$go, input$x_a/input$n_a, ignoreNULL = F)
  get_crb <- eventReactive(input$go, input$x_b/input$n_b, ignoreNULL = F)
  get_uplift <- eventReactive(input$go,
                              {
                                calc <- do_math()
                                # (calc$p2-calc$p1)*100 / calc$p1
                                
                                (max(calc$p2, calc$p1) - min(calc$p2, calc$p1))*100 / min(calc$p2, calc$p1)
                              }, ignoreNULL = F)
  
  # get_power <- eventReactive(input$go, do_math()$power, ignoreNULL = F)
  
  
  output$conversionRateA <- renderInfoBox({
    infoBox(
      title = h4("A Variation CR"),
      value = paste0(round(get_cra()*100,2), "%"),
      icon = icon("percentage", lib = "font-awesome"),
      color = "aqua"
    )
  })
  
  
  output$conversionRateB <- renderInfoBox({
    
    infoBox(
      value =  paste0(round(get_crb()*100,2),"%"),
      title = h4("B Variation CR"),
      icon = icon("percentage", lib = "font-awesome"),
      color = "aqua"
    )
  })
  
  output$uplift <- renderInfoBox({
    
    infoBox(
      value =  paste0(round(get_uplift(),2), "%"),
      title = h4("Uplift"),
      color = "aqua"
    )
  })
  
  # output$powerBox <- renderInfoBox({
  #   
  #   infoBox(
  #     value =  paste0(round(get_power()*100,1), "%"),
  #     title = h4("Power"),
  #     color = "aqua"
  #   )
  # })
  
  
  observeEvent(input$solve_for, {
    
    shinyjs::enable("alpha")
    shinyjs::enable("n")
    shinyjs::enable("d")
    shinyjs::enable("power")
    
    alpha <- input$alpha
    power <- input$power
    d <- input$d
    n <- input$n
    
    # if(input$solve_for == "alpha"){
    #   shinyjs::disable("alpha")
    # } else if(input$solve_for == "n"){
    #   shinyjs::disable("n")
    # } else if(input$solve_for == "d"){
    #   shinyjs::disable("d")
    # } else if(input$solve_for == "power"){
    #   shinyjs::disable("power")
    # }
    
    switch(input$solve_for,
           "alpha" = {
             shinyjs::disable("alpha")
             alpha <- NULL},
           "n" = {
             shinyjs::disable("n")
             n <- NULL},
           "d" = {
             shinyjs::disable("d")
             d <- NULL},
           "power" = {
             shinyjs::disable("power")
             power <- NULL
             # updateSliderInput(session, inputId = "power", value = power)
           }
    )
    
  })
  
  
  observeEvent(input$alpha, {
    if(input$alpha >= (input$power-0.1))
      updateSliderInput(session, inputId = "power", value = input$alpha+0.1)
  })
  
  observeEvent(input$power, {
    if(input$alpha >= (input$power-0.1))
      updateSliderInput(session, inputId = "alpha", value = input$power-0.1)
  })
  
  
  output$binomials2 <- renderPlot({ plot_binomial2() }, height = 400)
  
  
  observeEvent(input$solve, {
    
    math2 <- do_math2()
    output$gauge_alpha <- flexdashboard::renderGauge({
      flexdashboard::gauge(round(math2$alpha*100,1), min = 0, max = 100, symbol = '%', label = paste("Alpha"),
                           flexdashboard::gaugeSectors(success = c(0, 10), warning = c(11, 49), danger = c(50, 100), 
                                                       colors = c("#656bb2", "#656bb2", "#656bb2")))
    })
    updateSliderInput(session, inputId = "alpha", value = math2$alpha)
    
    
    output$gauge_power <- flexdashboard::renderGauge({
      flexdashboard::gauge(round(math2$power*100,1), min = 0, max = 100, symbol = '%', label = paste("Power"),
                           flexdashboard::gaugeSectors(success = c(80, 100), warning = c(51, 79), danger = c(0, 50), 
                                                       colors = c("#fdac4c", "#fdac4c", "#fdac4c")))
    })
    updateSliderInput(session, inputId = "power", value = math2$power)
    
    
    output$gauge_n <- flexdashboard::renderGauge({
      flexdashboard::gauge(round(math2$n,0), min = 00, max = 250, label = paste("Sample Size"),
                           flexdashboard::gaugeSectors(success = c(80, 100), warning = c(51, 79), danger = c(0, 50), 
                                                       colors = c("firebrick", "firebrick", "firebrick")))
    })
    updateSliderInput(session, inputId = "n", value = math2$n)
    
    output$gauge_d <- flexdashboard::renderGauge({
      flexdashboard::gauge(round(math2$d,1), min = 00, max = 0.5, label = paste("Effect Size"),
                           flexdashboard::gaugeSectors(success = c(80, 100), warning = c(51, 79), danger = c(0, 50), 
                                                       colors = c("green", "green", "green")))
    })
    updateSliderInput(session, inputId = "d", value = math2$d)
    
  }, ignoreNULL = F)
  
}
shinyApp(ui, server)
