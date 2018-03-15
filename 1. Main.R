# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#            Shiny Example
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# step 1:  create a bunch of charts 
# step 2:  run shiny interface to compare charts 

source("0. functions.R")
install_libraries()

#----------------------------
# Make Token/ID
#----------------------------
# this token is used to link each iteration of source data to its output
Token<<- set_token() #Date and time 

# create some item estimates. 
# 6 tests created, 10 items per round/test. 
# I used a random generator because I wanted big, easy to see differences in the charts
total_rounds <- 6
results<-data_frame("round"=paste0("round",seq(1,total_rounds)),"itm_params"=seq(1,total_rounds))

for(r in 1:total_rounds){
  results[r,]$itm_params<-list(unlist(runif(10, min = -3.000, max = 3.000)))
}
results$itm_params

# use item thresholds to calculate test info curves
results$test_scores <-results%>%
{pmap(list(.$round,.$itm_params),score_a_test)}


# plot plots plots
# generate and export plots
output_directory<- "Output_Charts"   #folder will be created if it does not already exist

results%>%
{ pmap(list(.$test_scores,.$round, output_directory), create_plot) } 


#----------------------------
# Interface for Plots
#----------------------------
# User interface for all images (current and historic)

output_directory<- "Output_Charts/"   

rmarkdown::run("Comparing_Images.Rmd")


