# Class 9

## Type Systems

The compiler or interpreter of a programming language defines a mapping
of the values that a program computes onto the representation of these
values in the underlying hardware (e.g. how floating point numbers are
mapped to sequences of bits). A *type* describes a set of values that
share the same mapping to the low-level representation and the same
operations that perform computations on those values.

More generally, one can take different view points of what types are:

* *Denotational* view:
  * a type is a set *T* of values (e.g. the Scala type `Int` denotes
    the set of all integer values)
  * a value has type *T* if it belongs to the set
  * an expression has type *T* if it always evaluates to a value in *T*

* *Constructive* view:
  * a type is either a built-in primitive type (`int`, `real`, `bool`,
    `char`, etc.) or
  * a composite type constructed from simpler types using a
    *type-constructor* (record, array, set, etc.)
  
* *Abstraction-based* view:
  * Type is an *interface* consisting of a set of operations.

Types serve several purposes in programming languages:

* *Detecting Errors*: an important purpose of types is for detecting
  *run-time errors* related to the usage of operations on values they
  are not meant to be used on. For example, consider the following
  OCaml program:
  
  ```ocaml
  let f x = 1 + x in
  f "hello"
  ```
  
  This program is rejected by the type checker of the compiler because
  `f` expects an argument of type `int` but we call it with the string
  `"hello"`.
  
  If this program were not rejected by the compiler, then at the point
  when `1 + "hello"` is executed the program would likely crash or at
  the very least compute a meaningless result value because `+`
  expects two integers as argument and not an integer and a string
  because the low-level representation of integers and strings are
  incompatible.
  
  By using static type checking, we can detect these kinds of errors
  already at compile-time. In general, the earlier errors are
  detected, the easier and cheaper it is to fix them.
  

* *Documentation*: Type annotations are also useful when reading
  programs. For instance, type declarations in function headers
  document constraints on the inputs that the functions assumes,
  respectively constraints on the return value that it guarantees:
  
  ```scala
  def f(x: Int): Int = x + 1
  ```

* *Abstraction*: Finally, types are often at the heart of module and
  class systems that help to structure large programs into smaller
  components. In particular, types help to abstract away
  implementation details of these components. In turn, this helps to
  enforce a disciplined programming methodology that ensures that
  changes to the internal implementation details of one module do not
  affect other modules in the program.

* *Enabling Compiler Optimization*: In general, the more the compiler
  knows about the behavior of a program, the more opportunities it
  will have to optimize the code. Types provide a way for the
  programmer to communicate information about the behavior of a
  program to the compiler, which can then be exploited for
  optimizations (e.g. by choosing more efficient memory
  representations for values or custom machine level instructions for
  operations on certain types of values).

The *type system* of a programming language is a mechanism for
defining types in the language and associating them with language
constructs (expressions, functions, classes, modules, etc.) as well
as a set of rules for answering questions such as

* *Type compatibility*: where can a value of a given type be used?

* *Type checking*: how do you verify that a value observed at run-time
  is compatible with a given type, respectively, how do you verify
  that an expression will only evaluate to values compatible with a
  given type?

* *Type inference*: how do you determine the type of an expression from
  the types of its parts?

* *Type equivalence*: when do two types represent the same set of
  values?
  
### Type Checking 

*Type checking* is the process of ensuring that a program obeys the
type system's type compatibility rules. A violation of the rules is
called a *type error* or *type clash*. A program that is free of type
errors is considered to be *well-typed*.

Languages differ greatly in the way they implement type
checking. These approaches can be loosely categorized into

* strong vs. weak type systems
* static vs. dynamic type systems

A *strongly typed* language does not allow expressions to be used in a
way inconsistent with their types (no loopholes). A strongly typed
language thus guarantees that all type errors are detected (either at
compile-time or at run-time). Examples of strongly typed languages
include Java, Scala, OCaml, Python, Lisp, and Scheme.

