# lispski

To run: open a REPL in SBCL and run the following commands:

```commonlisp
  (require 'asdf)
  (load "lispski.asd")
  (asdf:load-system :lispski)
  (in-package :lispski)
  (ski-repl)  ; Will run the actual repl for you
```

Example interaction:

```
> sksk
K
> ski(kis)
I
> skik
K
> ks(i(sksi))
S
```
