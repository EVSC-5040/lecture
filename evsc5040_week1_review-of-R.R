# EVSC 5040 – Advanced Ecological Data Analysis
# Max Castorani, University of Virginia (castorani@virginia.edu)

# ===================================================================================================
# WEEK 1: Review of data manipulation, exploration, and visualization in R
# ===================================================================================================

# ---------------------------------------------------------------------------------------------------
# REVIEW OF PROGRAMMING IN R


# ---------------------------------------------------------------------------------------------------
# R packages

# Install package
install.packages('ggplot2')

# Load package
library(ggplot2)

# View installed packages
installed.packages()


# ---------------------------------------------------------------------------------------------------
# Working environment

# Find the working directory
getwd()

# Set the working environment (modify this with your own working environment)
setwd("/Users/castorani/Sync/Documents/Teaching/UVA/Analyzing Messy Environmental Data in R/2018 Fall - Analyzing messy data/Code") 


# ---------------------------------------------------------------------------------------------------
# Getting help

# Help on a function
?getwd
help(getwd)
example(getwd)


# ---------------------------------------------------------------------------------------------------
# Importing and exporting data

# Read in a comma-delineated file (CSV)
read.csv("evsc5559_week1.csv")
dat <- read.csv("evsc5559_week1.csv")  # Create as an object

# Save as an R data file
save(dat, file = "temp.RData")

# Load R data files
load(file = "temp.Rdata")

# View objects in the working environment
ls()


# ---------------------------------------------------------------------------------------------------
# Vectors

# Create a vector (technically, we are concatenateing objects, hence the command "c")
a <- c(1, 3, 5, 7, 11, 13, 17, 19, 23, 27)
a

# Create a sequence
b <- seq(from = 0, to = 100, by = 10)
b <- seq(0, 100, 10)
b

# Generate random numbers: Sample from a uniform distribution
r <- sample(x = 0:100, size = 25, replace = TRUE)
r

# Replicate objects
r0 <- rep("All work and no play makes Jack a dull boy", times = 100)
r0

r1 <- rep(7, times = 100)
r1

r2 <- rep(1:3, times = 100)
r2

r3 <- rep(1:3, each = 100)
r3 


# ---------------------------------------------------------------------------------------------------
# Basic mathematical commands

# Arithmetic
7 - 5
1 + 5
2 * 2
3 / 5

# Simple statistics
min(a)     # Minimum
max(a)     # Maximum
range(a)   # Range
sum(a)     # Sum
mean(a)    # Arithmetic mean
sd(a)      # Standard deviation
length(a)  # Length (how many entries in this vector or list?)
table(r3)  # Count the number of unique entries in an object
unique(a)  # What are the unique values in the vector?

# Other mathematical commands
exp(0.45)
log(1.54)
sqrt(25)

# Rounding
round(c(1.7, 2.1, 3.0))
floor(c(1.7, 2.1, 3.0))
ceiling(c(1.7, 2.1, 3.0))

# ---------------------------------------------------------------------------------------------------
# Lists and list structure

# Create a list
l <- list("vector.a" = a, "vector.b" = b)
l

# Check the structure of an object (such as a list)
class(l)
structure(l)
str(l)

# ---------------------------------------------------------------------------------------------------
# Characters
char1 <- "How soon can I drop this class?"
char1
class(char1)

d1 <- "How"
d2 <- "soon can"
d3 <- "I drop this class?"

char2 <- paste(d1, d2, d3, sep = " ")
char2

# ---------------------------------------------------------------------------------------------------
# Factors

birds1 <- c("bluebird", "bluejay", "cardinal", "carolina.creeper", "crow", "osprey", 
           "raven", "redtail.hawk", "sparrow", "swallow", "unidentified", "vulture")
class(birds1)

birds2 <- factor(birds1)
class(birds2)
str(birds2)
levels(birds2)  # What are the levels (in order) of a factor?

# ---------------------------------------------------------------------------------------------------
# Logicals

# Equalities
char1 == char2
char1 == d1
10 != 5 

# Inequalities
1 > 0
1 < 0
25 <= 5 * 5

# Check class of an object
is.numeric(365)
is.numeric(NA)
is.character(birds1)
is.factor(birds2)

# Alphabet
letters
LETTERS

paste(LETTERS[13], letters[1], letters[24], sep = "")

# ---------------------------------------------------------------------------------------------------
# Matrices and data frames
m <- matrix(letters[1:16], nrow = 4, ncol = 4, byrow = TRUE)
m

m <- matrix(1:16, nrow = 4, ncol = 4, byrow = FALSE)
m

m <- matrix(1:16, nrow = 4, ncol = 4, byrow = TRUE, dimnames = list(letters[1:4], LETTERS[1:4]))
m

# Row names and column names
rownames(m)
colnames(m)

# ---------------------------------------------------------------------------------------------------
# "Indexing": Returning part of a vector, matrix, data frame, or list
m        # Return the whole matrix
m[]      # Return the whole matrix
m[ , ]    # Return the whole matrix

m[16]    # Return the 16th element of the matrix
m[, 1]   # Return all rows and the first column
m[1, ]   # Return the first row and all columns
m[4, 4]  # Return the element in the 4th row and 4th column

m["b", ] # Return the row called "b"

# Return all values that satisfy criteria
m[m > 10]
m[m > 10 & m < 12]
m[m < 5 & m > 10]  # Obviously this won't work
m[m < 5 | m > 10]  # The vertical bar can be read as "or"

l[1]
l["vector.a"]
l[[1]]
l[["vector.a"]]
l$vector.a

# ---------------------------------------------------------------------------------------------------
# Manipulating a data object

# Row-bind and column-bind
column.1 <- m[, 1] 
column.2 <- m[, 2]
column.3 <- m[, 3]

rbind(column.1, column.2, column.3)
cbind(column.1, column.2, column.3)

cbind(m, column.3, column.3, column.1)

# Convert between matrices and data frames (or between other object types)
df <- as.data.frame(m)
class(df)

# Sort the elements of a vector from largest to smallest or vice versa
sort(dat[, 1], decreasing = TRUE)
sort(dat[, "y"], decreasing = FALSE)

# Return the order of a vector if the elements were to be sorted from largest to smallest or vice versa
order(dat[, 1], decreasing = TRUE)
order(dat[, "y"], decreasing = FALSE)

# Reverse the order of a vector
r3
rev(r3)

# Transpose a matrix or data frame
m
t(m)


# ---------------------------------------------------------------------------------------------------
# Time and dates

# Current date and time
Sys.time()


# ---------------------------------------------------------------------------------------------------
# Remove objects
remove(a)
a

rm(b)
b

# Remove all objects from the working environment
rm(list = ls())

