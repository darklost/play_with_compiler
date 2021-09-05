# play_with_compiler
编译原理

## craft [手写词法语法分析器] 

craft : 第2-5讲的资料。手工实现的简单的词法分析器、语法分析器、计算器、脚本解释器。
- SimpleLexer.java：一个简单的词法分析器。
- SimpleCalculator.java：一个简单的计算器，提供了基础的语法分析功能。对表达式的解析会有结合性问题。
- SimpleParser.java: 一个更好的语法解析器。在左递归、优先级和结合性方面都没有问题。
- SimpleScript.java：一个简单的脚本解释器。它提供了一个REPL界面，输入命令并执行。   
     比如，输入： java SimpleScript  
     或：java SimpleScript -v  
     -v 参数会让解释器打印AST和求值过程。 


## antlr [前端工具] 


1. 编译规则文件
    `antlr PlayScript.g4 `还可以带上一些参数，比如：
      - -visitor：生成与visitor模式有关的类。
      - -nolistener：不生成listener类。
      - -package:指定生成的java类的package。

2. 测试语法规则 

    使用grun命令，可以用生成的编译器来解析你写的程序，比如：
    `$ grun antlrtest.PlayScript expression -gui`
      其中:
      -gui参数告诉grun，用图形化的方式来显示生成的AST。否则，它会在终端用lisp的括号嵌套括号的方式显示。
      expression参数是.g4文件中的一条语法规则，所生成的AST的根节点就是代表这个规则的节点。

    >特别注意：
    使用grun是同学们遇到问题最多的地方。最重要的问题，就是目录不对，找不到生成的编译器。 假设你生成的java类在antlr/antlrtest目录下，其中antlrtest是package的名称，你应该在antlr目录下运行grun命令，并且让CLASSPATH包含这个目录。否则，就会报找不到lexer或parser的错误。

    ```

    .\antlr.bat .\antlrtest\Hello.g4

    javac -encoding  UTF-8 .\antlrtest\Hello*.java

    .\grun.bat antlrtest.Hello tokens -tokens .\antlrtest\hello.play


    # 生成
    cd .\antlrtest\
    ..\antlr.bat PlayScript.g4 -visitor
    cd ..
    javac -encoding  UTF-8 .\antlrtest\*.java

    java antlrtest.PlayScript

    ```
