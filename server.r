library(ggplot2)


shinyServer(function(input, output,session) {
  
  data <- reactive({
    if (is.null(input$file1)) {
      return(NULL)
    }
    d <- read.csv(input$file1$datapath, header=input$header, sep=input$sep)    # read the file
    return(d)     
    
  })   
  
  output$contents <- renderTable({
  inFile <- input$file1
  
  if (is.null(inFile))
    return(NULL)
  
  read.csv(inFile$datapath, header=input$header, sep=input$sep)       #, quote=input$quote
 
  })  
  
 observe({
 df <- data()
 str(names(df))
 
 if (!is.null(df)) {
   updateSelectInput(session, 'attributes', choices = names(df))
   
   updateSelectInput(session, 'attributx', choices = names(df))
   updateSelectInput(session, 'attributy', choices = names(df))
   
   updateSelectInput(session, 'attrx', choices = names(df))
   updateSelectInput(session, 'attry', choices = names(df))
   
   updateSelectInput(session, 'sizeline', choices = c(None='.', names(df)))
   updateSelectInput(session, 'sizepoint', choices = c(None='.', names(df)))
   updateSelectInput(session, 'fil', choices = c(None='.', names(df)))
   
   updateSelectInput(session, 'filline', choices = c(None='.', names(df)))
   updateSelectInput(session, 'filpoint', choices = c(None='.', names(df)))
   updateSelectInput(session, 'facet_row', choices = c(None='.', names(df)))
   
   updateSelectInput(session, 'facet_rowline', choices = c(None='.', names(df)))
   updateSelectInput(session, 'facet_rowpoint', choices = c(None='.', names(df)))
   updateSelectInput(session, 'facet_col', choices = c(None='.', names(df)))
   
   updateSelectInput(session, 'reg_y', choices = c(None='.', names(df)))
   updateSelectInput(session, 'reg_x', choices = c(None='.', names(df)))
   

  
 }
}) 
 

in_range <- function(x, range) {
  x >= min(range) & x <= max(range)
}

output$Plot <- renderPlot({
  if (is.null(data()))
    return(NULL) 
  input$goButton
  input$goButton1
  
  input$goButton4
  input$goButton5
  
  if ( input$plot == "none" ) {
    return(NULL)
  }
  
  isolate({
    
    if ( input$plot == "hist" ) {
      
      if(input$fil!="." ){
        aes_mapping <- aes_string(x = input$attributes,group=input$fil,fill=input$fil) } #
      
     
      else{
        
        aes_mapping <- aes_string(x =input$attributes)  }
      
 
      #plot
      p <- ggplot(data(),mapping=aes_mapping ) +
        geom_histogram(binwidth=isolate(input$bin))
      
      facets <- paste(input$facet_row, '~', input$facet_col)
      if (facets != '. ~ .')
        p <- p + facet_grid(facets,scales='free')  +theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust=0.4,size=9))
      
    }
    
  }) 
  if ( input$plot == "line" ) {
    
    if(input$filline!='.' ){
      if(input$sizeline!='.'){
        aes_mapping <- aes_string(x =isolate(input$attributx),y=isolate(input$attributy),color=input$filline,size=input$sizeline) }       #
      else{
        aes_mapping <- aes_string(x =isolate(input$attributx),y=isolate(input$attributy),color=input$filline) }
    }
    
    else{
      aes_mapping <- aes_string(x =isolate(input$attributx),y=isolate(input$attributy))   }
    
    #plot
    p <- ggplot(data(),mapping=aes_mapping ) +
      geom_line(group=input$filline)              
    
    facets <- paste(input$facet_rowline, '~', input$facet_colline)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)  +theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust=0.4,size=9))
    
  } 
  
  if ( input$plot == "point" ) {
    
    if(input$filpoint!='.' ){
      if(input$sizepoint!='.'){
        aes_mapping <- aes_string(x =isolate(input$attrx),y=isolate(input$attry),color=input$filpoint,size=input$sizepoint) }     
      else{
        aes_mapping <- aes_string(x =isolate(input$attrx),y=isolate(input$attry),color=input$filpoint) }
    }
    
    else{
      aes_mapping <- aes_string(x =isolate(input$attrx),y=isolate(input$attry))  }
    
    #plot
    p <- ggplot(data(),mapping=aes_mapping ) +
      geom_point()
    
    facets <- paste(input$facet_rowpoint, '~', input$facet_colpoint)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)  +theme(axis.text.x=element_text(angle = 90, hjust = 1,vjust=0.4,size=9))
    
  }   
  
  print(p)
})
  
  output$Regresion <- renderPlot({

    
    if (is.null(data()))
      return()
    
    # ------------------------------------------------------------------
    # Make the base plot
    
    # If any models are drawn, make the points less prominent
    if (input$mod_linear || input$mod_quadratic || input$mod_loess)
      point_alpha <- 0.5
    else
      point_alpha <- 1
    
  
    
  
    # Base plot
    p <- ggplot(data(), mapping = aes_string(x =input$reg_x,y=input$reg_y)) +
      geom_point(shape = 21, alpha = point_alpha)+
      scale_colour_hue(l = 40) +
      scale_shape(solid = FALSE) 
   
    # Add model lines
    
    if ( (input$mod_linear) & (input$stder) ){
      p <- p + geom_smooth(method = lm, se = TRUE, size = 0.75,
                           linetype = "twodash")
    }
   else if((input$mod_linear)){
     p <- p + geom_smooth(method = lm, se = FALSE, size = 0.75,
                          linetype = "twodash")
   }
   
    if( (input$mod_quadratic) & (input$stder.quad) ) {
      p <- p + geom_smooth(method = lm, se = TRUE, formula = y ~ x + I(x^2),
                           size = .75, linetype = "dashed")
    }
   else if (input$mod_quadratic) {
     p <- p + geom_smooth(method = lm, se = FALSE, formula = y ~ x + I(x^2),
                          size = .75, linetype = "dashed")
   }
   
   if( (input$mod_loess) & (input$stder.loess) ) {
     p <- p +  geom_smooth(method = loess, se = TRUE, linetype = "solid",
                           span = input$mod_loess_span)
   }
   else if (input$mod_loess) {
      p <- p + geom_smooth(method = loess, se = FALSE, linetype = "solid",
                           span = input$mod_loess_span)
    }
    
    print(p)
  })
  
  
  # ------------------------------------------------------------------
 # Generate a summary of the dataset
   output$summary <- renderPrint({
    summary(data())
})

# Show the first "n" observations
   output$contents <- renderTable({
    head(data(), n = input$obs)
})
  
  # ------------------------------------------------------------------
  # Functions for creating models and printing summaries
  
  make_model <- function(model_type, formula, ...) {
    
    # In order to get the output to print the formula in a nice way, we'll
    # use do.call here with some quoting.
    do.call(model_type, args = list(formula = formula,data = quote(data()),  ...)) 
  }
  
  output$mod_linear_text <- renderPrint({
    formula <- paste(input$reg_y, "~", input$reg_x)
   
    summary(make_model("lm", formula))
  })
  
  output$mod_quadratic_text <- renderPrint({
    formula <- paste(input$reg_y, " ~ ", "I(", input$reg_x, "^2) + ",
                     input$reg_x, sep = "")
    
    summary(make_model("lm", formula))
  })
  
  output$mod_loess_text <- renderPrint({
    formula <- paste(input$reg_y, "~", input$reg_x)
    summary(make_model("loess", formula, span = input$mod_loess_span))
  })
  
  
})