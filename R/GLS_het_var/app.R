library(MASS)
library(nlme)
library(tidyverse)
library(shiny)

source(here::here("R/visualize_model_fits.R"))

# UI
ui <- fluidPage(
  
  # Application title
  titlePanel("Generalized Least Squares"),
  h4("Accounting for heterogeneity of variance"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 4,
                 sliderInput("b1",
                             HTML("True slope (effect size, B<sub>1</sub>):"),
                             min = 0.01,
                             max = 5,
                             value = 0.01),
                 sliderInput("stdev",
                             "Standard deviation:",
                             min = 1,
                             max = 20,
                             value = 1),
                 sliderInput("n",
                             "N observations:",
                             min = 10,
                             max = 400,
                             value = 1),
                 HTML('<font size="4">Here we simulate data from a normal distribution where variance 
                    (&sigma;<sup>2</sup>) increases linearly with our predictor. For each simulation,
                    we use a known effect size (&beta;<sub>1</sub>; black line) that is estimated using OLS and GLS 
                    models. The GLS model (pink) assumes a fixed variance structure, 
                    whereas the OLS model (blue) is deliberately misspecified to assume homogeneity of variance.</font.'),
                 br(),
                 br(),
                 br(),
                 p("Notice how when N is small, neither model properly estimates the true effect size,
                   and will instead overshoot or undershoot the known relationship.")
                 ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("mod_plot"),
      actionButton("run","Simulate"),
      htmlOutput("summ")
      
    )
                 )
  )


#Server side
server <- function(input, output) {
  
  in_df <- eventReactive(input$run, {
      n <- input$n
      b <- input$b1
      x <- 1:input$n
      sdev <- input$stdev
      
      data.frame(y = b*x + rnorm(n, mean = 0, sd = sdev) * x,
                 x = x,
                 known = b*x)
    })

  output$mod_plot <- renderPlot({
    b <- input$b1
    visualize_model_fits(df = in_df(), known = b)
    
  })
  
  output$summ <- renderText({
    b <- input$b1
    model_summ(df = in_df(), known = b)
    })
}

# Run
shinyApp(ui = ui, server = server)

