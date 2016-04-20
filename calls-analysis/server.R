#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

suppressMessages(library('shiny'))
suppressMessages(library('DT'))
suppressMessages(library('rCharts'))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  ## https://rstudio.github.io/DT/shiny.html
  output$table <- renderDataTable({
    dTable(dat, 
                  caption="Table : Number of words",
                  extensions = list("ColReorder"=NULL, "ColVis"=NULL, "TableTools"=NULL
                                    #, "FixedColumns"=list(leftColumns=2)
                  ), 
                  options = list(autoWidth=TRUE,
                                 oColReorder=list(realtime=TRUE), #oColVis=list(exclude=c(0, 1), activate='mouseover'),
                                 oTableTools=list(
                                   sSwfPath="//cdnjs.cloudflare.com/ajax/libs/datatables-tabletools/2.1.5/swf/copy_csv_xls.swf",
                                   aButtons=list("copy", "print",
                                                 list(sExtends="collection",
                                                      sButtonText="Save",
                                                      aButtons=c("csv","xls")))),
                                 dom='CRTrilftp', scrollX=TRUE, scrollCollapse=TRUE,
                                 colVis=list(exclude=c(0), activate='mouseover')))
  })
  
  ## make the rickshaw rChart
  ## http://rcharts.io/gallery/
  ## http://timelyportfolio.github.io/rCharts_rickshaw_gettingstarted/
  output$histplot <- renderChart2({
    nPlot(Duration.of.calls ~ Call, data = dat, type = 'multiBarChart')
  })
  
  output$rPlot1 <- renderChart2({
    r1 <- Rickshaw$new()
    r1$layer(Duration.of.calls ~ Call, data = dat, type = 'line')
    r1$set(slider = TRUE)
    r1$print('chart1')
  })
  
  output$pieplot <- renderChart({
    nPlot(Duration.of.calls ~ Call ~ Call, data = dat, 
                     type = 'pieChart', dom = 'pieplot')
  })
})