On the other hand, a *weakly typed* language allows many ways to
bypass the type system (e.g., by using pointer arithmetic or unchecked
casts). In such languages, type errors can go undetected, causing
e.g. data corruption and other unpredictable behavior when the program
is executed. C and C++ are poster children for weakly typed
languages. Their motto is: "Trust the programmer".

The other high-level classification is to distinguish between static
and dynamic type system. In a static type system, the compiler ensures
that the type rules are obeyed at compile-time whereas in dynamic type
systems, type checking is performed at run-time while the program
executes.

Advantages of static typing over dynamic typing:

* more efficient: code runs faster because no run-time type checks are
  needed; compiler has more opportunities for optimization because it
  has more information about what the program does.

* better error checking: type errors are detected earlier; compiler
  can guarantee that no type errors will occur (if language is also
  strongly typed).

* better documentation: easier to understand and maintain code.

Advantages of dynamic typing over static typing:

* less annotation overhead: programmer needs to write less code to
  achieve the same task because no type declarations and annotations
  are needed. This can be mitigated by automated type inference in
  static type systems.

* more flexibility: a static type checker may reject a program that is
  correct but does not follow the specific static typing discipline of
  the language. This can be mitigated by supporting more expressive
  types, which, however, comes at the cost of increasing the
  annotation overhead and the mental gymnastics that the programmer
  has to perform to get the code through the static type checker.
  
  
It is often considered easier to write code in dynamically typed
languages. However, as the size and complexity of a software system
increases, the advantages of dynamic typing turn into disadvantages
because type errors become harder to detect and debug. Hence,
statically typed languages are often preferred for large and complex
projects. Also, for performance critical code, dynamic typing is often
too costly (because it often involves expensive run-time type checks).

The distinction between weak/strong and static/dynamic is not always
clear cut. For instance, Java is mostly statically typed but certain
type checks are performed at run-time due to deliberate loopholes in
the static type checker. Some so-called *gradually typed* languages
(e.g. Dart, TypeScript) even allow the programmer to choose between
static and dynamic type checking for different parts of a single
program.

Similarly, the distinction between weak and strong type systems is not
always completely clear and some people use slightly different
definitions of what strong vs. weak typing means. For instance, the
notion of type compatibility in JavaScript is so permissive that the
language is often considered to be weakly typed, even though, according
to the definition given above, JavaScript is strongly typed.

### Type Inference

Type inference concerns the problem of statically inferring the type
of an expression from the types of its parts. All static type systems
perform some amount of type inference. For instance, consider the
following expression

```ocaml
1 + 2
```

Here, the static type checker can infer that the result of value must be
an integer value because the two operands are integer values, and hence
`+` is interpreted as integer addition.

The situation is more complicated if variables are involved:

```ocaml
x + y
```

In many languages, the operator `+` is overloaded and can mean
different things depending on the types of its operands. For instance,
in Scala and Java if `x` is a string, `+` is interpreted as string
concatenation. On the other hand, if `x` is a `Double` it is
interpreted as floating point addition, etc. This is one of the
reasons why Scala and Java require type annotations for the parameters
of functions, as the compiler needs this information to be able to
resolve which overloaded variant of an operator is meant in each case.

In languages without operator overloading, the types of expressions
like `x + y` can still be inferred automatically even if the types of
the variables `x` and `y` are not explicitly specified. For instance,
if `+` is not overloaded and always means integer addition, then the
expression can only be well-typed if both `x` and `y` are integer
values. One can thus infer the types of variables from how they
are used in the code. Enabling this kind of more general type
inference requires a carefully designed type system. The languages in
the ML family, which includes OCaml, support this feature.

### Type equivalence

Type equivalence concerns the question when two types are considered
to be equal (i.e. represent the same set of values). One distinguishes
two basic ways of how to define type equivalence: *nominal typing* and
*structural typing*:

