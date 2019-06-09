
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mbar

[![Travis build
status](https://travis-ci.org/rsquaredacademy/mbar.svg?branch=master)](https://travis-ci.org/rsquaredacademy/mbar)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/rsquaredacademy/mbar?branch=master&svg=true)](https://ci.appveyor.com/project/rsquaredacademy/mbar)
[![Coverage
status](https://codecov.io/gh/rsquaredacademy/mbar/branch/master/graph/badge.svg)](https://codecov.io/github/rsquaredacademy/mbar?branch=master)

> Helper functions used in our online R courses

## Installation

``` r
# Install development version from GitHub
# install.packages("devtools")
devtools::install_github("rsquaredacademy/mbar")
```

## Usage

### Data pre-processing for Market Basket Analysis

<img src="mba_pre_process.png" width="100%" style="display: block; margin: auto;" />

<br>

`mbar_prep_data()` will modify the data from one row per item to one row
per transaction. It takes 3 inputs:

  - data set
  - invoice number column
  - product/item column

<!-- end list -->

``` r
# original data
head(mba_sample)
#>   InvoiceNo StockCode                         Description Quantity
#> 1    536365    85123A  WHITE HANGING HEART T-LIGHT HOLDER        6
#> 2    536365     71053                 WHITE METAL LANTERN        6
#> 3    536365    84406B      CREAM CUPID HEARTS COAT HANGER        8
#> 4    536365    84029G KNITTED UNION FLAG HOT WATER BOTTLE        6
#> 5    536365    84029E      RED WOOLLY HOTTIE WHITE HEART.        6
#> 6    536365     22752        SET 7 BABUSHKA NESTING BOXES        2
#>           InvoiceDate UnitPrice CustomerID        Country
#> 1 2010-12-01 08:26:00      2.55      17850 United Kingdom
#> 2 2010-12-01 08:26:00      3.39      17850 United Kingdom
#> 3 2010-12-01 08:26:00      2.75      17850 United Kingdom
#> 4 2010-12-01 08:26:00      3.39      17850 United Kingdom
#> 5 2010-12-01 08:26:00      3.39      17850 United Kingdom
#> 6 2010-12-01 08:26:00      7.65      17850 United Kingdom

# modified data
mbar_prep_data(mba_sample, InvoiceNo, Description)
#> # A tibble: 66 x 85
#>    item_1 item_2 item_3 item_4 item_5 item_6 item_7 item_8 item_9 item_10
#>    <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  <chr>  
#>  1 WHITE~ WHITE~ CREAM~ KNITT~ RED W~ SET 7~ GLASS~ ""     ""     ""     
#>  2 HAND ~ HAND ~ ""     ""     ""     ""     ""     ""     ""     ""     
#>  3 ASSOR~ POPPY~ POPPY~ FELTC~ IVORY~ BOX O~ BOX O~ BOX O~ HOME ~ LOVE B~
#>  4 JAM M~ RED C~ YELLO~ BLUE ~ ""     ""     ""     ""     ""     ""     
#>  5 BATH ~ ""     ""     ""     ""     ""     ""     ""     ""     ""     
#>  6 ALARM~ ALARM~ ALARM~ PANDA~ STARS~ INFLA~ VINTA~ SET/2~ ROUND~ SPACEB~
#>  7 PAPER~ ""     ""     ""     ""     ""     ""     ""     ""     ""     
#>  8 HAND ~ HAND ~ ""     ""     ""     ""     ""     ""     ""     ""     
#>  9 WHITE~ WHITE~ CREAM~ EDWAR~ RETRO~ SAVE ~ VINTA~ VINTA~ WOOD ~ WOOD S~
#> 10 VICTO~ ""     ""     ""     ""     ""     ""     ""     ""     ""     
#> # ... with 56 more rows, and 75 more variables: item_11 <chr>,
#> #   item_12 <chr>, item_13 <chr>, item_14 <chr>, item_15 <chr>,
#> #   item_16 <chr>, item_17 <chr>, item_18 <chr>, item_19 <chr>,
#> #   item_20 <chr>, item_21 <chr>, item_22 <chr>, item_23 <chr>,
#> #   item_24 <chr>, item_25 <chr>, item_26 <chr>, item_27 <chr>,
#> #   item_28 <chr>, item_29 <chr>, item_30 <chr>, item_31 <chr>,
#> #   item_32 <chr>, item_33 <chr>, item_34 <chr>, item_35 <chr>,
#> #   item_36 <chr>, item_37 <chr>, item_38 <chr>, item_39 <chr>,
#> #   item_40 <chr>, item_41 <chr>, item_42 <chr>, item_43 <chr>,
#> #   item_44 <chr>, item_45 <chr>, item_46 <chr>, item_47 <chr>,
#> #   item_48 <chr>, item_49 <chr>, item_50 <chr>, item_51 <chr>,
#> #   item_52 <chr>, item_53 <chr>, item_54 <chr>, item_55 <chr>,
#> #   item_56 <chr>, item_57 <chr>, item_58 <chr>, item_59 <chr>,
#> #   item_60 <chr>, item_61 <chr>, item_62 <chr>, item_63 <chr>,
#> #   item_64 <chr>, item_65 <chr>, item_66 <chr>, item_67 <chr>,
#> #   item_68 <chr>, item_69 <chr>, item_70 <chr>, item_71 <chr>,
#> #   item_72 <chr>, item_73 <chr>, item_74 <chr>, item_75 <chr>,
#> #   item_76 <chr>, item_77 <chr>, item_78 <chr>, item_79 <chr>,
#> #   item_80 <chr>, item_81 <chr>, item_82 <chr>, item_83 <chr>,
#> #   item_84 <chr>, item_85 <chr>
```

### Optimal Complexity Parameter

`optimal_cp()` will extract the optimal complexity parameter from an
object of class `rpart` for pruning a tree.

``` r
# grow tree
model   <- rpart::rpart(Species ~ ., data = iris)
best_cp <- optimal_cp(model)

# prune tree
rpart::prune(model, cp = best_cp)
#> n= 150 
#> 
#> node), split, n, loss, yval, (yprob)
#>       * denotes terminal node
#> 
#> 1) root 150 100 setosa (0.33333333 0.33333333 0.33333333)  
#>   2) Petal.Length< 2.45 50   0 setosa (1.00000000 0.00000000 0.00000000) *
#>   3) Petal.Length>=2.45 100  50 versicolor (0.00000000 0.50000000 0.50000000)  
#>     6) Petal.Width< 1.75 54   5 versicolor (0.00000000 0.90740741 0.09259259) *
#>     7) Petal.Width>=1.75 46   1 virginica (0.00000000 0.02173913 0.97826087) *
```

Please note that the ‘mbar’ project is released with a [Contributor Code
of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you
agree to abide by its terms.
