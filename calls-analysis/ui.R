#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

suppressMessages(library('shiny'))
suppressMessages(library('DT'))
suppressMessages(library('rCharts'))
options(RCHART_TEMPLATE = 'Rickshaw.html', RCHART_LIB = 'morris')


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel('Case Study For Freshers (Level : Medium) – Call Center Optimization'),
  
  # Sidebar with a slider input for duration of calls 
  sidebarLayout(
    sidebarPanel(
       sliderInput('duration', 'Number of bins:',
                   min = 1, max = max(dat$Duration.of.calls), value = median(dat$Duration.of.calls))
       ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel('Table', div(id = 'chart1', style = 'display:inline;position:absolute',
                 DT::dataTableOutput('table'))),
        tabPanel('Histogram', div(id = 'chart2', style = 'display:inline;position:absolute',
                 showOutput('histPlot', 'nvd3'))),
        tabPanel('Chart', div(id = 'chart3', style = 'display:inline;position:absolute',
                 showOutput('rPlot1','Rickshaw'))),
        tabPanel('Pie Chart', div(id = 'chart4', style = 'display:inline;position:absolute',
                 showOutput('pieplot', 'nvd3')))
        )
    )
  )
))
