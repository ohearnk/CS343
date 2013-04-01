#
# InfixPostfix class contains methods for infix to postfix conversion and
# postfix expression evaluation.
#
class InfixPostfix
    INPUT_DICT = {
        '+'=>1,
        '-'=>1,
        '*'=>2,
        '/'=>2,
        '%'=>2,
        '^'=>4,
        '('=>5
    }
    STACK_DICT = {
        '+'=>1,
        '-'=>1,
        '*'=>2,
        '/'=>2,
        '%'=>2,
        '^'=>3,
        '('=>-1
    }


    # converts the infix expression string to postfix expression and returns it
    def infixToPostfix(exprStr)
        stack = []
        postfixStr = ""
        exprStr.split(' ').each do |str|
            if operand?(str) then postfixStr += str + " "
            elsif leftParen?(str) then stack.push(str)
            elsif operator?(str) then
                # pop operators off the stack to preserve
                # precedence of operations, and append to postfixStr
                while (not stack.empty?()) and STACK_DICT[stack.last()] >= INPUT_DICT[str]
                    postfixStr += stack.pop() + " "
                end
                # don't forgot to push the current operator
                stack.push(str)
            elsif rightParen?(str) and stack.include?('(') then
                while stack.last() != '('
                    postfixStr += stack.pop() + " "
                end
                # don't forget to remove the left parenthesis
                stack.pop()
            else
                puts "Oh, no..."
            end
        end
        # add the remaining operators on the stack to the postfixStr
        while not stack.empty?()
            postfixStr += stack.pop() + " "
        end
        # remove trailing whitespace
        postfixStr.chomp!(' ')
        # return postfixStr
        postfixStr
    end

    # evaluate the postfix string and returns the result
    def evaluatePostfix(exprStr)
        stack = []
        exprStr.split(' ').each do |str|
            if operand?(str) then stack.push(str.to_i)
            elsif operator?(str) and stack.length() >= 2 then
                y = stack.pop()
                x = stack.pop()
                stack.push(applyOperator(x,y,str))
            else
                puts "Uh, oh..."
            end
        end
        stack.pop()
    end

    private # subsequent methods are private methods

    # returns true if the input is an operator and false otherwise
    def operator?(str)
        return true if str =~ /\A[-+*\%^]{1}\Z/
        false
    end

    # returns true if the input is an operand and false otherwise
    def operand?(str)
        return true if str =~ /\A[0-9]+\Z/
        false
    end

    # returns true if the input is a left parenthesis and false otherwise
    def leftParen?(str)
        return true if str == "("
        false
    end

    # returns true if the input is a right parenthesis and false otherwise
    def rightParen?(str)
        return true if str == ")"
        false
    end

    # returns the stack precedence of the input operator
    def stackPrecedence(operator)
        InfixPostfix::STACK_DICT[operator]
    end

    # returns the input precedence of the input operator
    def inputPrecedence(operator)
        InfixPostfix::INPUT_DICT[operator]
    end

    # applies the operators to num1 and num2 and returns the result
    def applyOperator(num1, num2, operator)
        result = case operator
            when '+' then (num1+num2)
            when '-' then (num1-num2)
            when '*' then (num1*num2)
            when '/' then (num1/num2)
            when '%' then (num1%num2)
            when '^' then (num1**num2)
        end
        result
    end
  
end # end InfixPostfix class

=begin
a = InfixPostfix.new()
puts a.stackPrecedence('+')
puts a.inputPrecedence('*')
puts a.applyOperator(2,5,'^')
puts a.operator?('+')
puts a.operator?('|')
puts a.operator?('12+2')
puts "--------"
puts a.operand?('123')
puts a.operand?('02102')
puts a.operand?('a1')
puts "--------"
puts a.evaluatePostfix("2 3 +")
puts a.evaluatePostfix("2 3 5 + 2 - 6 + *")
puts a.evaluatePostfix("2 3 5 + 2 - 6 + * /")
puts "--------"
puts a.infixToPostfix("4 + 5")
puts a.infixToPostfix("4 * ( 5 + 2 )")
puts a.infixToPostfix("2 + 3 * ( 5 - 2 ) + 6")
puts a.evaluatePostfix(a.infixToPostfix("2 + 3 * ( 5 - 2 ) + 6"))
=end