* Nominal typing: two types are the same only if they have the same name
 (each type definition introduces a new type)
 
 * *strict*: aliases (i.e. declaring a type equal to another type) are distinct
 * *loose*: aliases are equivalent

* Structural typing: two types are equivalent if they have the same
  structure. That is, they are structurally identical when viewed as
  terms constructed from primitive types and type constructors.

Most languages use a mixture of nominal and structural typing. For
instance, in Scala, object types use nominal typing but generic types
use structural typing.

### Type compatibility

Type compatibility concerns the questions when a particular value (or
expression) of type `t` can be used in a context that expects a
different type `s`. From a denotational view of types this corresponds
to the question whether the values described by `t` are a subset of
the values described by `s`. This question is closely related to the
notion of subtyping in object-oriented languages.

However, more generally, type compatibility may also concern cases
where the representations of the values of the two types `t` and `s`
differ, but there is a natural conversion from `t` to `s`. For
instance, many languages allow integer values to be used in floating
point operations. E.g. consider the following `Scala` expression

```scala
1.3 + 1
```

Here, the `+` operator will be interpreted as an operation on `Double`
values because at least one of the operands is a double value. Hence,
both operands are expected to be of type `Double`. However, the second
operand is `1`, which is of type `Int`. The representations of `Int`
and `Double` values differ. Nevertheless, the expression is well-typed
according to Scala's typing rules: the type `Int` is compatible with
the type `Double`.

To account for the different representation of `Int` and `Double`
values, the compiler will generate code that performs an implicit
conversion of the `Int` value `1` to the `Double` value `1.0` (in this
case, the conversion can be done statically at compile-time but this
is not possible in general if e.g. `1` is replaced by an `Int`
variable). This kind of implicit conversion code is referred to as a
*type coercion*.

Determining if and when type coercions should be applied is a major
design aspect that distinguishes the type systems of different
programming languages.

We will start by studying these concepts related to types and type
systems in more detail in the context of OCaml and we will later
revisit typing-related issues in the context of object-oriented
languages such as Scala.

## OCaml's Type System

The type systems of ML-style languages to which OCaml belongs provide
strong static type checking while eliminating most of the overhead
that is normally associated with static type systems. In particular,
for the most part, the programmer does not need to provide any
explicit type annotations. Instead, the type checker of the compiler
can automatically infer these types by analyzing the syntactic
structure of the program. To this day, the languages in the ML family
occupy a unique sweet spot in the design space of type systems by
providing the benefits of static typing while retaining some of the
most important benefits of dynamically typed languages.

OCaml's type system is derived from the so-called Hindley-Milner type
system (also Damas-Hindley-Milner) or HM for short. HM is the
foundation of the type systems used by all languages in the
ML-family. 

### Polytypes and Monotypes

One distinguishing feature of HM is that it supports polymorphic
types, or *polytypes* for short. A type expression `t` is a polytype
if it contains type variables. We write type variables as letters
prefixed by a single quote (e.g. `'a` - pronounced "alpha"). 

Here are some examples of polytypes:

* `'a -> 'b`: Describes all functions that can take values of some
  arbitrary type `'a` and map them to some other arbitrary type `'b`.
* `'a -> 'a`: Describes all function that take values of some
  arbitrary type `'a` and map them to another value of that type.
* `'a -> int`: Describes all function that take a value of some
  arbitrary type `'a` and map them to an `int`.
* `'a list`: Describes all homogeneous lists storing values of some
  arbitrary type `'a`.
  
Type that do not contain any type variables such as `int -> int`, `int
-> bool`, etc. are called *monotypes* or *ground types*. 

### Type Compatibility and Unification

The first question we have to answer is how different types relate. A
value `v` of type `t` is compatible with type `s` if `v` can be used
in a context that expects a value of type `t`. In OCaml, this is true
whenever the type `t` is *more general* than the type `s`.  This
definition may seem counter-intuitive at first. However, it captures
the idea that a type `t` that is more general than another type `s`
denotes a smaller set of values than `s` and, hence, every value of
type `t` is also a value of type `s`.

