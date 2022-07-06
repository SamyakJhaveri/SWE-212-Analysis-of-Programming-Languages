# SWE 212 Analysis of Programming Languages
## Week 6 Exercises

### TwentyNine.rb
How to run:

    cd Week6
    ruby TwentyNine.rb ../pride-and-prejudice.txt
  
  You will see some lines of information about repl it getting the gem file for the Celluloid library. 
  **Note about Celluloid:** The Celluloid library that I have used here has been approved to use from the Faculty beforehand. Celluloid is a concurrent object oriented programming framework for Ruby which lets you build multithreaded programs out of concurrent objects just as easily as you build sequential programs out of regular objects.
[Celluloid](https://github.com/celluloid/celluloid) is one of the most popular implementations. Under the hood, it runs each Actor in a separate thread and uses fibers for every method invocation to avoid blocking methods while waiting for responses from other Actors.
The Celluloid implementation abstracts the `dispatch()` method,  into itself so that is why you may not notice a dispatch() method in my running code. However, I have maintained the style of the code as specified by the Faculty and in her book. Please consider and grade my code with that in mind. Thank you vey much! :)
  
  ### Thirty.rb
  How to run:
  

    cd Week6
    ruby Thirty.rb ../pride-and-prejudice.txt

### ThirtyTwo.sc
How to run:

    cd Week6
    scala ThirtyTwo.sc ../pride-and-prejudice.txt 
Select `scala.out`
