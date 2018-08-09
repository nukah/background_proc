# Lazy background processing system

## Installation
1. Checkout repository from `git@github.com:nukah/background_proc.git`
2. Run `bundle install`
3. Run 'bundle exec rake backgroud:processor`


## Internals

Worker classes you want to be executed asynchroniously should derive from base `Worker` class and implement single `perform()` method.

`perform()` method can accept any kinds of arguments, be it named or unnamed ones.

There is one exception, due to serialization protocol, all the arguments should consist of base Ruby types such as Fixnum, Boolean, String, Array, Hash and so on.

## Execution

You should put all your worker logic into `perform()` method definition inside your class and then instantiate execution like `WorkerExample.perform_later(arguments)`

## Logging

Base STDOUT logger is provided from the box, if required it can be overriden in `WorkerProcess` class.

## Worker Supervisor

To run workers on machine you should execute rake task `rake background:processor`
