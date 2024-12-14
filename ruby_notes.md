Being that written by Matsumoto.


- Ruby is completely OOP -- every value including bools, numeric literals & nil are objects.
- Syntax is expression oriented -- rather than "statements"  you can write things like `minimum = if x < y then x else y end`

#### Misc syntax & cheats
- Useful iterators: `select`, `inject`
- printf formatting: `"%d %s" % [3, "rubies"]`
- global variables are prefixed with `$`, instance variables are prefixed with `@`, and class variables are prefixed with `@@`.


#### Symbol Literals
```ruby
h = { # A hash that maps number names to digits
	:one => 1, # The "arrows" show mappings: key=>value
	:two => 2 # The colons indicate Symbol literals
}
```
Symbols are immutable, interned strings, comparable by identity rather than text content.

### Methods

- When defined outside class or module, is practically a global function rather than object-invoked method; in actuality a private method for the `Object` class.
- Can be defined on individual object with a name-prefix, e.g. create a new method upon the core `Math` library: 
```ruby
	def Math.square(x)
		x*x
	end
```
- Class methods are basically instance methods and are implemented on the metaclass of an object, which is linked to a given object through a hash table.
- Methods can return more than one value:
```ruby
	def doThing(a, b)
		[b-a, a+b]
	end
	var1, var2 = doThing(6, 9)
```
- Methods that end with an equals sign (=) are special because Ruby allows them to be invoked using assignment syntax. If an object o has a method named x=, then these are identical:

```ruby
	o.x=(1) # Normal method invocation syntax
	o.x = 1 # Method invocation through assignment
```

- A method name with a `?` suffix indicates a boolean return.
- A method name with a `!` suffix indicates caution is required with the use of the method. 
	- A number of core language methods have an alternative with a bang. 
	- The bangless return a modified copy of the invoked upon object; the bebanged mutate the object in place.

##### Invocation
- Though Ruby supports an ordinary `while` loop, it is more common to perform loops with constructs that are actually method calls, e.g. `1.upto(9) {|x| print x }`
- Asides from generic loop like blocks, you can also use methods that only invoke the block once, e.g. `File.open("file.txt) do { |f| line = f.readline }`.


### Regex/Ranges

Ranges: 
```ruby
	1..3 # All x where 1 <= x <= 3
	1...3 # All x where 1 <= x < 3
```
Regexp and Range objects define the normal == operator for testing equality. In addition, they also define the === operator for testing matching and membership. Ruby’s case statement (like the switch statement of C or Java) matches its expression against each of the possible cases using ===

```ruby
generation = case birthyear
	when 1946..1963: "Baby Boomer"
	when 1964..1976: "Generation X"
	when 1978..2000: "Generation Y"
	else nil
	end
```
### Classes & Modules

- Object state is held by instance variables.
- The `initialize` method is a special overridable keyword method auto-invoked on instance creation:
```ruby
	def initialize(from, to, by)
		@from, @to, @by = from, to, by
	end
```

### String mutability
- Ruby’s strings are mutable. 
- The []= operator allows you to alter the characters of a string or to insert, delete, and replace substrings. 
- The << operator allows you to append to a string.
- The String class defines various other methods that alter strings in place. 
- Because strings are mutable, string literals in a program are not unique objects. If you include a string literal within a loop, it evaluates to a new object on each iteration of the loop. Call the freeze method on a string (or any object) to prevent this.


