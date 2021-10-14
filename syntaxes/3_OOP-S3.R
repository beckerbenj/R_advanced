# Advanced Programming with R
# Zurich R Courses, October 2021


# R Object Oriented Programming - S3
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Input
#===========================================================

# useful functions
#...........................
?class
?structure
?methods
?getS3method



# create an S3 class
#...........................
# dirty way:
my_object <- list(a = 1, b = 2)
class(my_object) <- "my_class"
str(my_object)

# using a constructor funciton 
my_class <- function(a, b = 0L) {
  if(!is.integer(b)) stop("'b' should be an integer.")
  if(length(a) != length(b)) stop("'a' and 'b' should have the same length.")
  structure(list(a = a, b = b),
            class = "my_class")
}
my_object <- my_class(a = 1, b = 2L)
str(my_object)


# create an method for an existing generic
#.........................................
summary.my_class <- function(object, new_argument = "default", ...){
  cat("new_argument =", new_argument, "\n")
  data.frame(a = object$a, b = object$b)
}

summary(my_object)

# works, but not good practice
print.my_class <- function(object){
  cat("print my_class: \n")
  cat("\t a =", object$a,  "\n")
  cat("\t b =", object$b,  "\n")
}

print(my_object)

# works, and good practice
print.my_class <- function(x, ...){
  cat("print my_class: \n")
  cat("\t a =", x$a,  "\n")
  cat("\t b =", x$b,  "\n")
}

print(my_object)


# no restrictions on bad programming
#.........................................
my_object <- list(a = 1:5, b = seq(2, 0))
summary(my_object)
class(my_object) <- "my_class"

# compare to
my_object <- my_class(a = 1:5, b = seq(2, 0))


# create a new generic 
#......................
new_generic <- function(object, ...)
  UseMethod("new_generic")

new_generic.data.frame <- function(object, ...){
  cat("This code does nothing. \n")
  object
}

new_generic.my_class <- function(object, ...){
  cat("This code simply returns a data.frame. \n")
  summary(object, ...)
}

new_generic.default <- function(object, ...){
  cat("This code returns the object invisibly. \n")
  invisible(object)
}


new_generic(head(iris))
my_object <- my_class(a = c("some", "words"), b = c(5L, 1L))
new_generic(my_object)
new_generic(my_object, new_argument = "this is passed through")
new_generic(5)
(new_generic(5))


# List methods
#...........................
# for a generic
print_methods <- methods(generic = "print")
length(print_methods)
head(print_methods)

# for a class
methods_for_glm <- methods(class = "glm")
length(methods_for_glm)
head(methods_for_glm)


# packages contain ofte contain methods (for new classes)
#.......................................................
# for a generic
methods(generic = "anova")
library(lme4)
methods(generic = "anova")



# Inspect the source code
#...........................
methods(generic = "anova")
methods(generic = "summary")
anova.loess  # does not work




# visible functions
summary.lm

# invisible functions - indicated with an asterix
anova.lm
getS3method("anova", "lm")
getAnywhere("anova.lm")
stats:::anova.lm




# Exercises
#===========================================================

# 1. The round() function can be annoying to use with data.frames.
round(iris)
#    As a first step, write a function round_DF that rounds only
#    the numeric columns in a data frame
#
#    Create a generic function Round() that dispatches 
#    Round.<class> methods
#
#    Add a default method that does the same as round
# 
#    Add a methods for data.frames, that does the same as round_DF






# 2. Create a drop_NA generic including a default method. The return object 
#    should be of class "no_NA", and should have no NA values (i.e., the NA 
#    values are dropped). In addition, it should have the following attributes: 
#     - which_NA = an integer vector with the indices of the NA values in the 
#                  original vector
#     - the original attributes of the vector
#
#    Add a print-method for the "no_NA" class so to get the following results.

set.seed(415)
x <- sample(1:3, 20, replace = TRUE)
x[c(2, 6:8, 13, 16:18)] <- NA
drop_NA(x)
#  'No NA'-version. 
#  8 NA values were dropped. 
#  [1] 2 2 2 2 3 1 3 3 3 2 1 1
#
mean(drop_NA(x))
#  [1] 2.083333

fac <- factor(x, labels = c("one", "two", "three"))
drop_NA(fac)
#  'No NA'-version. 
#  8 NA values were dropped. 
#  [1] two   two   two   two   three one   three three three two   one   one  
#  Levels: one two three
#
nlevels(drop_NA(fac))
#  [1] 3





#    Create a restore_NA generic with a default method and a method for 
#    class "no_NA", that restores the original vector. Reproduce the following
#    output
restore_NA(x)
#  NA values can only be restored for class 'no_NA'
#
restore_NA(drop_NA(x))
#  [1]  2 NA  2  2  2 NA NA NA  3  1  3  3 NA  3  2 NA NA NA  1  1
#
restore_NA(drop_NA(fac))
#  [1] two   <NA>  two   two   two   <NA>  <NA>  <NA>  three one   three three <NA> 
#  [14] three two   <NA>  <NA>  <NA>  one   one  
#  Levels: one two three




# 3. Look at your own R code and projects. Where could you make use of
#    S3 classes and methods?
#     - Define a new class
#     - add method(s) for existing generics
#     - create a generic and add a methods for the new class
