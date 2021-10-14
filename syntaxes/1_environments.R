# Advanced Programming in R
# Zurich R Courses, October 2021


# Environments and scoping
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Useful functions -----
## __________________________________________________________________________

?environment  
environment()   # returns the current evaluation environment
?ls             # returns the objects in the current environment
parent.env()    # returns the enclosing environment
new.env()       # creates a new environment (with as the current environment 
# as the enclosing environment)
globalenv()     # returns the global environment
empty.dump()    # returns the empty environment

?rlang::env()   # creates a new environment (with as the current environment 
# as the enclosing environment)



## Create an environment
env1 <- new.env()
env1$a <- 15     

## add objects to environment
env1$fast_mean <- function(x) sum(x)/length(x)
env1$myself <- env1   # an environment can contain itself

env1
ls(env1)
names(env1)


## using rlang package
env2 <- rlang::env(a = 15, 
                   fast_mean = function(x)sum(x)/length(x),
                   env1 = env1)
rlang::env_print(env2)
rlang::env_names(env2)


## Reference Semantics & modification in place
# how lists work
original_l <- list(a = 15, b = "original", c = mean)
copy_l <- original_l
copy_l$b <- "new"
c(original_l$b, copy_l$b)
original_l$a <- NULL
names(original_l)


# how environments work
original_e <- rlang::env(a = 15, b = "original", c = mean)
copy_e <- original_e
copy_e$b <- "new"
c(original_e$b, copy_e$b)
original_e$a <- NULL
names(original_e)


# environments are unordered
original_e[[3]]          # fails!
original_e[["c"]]
original_e[c("a", "c")]  # fails! 


## enclosing environments
parent.env(env1)
parent.env(env1$myself)
parent.env(env1$myself$myself)
parent.env(env1) <- env2
parent.env(env1)
rlang::env_print(env1$myself$myself$myself$myself)


# set enclosing environment using rlang::new_environment()
env3 <- rlang::new_environment(
  list(b = "b", 
       c = 1:5,
       data = airquality),
  parent = env2)
rlang::env_parent(env3)
env3


# lexical scoping: search through environments
# ctrl + shift + F10
env1 <- new.env(parent = emptyenv())
env2 <- new.env(parent = env1)
env3 <- new.env(parent = env2)

env1$a <- "a"
env2$b <- "b"
env3$c <- "c"


ls(env1)
ls(env2)
ls(env3)


exists("a", envir = env3)
exists("a", envir = env2)
exists("a", envir = env1)

exists("c", envir = env3)
exists("c", envir = env2)
exists("c", envir = env1)

exists("a", envir = env3, inherits = FALSE)
exists("a", envir = env2, inherits = FALSE)
exists("a", envir = env1, inherits = FALSE)



# get looks in the environment, when inherits = TRUE, the search continues
#   in the enclosing environment (and so on)
get("a", envir = env3)
get("a", envir = env2)
get("a", envir = env1)

get("a", envir = env3, inherits = FALSE)


# assign assigns a name/reverence to an object in a specific environment.
#   when inherits = TRUE, assign tries to replace the object looking in 
#   the chain of enclosing environments. If the name is not 
#   found, the assignment is done in the global environment

ls(env1)
ls(env3)

assign("d", "new object", envir = env3)
ls(env3)

assign("a", "replaced", envir = env3, inherits = TRUE)
get("a", env1)

assign("e", "another new", envir = env3, inherits = TRUE)
find("e")

# <<- is similar to assign(inherits = TRUE)



# search path
search()
rlang::search_envs()



## The environment that binds the function
add_10 <- function(x) x + 10
find("add_10")
find("sd")


# An object can have references in more than one environment
sd <- sd
find("add_10")
find("sd")


## The execution environment
?environment()
get_executing_env <- function() return(environment(NULL))
get_executing_env()
get_executing_env()  # always new


## The calling environment
?parent.frame
print_calling_env <- function() parent.frame()
print_calling_env()
other_fun <- function() print_calling_env()
other_fun()

# the call stack
?sys.calls()
print_calling_funs <- function() sys.calls()
print_calling_funs()
other_fun <- function() print_calling_funs()
other_fun()


## The enclosing environment
get_enclosing_env <- function() parent.env(environment())
get_enclosing_env()

# The enclosing environment can contain objects
make_adder <- function(add = 0) {
  print(environment())
  return(function(x) x + add)}
add_5 <- make_adder(5)
environment(add_5)
add_5(1)
ls(environment(add_5))
add_5
get("add", envir = environment(add_5))


# The enclosing environment can be set
strange_mean <- function(x, ...) mean(x, ...)
strange_mean(1:3)
env1 <- rlang::env(mean = function(x, ...) "Strange!")
environment(strange_mean) <- env1
strange_mean(1:3)



## Exercises ----
## __________________________________________________________________________


# 1. Check which objects are in the following environments, and check their
#    enclosing environment
#    - the global environment
#    - the stats-package environment
#    - the stats-namespace environment
#    - the imports environment of the stats package
#    - the empty environment

# global environment



# package:stats environment 



# namespace:stats environment



# imports:stats environment



# empty environment




# 2. Create a new environment called e1 which contains the following objects:
#    number <- 3
#    print_number <- function() cat(number, "\n")
#    - try the function, does it work? 
#    - check what the enclosing environment of the function is. 
#    - change the enclosing environment of the function to the e1 environment
#    - does the function work?
#    - copy the print_number function to the global environment: print_number_global
#    - does print_number_global work?
#    - check what the enclosing environment of the print_number_global is. 




# 3. Run the following code. Explain why the R finds all objects in the 
#    return object

a <- b <- c <- d <- e <- 5
create_fun <- function(){
  a <- b <- c <- d <- 5
  return(function(a = 3, b = 3, c = 3){
    a <- 1
    c(a = a, b = b, c = c, d = d, e = e)
  })
}
fun <- create_fun()
fun(a = 2, b = 2)




# 4. write a function that creates an environment. Use two arguments: 
#    - ... = named objects
#    - enclosing_env = an environment or "self"
# TIP: make use of list2env, ... and list(...)
#
#    Use the function you wrote to repeat exercise 2.





# Advanced exercises



# 5. write a set_enclosing_env function that can set the enclosing environment
#    both for a function and for an environment
# TIPS: 
#    - `environment<-` sets the enclosing environment of a function
#    - `parent.env<-` sets the enclosing environment of an environment






# 6. You can jump from environment to environment via the link (i.e., to the 
#    enclosing environment). Write a loop that prints all the enclosing 
#    environments of an environment, until the empty environment is reached. 
#    Alternatively, write a recursive function that returns a list with the 
#    enclosing environments of an environment
# Tips: 
#    - for the function, make use of the fact that environments are modified 
#      in place







# 7. Modify the function you wrote in exercise 6, so that it also lists the
#    the enclosing environments of a function
#    try out the function





# 8. Write a recursive function that returns the binding environment of 
#    a function
#    TIP: use ?exists
#
#    
#    use the function to find the binding environment of the var() function.
#    debug the sd() function, and while debugging find the binding environment
#    of the var() function.
#    
#    compare your function with find()

