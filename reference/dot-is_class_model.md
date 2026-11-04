# Is the fitted model a class model or a rank model?

The biclustering family can be either: `method = "B"` gives latent
classes, `method = "R"` (Ranklustering) gives latent ranks, and the
object's class is the same in both cases. exametrika records which one
in `msg` ("Class" or "Rank"), so that is what decides here. Every other
model is one or the other by construction, and `class_models` lists the
class ones.

## Usage

``` r
.is_class_model(data, class_models)
```

## Arguments

- data:

  A fitted exametrika object (already validated).

- class_models:

  Character vector of classes that are class models.

## Value

TRUE for a class model, FALSE for a rank model.
