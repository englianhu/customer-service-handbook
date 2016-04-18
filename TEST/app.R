## Load packages
suppressMessages(library('shiny'))
suppressMessages(library('DT'))
suppressMessages(library('rCharts'))
suppressMessages(library('dplyr'))
suppressMessages(library('shiny'))
options(RCHART_TEMPLATE = 'Rickshaw.html', RCHART_LIB = 'morris')

lnk <- 'http://www.analyticsvidhya.com/wp-content/uploads/2016/04/Case_Level2.csv'

if(!file.exists('data/Case_Level2.csv')){
  dir.create('data')
  download.file(lnk, destfile='data/Case_Level2.csv')
}

dat <- tryCatch({
  suppressMessages(read.csv(lnk, stringsAsFactors = FALSE)) %>% tbl_df
}, error=function(e) {
  suppressMessages(read.csv('data/Case_Level2.csv', stringsAsFactors = FALSE)) %>% tbl_df
})

rm(lnk)

shinyApp(
  ## Define UI for application that draws a histogram
  ui <- #shinyUI(
    fluidPage(
      
      ## Application title
      titlePanel('Case Study For Freshers (Level : Medium) – Call Center Optimization'),
      
      ## Sidebar with a slider input for duration of calls
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = 'x', label = 'Choose X', choices = names(dat), selected = 'Time'),
          selectInput(inputId = 'y', label = 'Choose Y', choices = names(dat), selected = 'Call'),
          sliderInput('duration', 'Number of bins:',
                      min = 1, max = max(dat$Duration.of.calls), value = median(dat$Duration.of.calls))
        ),
        
        ## Show a plot of the generated distribution
        mainPanel(
          h4('Here are few things you should consider:'),
          p('1. The duration of calls is in “Minutes”.'),
          p('2. Time is the time (in minutes) from 00:00 midnight.'),
          p('3. Call represents the ID of the customer.'),
          p('4. Assume that every caller has same efficiency and takes equal duration of calls  as given in data.'),
          p('5. Also, you should assume that there were no breaks taken by the caller. 
            And, individual caller is available for entire 24 hours. 
            Note that the data is only for a single day (1440 minutes).'),
          tabsetPanel(
            tabPanel('Table', showOutput('table', 'nvd3')),
            tabPanel('Poly Chart', showOutput('rPlot1', 'polycharts')),
            tabPanel('Histogram', showOutput('rPlot2', 'nvd3')),
            tabPanel('Layer/Line Chart', showOutput('rPlot3','rickshaw')),
            tabPanel('Pie Chart', showOutput('rPlot4', 'nvd3')))
          )
      )
      #)
),

## Define server logic required to draw a histogram
server <- #shinyServer(
  function(input, output) {
    
    ## https://rstudio.github.io/DT/shiny.html
    output$table <- renderChart2({
      dTable(dat, caption="Table : Number of words",
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
    
    output$rPlot1 <- renderChart2({
      p1 <- rPlot(input$x, input$y, data = dat, color = names(dat[3]),
                  facet = names(dat[3]), type = 'point')
      return(p1)
    })
    
    ## make the rickshaw rChart
    ## http://rcharts.io/gallery/
    ## http://timelyportfolio.github.io/rCharts_rickshaw_gettingstarted/
    output$rPlot2 <- renderChart2({
      p2 <- nPlot(Time ~ Call, group = 'Duration.of.calls', data = dat, type = 'multiBarChart')
      p2$addParams(dom = 'myChart')
      return(p2)
    })
    
    output$rPlot3 <- renderChart2({
      p3 <- Rickshaw$new()
      p3$layer(Call ~ Time, group='Duration.of.calls', data = dat, type = 'area')
      p3$set(hoverDetail = TRUE, xAxis = TRUE, yAxis = TRUE, shelving = TRUE, legend = TRUE, 
             slider = TRUE, highlight = TRUE)
      return(p3)
    })
    
    output$rPlot4 <- renderChart({
      p4 <- nPlot(Call ~ Time, group='Duration.of.calls', data = dat, type = 'pieChart', dom = 'pieplot')
      return(p4)
    })
  }#)
)

