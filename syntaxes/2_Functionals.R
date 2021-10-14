# Advanced Programming with R
# Zurich R Courses, October 2021

# Functionals
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


## Useful functions -----
## __________________________________________________________________________

?lapply      # Wrapper around a for loop
?Map         # creates a while loop

# other functions in the same family
?sapply
?vapply
?apply

?Map
?mapply

?tapply
?aggregate
?by

# other functionals
?reduce
?nlm
?optimize


## Example Code
## __________________________________________________________________________

## lapply
example_list <- list(vec1 = c(1, 3, 4),
                     vec2 = c(4, 2, 10), 
                     vec3 = c(2, NA, 1))
lapply(example_list, FUN = mean)

# further arguments
lapply(example_list, FUN = mean, na.rm = TRUE) 

# own functions
dropNAs <- function(x) {
  x[!is.na(x)]
}
lapply(example_list, FUN = dropNAs) 

# anonymous functions
lapply(example_list, FUN = function(x) x[!is.na(x)]) 

# use on data.frames
lapply(iris, FUN = class)

# use on atomic vectors
lapply(c(1, 2, 3), FUN = function(x) {
    paste0("ID", x)
})


## Map
list1 <- list(mtcars[1:2, 1:3], iris[1:2, c(1, 2, 5)])
list2 <- list(mtcars[3:4, 1:3], iris[3:4, c(1, 2, 5)])

Map(rbind, x = list1, y = list2)

# using an anonymous function
Map(function(x, y) {
  rbind(x, y)
}, 
x = list1, y = list2)


## Exercises -----
##===========================================================
# 1. Consider the mtcars data set. Using lapply(), calculate the mean of all
#   variables in the data set.





# 2. Using lapply(), now also calculate the median, minimum and maximum of all
#   variables in the data set. The output for each variable should be a named
#   numeric vector which is rounded to 2 decimal digits.




# 3. Write a function that calculates the statistical mode. Use the function on 
#     all columns of (a) the mtcars data set and (b) of the airquality data set.





# 4. Consider the following list of data.frames. Each data.frame represents a 
#   rater who has rated various kindergarten kids regarding their behavior.
#   Use Map() to append the data.frame name to each data.frame, then use
#   do.call(rbind, ...) to create a single data.frame with all information.
rater1 <- data.frame(ID = 1:3, 
                     nice = c(1, 3, 2),
                     help = c(4, 2, 1))
rater2 <- data.frame(ID = 4:6, 
                     nice = c(3, 3, 1),
                     help = c(2, 4, 3))
rater_list <- list(rater1 = rater1, rater2 = rater2)





# 5. Read the Pisa data. Inspect the data using View(), str(), summary(),...
#    We have the hypothesis that parental education (pared) has an effect on 
#    the number of books at home (books). Use the split-apply-combine paradigm
#    to make a table that lists the coefficients of a glm() for each school type
#    (schtype)
?split
?glm

pisa <- readRDS("data//pisaPlus_CF.RDS")




