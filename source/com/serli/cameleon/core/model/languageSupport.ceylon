/*
  Copyright 2012 SERLI

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import org.apache.camel.model.language { 
    ExpressionDefinition, 
    NativeSimpleExpression = SimpleExpression
}
import com.serli.cameleon.core { Exchange }
import org.apache.camel { Predicate, NativeExchange = Exchange }
import org.apache.camel.model  { ExpressionNodeHelper { toExpressionDefinition } } 

shared abstract class ExpressionBase() of SimpleExpression | PredicateExpression {
	shared formal ExpressionDefinition definition;
}

final shared class SimpleExpression(String expression) extends ExpressionBase() {
    definition = NativeSimpleExpression(expression); 
}

final shared class PredicateExpression(Boolean(Exchange) condition) extends ExpressionBase() {
    object predicate satisfies Predicate {
        shared actual Boolean matches(NativeExchange? exchange) {
            if (exists exchange) {
                return condition(Exchange(exchange));
            }
            return false;
        }
        shared actual String string {
                return "Predicate-" + condition.string;
            }
    }
    definition = toExpressionDefinition(predicate); 
}