For instance, the type `'a -> 'b` is more general than both `'a -> 'a`
and `int -> bool`. On the other hand, the types `'a -> int` and `'a ->
bool` are incompatible (i.e. neither is more general than the other)
because `int` and `bool` are two distinct types.

Before we precisely define how to determine whether one type is more
general than another type, let's see how this notion relates to
compatibility.  Consider the types `t = 'a -> int` and `s = int ->
int`, then `t` is more general than `s`. Now take the expression `f
3 + 1`. This expression expects `f` to be a function of type `int ->
int` because we are calling `f` with value `3` which is of type `int`
and we are using the result of the call in an addition operation which
also expects operands of type `int`. Now, if the actual type of `f` is
`'a -> int`, then this tells us that we can call `f` with any value we
like, including `int` values. Moreover, the result is always going to
be an `int`. Thus `f` also has type `int -> int` and it is safe to use
`f` in the expression `f 3 + 1`.

We can formalize this idea of when one type is more general than
another type using the notion
of
[*unification*](https://en.wikipedia.org/wiki/Unification_(computer_science)).
However, we first need to introduce a few technical terms to
understand this in detail.

A *substitution* σ for a type `t` is a mapping of the type variables
occurring in `t` to types. Example: a possible substitution for the
function type `'a -> 'b` is the mapping σ = `{'a ↦ int, 'b ↦
int}`. Another one is σ'=`{'a ↦ 'a, 'b ↦ 'b}`.

Applying a substitution σ to a type `t`, written `t`σ, results in the
type `t` where all occurrences of type variables have been replaced
according to σ. For instance, if `t` = `'a -> 'b` and σ = `{'a -> int,
'b -> int}`, then `t`σ = `int -> int`.

Two types `s` and `t` are said to be *unifiable* if there exists a
substitution σ for the type variables occurring in both `s` and `t`
such that `s`σ = `t`σ. The substitution σ is called a *unifier* for `s`
and `t`. Example: the (unique) unifier for `s = 'a -> int` and `t =
string -> 'b` is σ = `{'a ↦ string, 'b ↦ int}`. On the other hand,
there exists no unifier for `t = 'a -> int` and `s = string -> 'a`
because `string` and `int` are distinct types.

A type `t` is *more general* than a type `s` if there exists a unifier σ
for `t` and `s` such that `t`σ = `s`. Example: the type `'a -> 'b` is
more general than the type `int -> 'b`. On the other hand, `int -> 'b`
is not more general than `'a -> 'b` because there exists no
substitution σ such that `int -> 'b`σ = `'a -> 'b` (remember
substitutions can only replace type variables like `'a` and `'b` but
not primitive monotypes like `int`.

### Type Inference

One remarkable feature of OCaml's type system is the ability to
algorithmically infer the type `t` of any expression `e` and at the
same time check whether `e` is well-typed. This yields all the
benefits of a strong static type system without requiring the
programmer to provide explicit type annotations in the program.

The algorithm is guided by the syntax of expressions, taking advantage
of the fact that the constant literals, inbuilt operators, and value
constructors from which expressions are built impose constraints on
the types that the values of these expressions may have. Technically,
the algorithm works by deriving a system of type equality constraints
from every expression and then solving this constraint system by
computing a *most general unifier* that satisfies all the type
equalities simultaneously.

At a high-level, the algorithm can be summarized as follows. Given a
program expression `e` whose type is to be inferred, perform the
following steps:

1. Associate a fresh type variable with each subexpression occurring
   in `e`. These type variables should be thought of as placeholders
   for the actual types that we are going to infer.
   
2. Associate a fresh type variable with each free program variable
   occurring in `e`. These type variables are placeholders for the
   types of those program variables.

3. Generate a set of type equality constraints from the syntactic
   structure of `e`. These typing constraints relate the introduced
   type variables with each other and impose restrictions on the types
   that they stand for.

4. Solve the generated typing constraints. If a solution of the
   constraints exists (a unifier), the expression is well-typed and we
   can read off the types of all subexpressions (including `e` itself)
   from the computed solution. Otherwise, if no solution exists, `e` has
   a type error.

Rather than describing this algorithm formally, we explain it through
a series of examples. A complete description of the algorithm can be
found
[here](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system) as
well
as in
[Robin Milner's original article](https://www.sciencedirect.com/science/article/pii/0022000078900144/pdf?md5=cdcf7cdb7cfd2e1e4237f4f779ca0df7&pid=1-s2.0-0022000078900144-main.pdf). A
good textbook-treatment can be found in Ch. 22
of
[Types and Programming Languages.](https://www.cis.upenn.edu/~bcpierce/tapl/) by
Benjamin Pierce.

As a first example, let us consider the following OCaml expression `e`:

```ocaml
x + f 1
```

We perform the steps of the algorithm described above.

Step 1: associate a type variable with every subexpression of `e`:

```
x : 'a
f : 'b
1 : 'c
f 1 : 'd
x + f 1 : 'e
```

Step 2: associate a type variable with every free variable occurring in `e`:

`x: 'x`
`f: 'f`

Step 3: generate typing constraints by analyzing the syntactic
structure of the expression `e`.

From the top-level operator `+` in the expression `x + f 1` we can
infer that the types of the subexpressions `x` and `f 1` must both be
`int` because `+` assumes integer arguments in OCaml (floating point
addition is given by the operator `+.`). Moreover, we conclude that
the whole expression `e` must have type `int`, since `+` again
produces an integer value. Hence, we must have:

```
'a = int
'd = int
'e = int
```

Similarly, from the subexpression `f 1` whose top-level operation is a
function application, we can infer that the type of `f` must be a
function type whose argument type is the type of `1` and whose result
type is the type of `f 1`. That is, we must have:

`'b = 'c -> 'd`

Finally, we look at the leaf expressions `x`, `f`, and `1`. For `x`
and `f` we obtain the constraints relating the type variables
associated with those leaf expressions with the type variables
associated with the corresponding program variables:

```
'x = 'a
'f = 'b
```

The leaf expression `1` is an integer constant whose type
is `int`. Thus we have:

`'c = int`

Thus altogether, we have gathered the following constraints:

```
'a = int
'd = int
'e = int
'b = 'c -> 'd
'c = int
'x = 'a
'f = 'b
```
Step 4: solve the typing constraints.

Solving the constraints amounts to computing a unifier σ (a mapping
from type variables to types) such that when σ is applied to both
sides of each typing constraint makes the two sides syntactically
equal. If such a unifier does not exist, then this means that at least
one of the typing constraints cannot be satisfied, and there must be a
type error in the expression `e`. Otherwise, once we have computed the
unifier σ, we can read off the types of all the subexpressions of `e`
directly from σ.

The problem of finding a unifier for a set of typing constraints is
called a *unification problem*. We can compute a unifier σ from the
set of constraints using a simple iterative algorithm. The algorithm
starts with a trivial candidate solution σ₀ = ∅ and then processes the
equality constraints one at a time in any order, extending σ₀ to an
actual unifier of the whole set of constraints. If at any point, we
encounter a constraint that we cannot solve (e.g. `bool = int`), then
we abort and report a type error.

For our example, we process the constraints in the order given above,
starting with the constraint

`'a = int`

For each constraint, we first apply our current candidate unifier,
here σ₀, to both sides of the equality and then solve the resulting
new equality constraint. In our first iteration of this algorithm, σ₀
is the empty substitution, so applying σ₀ to the constraint does not
change the constraint. Thus, we solve

`'a = int`

Solving a single type equality constraint `t1 = t2` for arbitrary type
expressions `t1` and `t2` is done like this:

Case 1. If `t1` and `t2` are the exact same type expressions, then there is
  nothing to be done. We simply proceed to the next equality
  constraint using our current candidate unifier.

Case 2. If one of the two types `t1` and `t2` is a type variable, say
  `t1 = 'a`, then we first check whether `'a` occurs in `t2`. If it
  does, then there is no solution to the typing constraints and we
  abort with a type error. The is referred to as the "*occurs check*"
  (more on this case later). Otherwise, we extend the current
  candidate unifier with the mapping `'a ↦ t2` and additionally
  replace any occurrence of `'a` on the right side of a mapping in the
  current candidate unifier with `t2`.
  
Case 3. If `t1` or `t2` are both types constructed from the same type
  constructor, e.g., suppose `t1` is of the form `t11 -> t12` and `t2`
  is of the form `t21 -> t22`, then we simply replace the constraint
  `t1 = t2` with new constraints equating the corresponding component
  types on both sides: `t11 = t21` and `t12 = t22`. Then we proceed
  with the new set of constraints and our current candidate unifier.
  
Case 4. In all other cases, we must have a type mismatch. That is, `t1` and
  `t2` must be both types constructed from some type constructor and
  those type constructors must be different. Hence, the two types
  cannot be made equal no matter what unifier we apply to them. Note
  that we can view primitive types like `int` and `bool` as type
  constructors that take no arguments. So a type mismatch like `int =
  bool` is also covered by this case.
  
In our example, the second case applies. Hence we extend σ₀ to 

σ₁ = { `'a ↦ int` }

and proceed to the next constraint. The next two constraints

```
'd = int
'e = int
```

are similar to the first one and we just update the candidate unifier
to:

σ₃ = { `'a ↦ int`, `'d ↦ int`, `'e ↦ int` }

The next constraint is

`'b = 'c -> 'd`

we apply σ₃ on both sides and obtain

`'b = 'c -> int`

and then update our candidate solution to

σ₄ = { `'a ↦ int`, `'d ↦ int`, `'e ↦ int`, `'b ↦ 'c -> int` }

After processing the remaining three constraints 

```
'c = int
'x = 'a
'f = 'b
```

we obtain the following solution

σ = { `'a ↦ int`, `'d ↦ int`, `'e ↦ int`, `'b ↦ int -> int`, 
      `'c ↦ int`, `'x ↦ int`, `'f ↦ int -> int` }

Note that if we apply σ to all the original constraints derived from
`e`, then we observe that σ is indeed a correct solution of the constraint system:
```
int = int
int = int
int = int
int -> int = int -> int
int = int
int = int
int = int
```

Moreover, we can now read off the inferred types for all
subexpressions in `e` directly from σ. For instance, we have σ(`'e`) =
`int`, indicating that the type of expression `e` itself is
`int`. Similarly, the inferred types for the variables `x` in `e` is
σ(`'x`)=`int`, and the type of variable `f` is σ(`'f`)=`int ->
int`. Thus, we had e.g. a larger expression that defines a function
`g` in terms of the expression `e` like this:

```ocaml
let g x f = x + f 1
```

then we can immediately conclude that the type of `g` must be

`g: int -> (int -> int) -> int`

#### Detecting Type Errors

In the previous example, the type inference succeeded and we were able
to show that the expression is well-typed. Let's look at an example
where this is not the case. Consider the expression

`if x then x + 1 else y`

We proceed as in the previous example and first introduce type variables for all subexpressions:

```
x: 'a
x: 'b
1: 'c
x + 1: 'd
y: 'e
if x then x + 1 else y: 'f
```

Note that we introduce two type variables for `x` one for each
occurrence of `x` in the expression.

Next, we associate a type variable with each program variable
appearing in the expression:

```
x: 'x
y: 'y
```

Then we generate the typing constraints from all the
subexpressions. From the first occurrence of `x` we infer

`'a = 'x`


From `x + 1` and its subexpressions we infer:

```
'b = 'x
'b = int
'c = int
'd = int
```

From `y` we infer

```
'e = 'y
```

and from `if x then x + 1 else y` we infer

```
'a = bool
'f = 'd
'f = 'e
```

The first of the last three constraints enforces that the condition
being checked, here `x`, must have type `bool`.  The other two
constraints enforce that the two branches of the conditional have the
same type, which is also the type of the entire conditional expression
(since the result value of the conditional is determined by the result
value of the branches).

Thus, in summary, we have the constraints:

```
'a = 'x
'b = 'x
'b = int
'c = int
'd = int
'a = bool
'f = 'd
'f = 'e
```

Now we solve the constraints. Processing the first 5 constraints is
fine and produces the candidate solution

σ₅ = { `'a ↦ int`, `'b ↦ int`, `'x ↦ int`, `'c ↦ int`, `'d ↦ int` }

However, when we process the next constraint

`'a = bool`

and apply σ₅ to both sides, we get:

`int = bool`

which is unsolvable. Thus at this point we abort and report a type error.

If we look back at the original expression

`if x then x + 1 else y`

then we note that this expression uses `x` both in a context that
expects it to be an `int` value and in an context that expects it to
be of type `bool`. Since it can't be both at the same time, we have a
type error. This is exactly what the type inference deduced for us.

#### Inferring Polymorphic Types

One of the great features of ML-style type inference is that solving
the unification problem may produce a unifier that leaves some of the
type variables unconstrained. Such solutions yield polymorphic types. 

As an example consider again our polymorphic function `flip` that
takes a curried function `f` and produces a new function that behaves like `f` but takes its arguments in reverse order:

```ocaml
let flip f x y = f y x
```

To infer the types we proceed as above and solve the type inference problem for the body expression

`f y x`

of the function.

Start with assigning type variables to all subexpressions:

```
f: 'a
y: 'b
x: 'c
f y: 'd
f x y: 'e
```

then assign type variables to all program variables:

```
f: 'f
x: 'x
y: 'y
```

Generate the constraints: from `f`, `y`, and `f` we infer

```
'a = 'f
'b = 'y
'c = 'x
```

From `f y` we infer

`'a = 'b -> 'd`

and from `f y x` we infer

`'d = 'c -> 'e`

Thus, in summary we have:

```
'a = 'f
'b = 'y
'c = 'x
'a = 'b -> 'd
'd = 'c -> 'e
```

Solving the constraints yields the unifier:

σ = { `'a ↦ 'y -> 'x -> 'e`, `'b ↦ 'y`, `'c ↦ 'x`, 
      `'f ↦ 'y -> 'x -> 'e`, `'d ↦ 'x -> 'e` }

Now from the definition of `flip` we know that the type of `flip` is

`flip: 'f -> 'x -> 'y -> 'e`

After applying σ to this type we get:

`flip: ('y -> 'x -> 'e) -> 'x -> 'y -> 'e`

This type tells us that `flip` takes a function of type `'y -> 'x -> 'e` 
and returns a new function of type `'x -> 'y -> 'e`, which
captures that the arguments in the returned function are reversed. The
type is parametric in the type variables `'x`, `'y`, and `'e`. That
is, we can safely apply `flip` to any function that is compatible with
the type `'y -> 'x -> 'e`, including e.g.

```
int -> int -> int
int -> bool -> bool
bool -> int -> int
(int -> bool) -> int -> int
...
```

Also, note that since the specific names of the type variables
appearing in the inferred types do not matter, we can consistently
rename them once the type inference is complete. For instance, if we
rename `'y ↦ 'a`, `x ↦ 'b`, and `'e ↦ 'c`, then we get the type:

`flip: ('a -> 'b -> 'c) -> 'b -> 'a -> 'c`

This is exactly the type that the OCaml compiler infers for `flip`.


#### Limitations of Type System

HM guarantees at compile-time that a program will not *go wrong* when
it is executed if it passes the type checker. Here, "going wrong"
means that the program may get stuck, trying to use a value in a
context it was not supposed to be used (e.g. try to treat an integer
value as if it were a function that can be called). We thus get very
strong correctness guarantees from the compiler. However, as with any
static type system, these guarantees come at a certain cost, namely
that the type checker will reject some programs even though they will
not fail when they are executed. That is, the type checker will reject
all bad programs but also some good ones.

One crucial restriction of the type system has to do with
polymorphism. Only variables that are introduced by `let` bindings can
have polymorphic types. For instance the following Ocaml expression
cannot be typed:

```ocaml
let g f = (f true, f 0) in
let id x = x in
g id
```

The problem here is that the function `f` in `g` is not introduced by
a `let` and therefore can't have a polymorphic type itself. Only `g`'s
type can be polymorphic. That is, once `g` has been applied to a
particular function `f`, the type of that `f` is treated
monomorphically. In contrast, the following expression is OK:

```ocaml
let f x = x in
(f true, f 0)
```

Note that we here provide a specific polymorphic implementation of the
function `f` which we bind with a `let`, rather than parameterizing
over the implementation of `f` as in `g` above.

Due to the nature of this restriction one also refers to the form of
polymorphism supported by HM as *let-polymorphism*. Let-polymorphism
is less expressive than the kind of polymorphism supported by other
static type systems, specifically generics in languages like Java, C#,
and Scala. This problem also does not arise in dynamically typed
languages like JavaScript. For instance, the corresponding JavaScript program
will execute just fine:

```scheme
function g(f) {
  return [f(true), f(0)];
};
function id (x) { return x; };
g(id);
```

The restriction imposed by let-polymorphism is critical for making
static type inference possible. In particular, Java, C#, and Scala do
not support general static type inference because their type systems
are more expressive than HM. This is an example of a trade-off
between static correctness guarantees, automation, and expressivity in
the design of a type system where different languages make different
design choices.

Another limitation of HM has to do with how the type inference
algorithm infers the types of recursive functions. Specifically, this
relates to the "occurs check" during the computation of the unifier in
Case 2 of the algorithm to solve type equations.

To illustrate the issue, consider the following expression

```ocaml
let rec print_more x =
  let _ = print_endline x in
  print_more
```

This function can be viewed as an output channel that we can simply
feed more and more values which are then just printed on standard output:

```ocaml
print_more "Hello" "World" "how" "are" "you"
```

While the function `print_more` should behave just fine when it
executes (and a corresponding Scheme version indeed works as
expected), it is rejected by the OCaml type checker:

```ocaml
# let rec print_more x =
    let _ = print_endline x in
    print_more;;
line 3, characters 4-14:
Error: This expression has type string -> 'a
       but an expression was expected of type 'a
       The type variable 'a occurs inside string -> 'a
```

To understand how this problem arises, consider the following slightly
simplified version of `print_more`:

```ocaml
let rec hungry x = hungry
```

If we apply our type inference algorithm, we generate the following
type variables for the parameters of the recursive definition:

```
hungry: 'h
x: 'x
```

and the following typing constraints from the actual definition:

```
'h = 'x -> 'a
'a = 'h
```

After solving the first constraint we obtain the candidate solution

σ₁ = { `'h ↦ 'x -> 'a` }

which when applied to the second constraint yields

`'a = 'x -> 'a`

At this point we cannot extend σ₁ with a mapping for `'a` because the
occurs check fails: `'a` occurs in the type `'x -> 'a` on the
right-hand side of the equation. 

The equation

`'a = 'x -> 'a`

tells us that the return type of `hungry` is the same type as the type
of `hungry` itself. However, such recursive types cannot be expressed
in OCaml's type system directly for otherwise, the type inference
problem would again become unsolvable. As we shall see, there is a
workaround for this restriction: OCaml allows recursive types to be
introduced explicitly. However, this workaround slightly complicates
the implementation of the function `hungry`.

