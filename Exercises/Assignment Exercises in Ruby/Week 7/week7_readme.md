# SWE 212 Analysis of Programming Languages
## Week 7 Exercises

### Exercise #27 TwentySeven.rb
How to run:

    cd Week7
    ruby TwentySeven.rb ../pride-and-prejudice.txt
  
For Assessing Functionality of Exercise 27.2, simply add the path(s) to the text files you wish to get term frequency of as a the command line argument as you run the program from shell.  I have included some text files for your convenience in the Repl. You can use them or you can choose to upload and use your own text files. 

**For example**: 
`ruby TwentySeven.rb ../pride-and-prejudice.txt ../on-the-origin-of-species.txt`

**Note** - Since 'Pride and Prejudice' has many frequenctly occuring non_stop_words with the 25th most frquent being 'good - 201', the term frequencies of the words of the additonal text you added may or may not make it to the top 25 term frequencies list. Please do keep that in mind while assessing the results. You may even change the code to show the top 50 instead of top 25 to see that the program produces the correct output. Thank you!

 
  ### Exercise #28 TwentyEight.rb
  How to run:
  
    cd Week7
    ruby TwentyEight ../pride-and-prejudice.txt

**Note about Geneators implementation in Ruby**<br>
Ruby's  `yield`  keyword is something very different from the Python keyword with the same name, so don't be confused by it. Ruby's  `yield`  keyword is syntactic sugar for calling a block associated with a method.

Well, the Ruby language does not have generators. It does have  [Fibers](https://ruby-doc.org/core-2.5.0/Fiber.html), which can accomplish pretty much the same thing[1](https://www.giulianomega.com/post/2019-11-11-generators/#fn1), but, more interestingly from a learning perspective, it has  [native support for continuations](https://ruby-doc.org/core-2.5.0/Continuation.html).

[Continuations](https://en.wikipedia.org/wiki/Continuation)  are a powerful control flow construct which allows you to “save” the current state of a computation and then resume it from that saved state whenever you like. This is similar to what generators do, except that with a generator you have a structured relationship between two computations which progress taking turns, on one end we have the  _caller_computation, which transfers control to the generator whenever it calls  `next`and, on the other, we have the  _generator_  computation, which transfers control back to the caller whenever it calls  `yield`. Continuations will simply transfer control from the caller to an arbitrary saved state, forgetting that the caller ever existed. In particular, it is perfectly possible for a computation to transfer control back to an earlier point of itself. In such situations, the only trace you will have that something else has happened when resuming said saved state are the eventual side effects that the preceding computation may have left behind before jumping back.
[Fibers](https://ruby-doc.org/core-2.5.0/Fiber.html)  can actually do more. Like the continuation-based generators we develop here, they snapshot the entire call stack. This means that if you call a second function from your generator, and then that fuction calls a third function, and then this third function calls  `yield`, things are still going to work: the call to  `yield`  will return control to the caller, and the next call to  `next`  will resume from inside of the third function call, with the call stack just as it was. Not so with Python generators, which will not work across nested calls.[↩︎](https://www.giulianomega.com/post/2019-11-11-generators/#fnref1)