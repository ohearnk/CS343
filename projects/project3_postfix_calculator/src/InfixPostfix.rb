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
        
    end

    # evaluate the postfix string and returns the result
    def evaluatePostfix(exprStr)
        
    end

    #private # subsequent methods are private methods

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
