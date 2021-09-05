# play_with_compiler
编译原理

## craft [手写词法语法分析器] 

```
craft : 第2-5讲的资料。手工实现的简单的词法分析器、语法分析器、计算器、脚本解释器。
  + SimpleLexer.java：一个简单的词法分析器。
  + SimpleCalculator.java：一个简单的计算器，提供了基础的语法分析功能。对表达式的解析会有结合性问题。
  + SimpleParser.java: 一个更好的语法解析器。在左递归、优先级和结合性方面都没有问题。
  + SimpleScript.java：一个简单的脚本解释器。它提供了一个REPL界面，输入命令并执行。   
     比如，输入： java SimpleScript  
     或：java SimpleScript -v  
     -v 参数会让解释器打印AST和求值过程。 
```

## antlr [前端工具] 

```

.\antlr.bat .\antlrtest\Hello.g4

javac .\antlrtest\Hello*.java

.\grun.bat antlrtest.Hello tokens -tokens .\antlrtest\hello.play

```
