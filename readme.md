# r-workshops-statcounter

This is the R project for the R workshop "Downloading browser statistics from statcounter".

## Setup

Clone the project from GitHub, or alternatively just download the zip.

```zsh
git clone https://github.com/ft-interactive/r-workshops-statcounter
```

Navigate into the project directory, open `r-workshops-statcounter.Rproj`, and restore the environment. 

To do this, first make sure you have `renv` installed.

```r
install.packages("renv")
```

Then activate `renv`.

```r
renv::activate()
```

Then install the packages for the project with `renv::restore()`.

```r
renv::restore()
```

