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



## Exercises -----
##===========================================================
# 1. Consider the mtcars data set. Using lapply(), calculate the mean of all
#   variables in the data set.

lapply(mtcars, mean)


# 2. Using lapply(), now also calculate the median, minimum and maximum of all
#   variables in the data set. The output for each variable should be a named
#   numeric vector which is rounded to 2 decimal digits.

lapply(mtcars, function(x) {
  out <- c(mean = mean(x),
    median = median(x),
    min = min(x),
    max = max(x))
  round(out, 2)
})


# 3. Write a function that calculates the statistical mode. Use the function on 
#     all columns of (a) the mtcars data set and (b) of the airquality data set.

calc_mode <- function(x) {
  ux <- unique(x)
  which_max <- which.max(tabulate(match(x, ux)))
  ux[which_max]
}

lapply(mtcars, calc_mode)
lapply(airquality, calc_mode)



# 4. Consider the following list of data.frames. Each data.frame represents a 
#   rater who has rated various kindergarden kids regarding their behaviour.
#   Use Map() to append the data.frame name to each data.frame, then use
#   do.call(rbind) to create a single data.frame with all information.

rater1 <- data.frame(ID = 1:3, 
                     nice = c(1, 3, 2),
                     help = c(4, 2, 1))
rater2 <- data.frame(ID = 4:6, 
                     nice = c(3, 3, 1),
                     help = c(2, 4, 3))
rater_list <- list(rater1 = rater1, rater2 = rater2)

out_list <- Map(function(dat, name_rater) {
  dat[, "rater_name"] <- name_rater
  dat
}, dat = rater_list, name_rater = names(rater_list))
do.call(rbind, out_list)




# 5. Read the Pisa data. Inspect the data using View(), str(), summary(),...
#    We have the hypothesis that parental education (pared) has an effect on 
#    the number of books at home (books). Use the split-apply-combine paradigm
#    to make a table that lists the coefficients of a glm() for each school type
#    (schtype)
?split
?glm

pisa <- readRDS("data//pisaPlus_CF.RDS")

# split data according to school type
pisa_school <- split(pisa, pisa$schtype)

# a wrapper for glm()
do_glm <- function(data, formula, ...) glm(formula, data = data, ...)

# apply the wrapper to the split data
results_split <- lapply(pisa_school, do_glm, 
                        formula = as.factor(books) ~ pared, 
                        family = binomial)

# combine results
do.call(rbind, lapply(results_split, coef))


