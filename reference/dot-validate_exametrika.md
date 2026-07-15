# Validate an exametrika object and return the matched model class

Internal validation used by all plot functions. The object must inherit
from "exametrika" and carry at least one of the model classes in
`valid_classes`. Using `%in%` on `class(data)` against the candidate set
(and not the other way around) keeps the check robust when the parent
package adds extra classes to its outputs.

## Usage

``` r
.validate_exametrika(data, valid_classes)
```

## Arguments

- data:

  Object to validate.

- valid_classes:

  Character vector of acceptable model classes.

## Value

The first matched model class (character scalar), invisibly usable for
dispatching on the model type.
