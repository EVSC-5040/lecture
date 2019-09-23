library(MASS)
library(mgcv)
library(tidyverse)
library(shiny)

source(here::here("R/plot_gam.R"))

# UI
ui <- fluidPage(
   
   # Application title
   titlePanel("Generalized Additive Models"),
   h4("Adjusting the number of knots (k) and smoothing parameter (sp)"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(width = 4,
         sliderInput("k",
                     "Number of basis functions (k):",
                     min = 1,
                     max = 50,
                     value = 1),
      
        sliderInput("sp",
                    "Smoothing parameter (sp):",
                    min = 0.01,
                    max = 2,
                    value = 0.001),
         p("A GAM is fitted to the MASS::mcycle data set using mgcv::gam(). This
           Shiny app allows for users to adjust the smoothing parameters (sp) and 
           the number of knots (k) used to fit the model. In practice, the mgcv::gam()
           does this automatically using Generalized Cross Validation (GCV)
           (Zuur et al. 2009, pg 51-52). GCV provides a way to optimize trade-offs
           between likelihood (how good the model fit is) and non-linearity that could result in
           overfitting."),
        h3("Questions:"),
        p("What happens when k is large and sp is increased?"),
        p("When k = 50, how do increases to sp affect the effective degrees of freedom (edf)? What
          does edf tell you?"),
        p("Try to minimize GCV by hand."),
        HTML("Note: the sp parameter in mgcv::gam() is equivalent to &lambda; penalty on 
              nonlinearity as discussed in Zuur et al. 2009.")
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("gam_plot"),
         verbatimTextOutput("gam_sum")
      )
   )
)


#Server side
server <- function(input, output) {
   
   output$gam_plot <- renderPlot({
      plot_gam(df = mcycle, 
               k = input$k, 
               sp = input$sp)
   })
   
   output$gam_sum <- renderPrint(
     plot_gam(df = mcycle, 
              k = input$k, 
              sp = input$sp,
              make_fig = F)
   )
}

# Run
shinyApp(ui = ui, server = server)

