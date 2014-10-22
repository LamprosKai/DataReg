 library(shiny)
 
 dataset <- list('Upload a file'=c(1))
 
shinyUI(pageWithSidebar(
 
  headerPanel("Data Visualization and Regression"),
 
  sidebarPanel(
    
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 selected = NULL),
    
    numericInput("obs", "Number of observations to view:", 100),
    
    checkboxInput("plotting", "Plotting",
                  value = FALSE),  
    
    conditionalPanel(  
      condition = "input.plotting == true" ,
      
      
      selectInput("plot",label="Plot Type",choices=list('None'='none',"Histogram"="hist","Linechart"="line","Pointchart"="point")),
      
      conditionalPanel(
        condition = "input.plot == 'none'"
        
      ) ,
      
      conditionalPanel(
        condition = "input.plot == 'hist'",
        
        selectInput(inputId = "attributes",
                    label = "ATTRIBUTES",
                    choices=names(dataset)),
        
        
        sliderInput("bin",label="Binwidth",
                    min=0,max=200,value=1,step=0.1),
        
        actionButton("goButton1", "Update View"),
        
        
        selectInput("fil", "Fill",choices=
                      c('None'='.',names(dataset))),
        
        selectInput('facet_row', 'Facet Row', c('None'='.',names(dataset))),
        selectInput('facet_col', 'Facet Column', c('None'='.',names(dataset)))
        
      ),
      
      
      conditionalPanel(
        condition = "input.plot == 'line'",
        selectInput(
          inputId = "attributx",
          label = "X",
          choices = names(dataset),
        ),
        selectInput(
          inputId = "attributy",
          label = "Y",
          choices = names(dataset),
        ) ,actionButton("goButton4", "Update View"),
        
        selectInput("filline", "Fill",choices=
                      c('None'='.',names(dataset))),
        
        selectInput("sizeline", "Size",choices=
                      c('None'='.',names(dataset))),
        
        selectInput('facet_rowline', 'Facet Row', c('None'='.',names(dataset))),
        selectInput('facet_colline', 'Facet Column', c('None'='.',names(dataset)))
        
      ),
      
      
      conditionalPanel(
        condition = "input.plot == 'point'" ,
        selectInput(
          inputId = "attrx",
          label = "X",
          choices = names(dataset),
        ),
        selectInput(
          inputId = "attry",
          label = "Y",
          choices = names(dataset),
        ),actionButton("goButton5", "Update View"),
        
        selectInput("filpoint", "Fill",choices=
                      c('None'='.',names(dataset))),
        
        selectInput("sizepoint", "Size",choices=
                      c('None'='.',names(dataset))),
        
        selectInput('facet_rowpoint', 'Facet Row', c('None'='.',names(dataset))),
        selectInput('facet_colpoint', 'Facet Column', c('None'='.',names(dataset)))
        
      )                
      
      
    ),
    
    checkboxInput("reg", "Regresion",
                  value = FALSE),  
    
    conditionalPanel(  
      condition = "input.reg == true" ,
      
            
      conditionalPanel(
        condition = "input.reg == 'none'"
        
      ) ,
      
 
  # conditionalPanel( 
   
      selectInput(inputId = "reg_y",
                  label = "Response variable",
                  choices = names(dataset)
                 ),
  
  selectInput(inputId = "reg_x",
              label = "Predictor variable",
              choices = names(dataset)
  ),
  
  p(strong("Model predictions")),
  
  
  checkboxInput(inputId = "mod_linear",    label = "Linear (two-dash)"),
  conditionalPanel(
    condition = "input.mod_linear == true",
    checkboxInput(inputId ="stder",label = "Std Error")
  ), 
  
  checkboxInput(inputId = "mod_quadratic", label = "Quadratic (dashed)"),
  conditionalPanel(
    condition = "input.mod_quadratic == true",
    checkboxInput(inputId ="stder.quad",label = "Std Error")
  ),
  
  checkboxInput(inputId = "mod_loess",     label = "Locally weighted LOESS (solid)"),
  conditionalPanel(
    condition = "input.mod_loess == true",
    checkboxInput(inputId ="stder.loess",label = "Std Error"),
 
    sliderInput(inputId = "mod_loess_span", label = "Smoothing (alpha)",
                min = 0.15, max = 1, step = 0.05, value = 0.75))  
  )
  ),

 
    mainPanel(
      
  
      # Show a summary of the dataset and an HTML table with the requested
      # number of observations
      
      tabsetPanel(
        tabPanel("Contents", tableOutput('contents')),
        tabPanel("Plot", plotOutput("Plot", width = "1000px", height = "800px")),
        tabPanel('Summary',verbatimTextOutput('summary')),
        tabPanel('Regresion',plotOutput("Regresion", width = "1000px", height = "800px"),
                 
                 conditionalPanel("input.mod_linear == true",p(strong("Linear model")), verbatimTextOutput(outputId = "mod_linear_text")),
                 conditionalPanel("input.mod_quadratic == true",p(strong("Quadratic model")),
                                  verbatimTextOutput(outputId = "mod_quadratic_text")),
                 conditionalPanel("input.mod_loess == true",p(strong("LOESS model")),
                                  verbatimTextOutput(outputId = "mod_loess_text"))
                 
                 )
        
        )
      
    )
 
  
  ))