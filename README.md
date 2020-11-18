This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown). Please see the page "Get Started" at https://bookdown.org/ for how to compile this example.


## Build image

```
docker build -t book_all .
```

or 

```
make image
```

## Run container

```

```

## Errors

* `Error: (converted from warning) packages ‘ElemStatLearn’,  are not available (for R version 3.6.3)`.
> Fixed by adding `ElemStatLearn` repository to `Remotes`, and then include it in `Imports`


## Tips

1. How to import BioConductor packages in DESCRIPTION?

