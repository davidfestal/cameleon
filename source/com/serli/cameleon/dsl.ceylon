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

import org.apache.camel.builder { NativeRouteBuilder = RouteBuilder}
import org.apache.camel { Processor, NativeExchange = Exchange, Endpoint, Predicate, ExchangePattern }
import org.apache.camel.model { ExpressionNodeHelper { toExpressionDefinition } , ... }
import org.apache.camel.model.language { ... }
import com.serli.cameleon.model { ... }
import com.serli.cameleon.util { toProcessorModels, castToPredicate, toSequence }

shared Route route(Endpoint|String|Sequence<Endpoint|String> from, {<ProcessorModel|String|Endpoint>+} pipeline)(NativeRouteBuilder builder) {
	if (pipeline.size > 0) {
		return Route(toSequence<Endpoint|String>(from), pipeline, builder);
	}
	throw Exception("Route should always have at least one output");
}

shared ProcessModel process(Anything(Exchange) processor) {
	object nativeProcessor satisfies Processor {
				
				shared actual void process(NativeExchange? exchange) {
					if (exists exchange) {
						processor(Exchange(exchange));
					}
				}
				shared actual String string {
					return "Processor-" + processor.string;
				}
			}
	return ProcessModel(nativeProcessor);
}

shared WhenCondition when(ExpressionBase | Boolean(Exchange) condition) {
	ExpressionBase resultExpression;  

	if (is ExpressionBase condition){
		resultExpression = condition;
	}
	else {
		Boolean(Exchange) p = castToPredicate<Exchange>(condition);
		object predicate satisfies Predicate {
			shared actual Boolean matches(NativeExchange? exchange) {
				if (exists exchange) {
					return p(Exchange(exchange));
				}
				return false;
			}
			shared actual String string {
					return "Predicate-" + p.string;
				}
		}
		object expressionBase extends ExpressionBase() {
			shared actual ExpressionDefinition definition = toExpressionDefinition(predicate);	
		}
		resultExpression = expressionBase;								
	}
	
	return WhenCondition(resultExpression);
}

shared OtherwiseModel otherwise({<ProcessorModel|Endpoint|String>+} pipeline) {
	value steps = toProcessorModels(pipeline);
	if (nonempty steps) {
		return OtherwiseModel(steps);		
	}
	throw Exception("An Otherwise clause must have at least one output");
}

shared ChoiceModel choice({ChoiceBranchModel+} alternatives) {		
		variable OtherwiseModel ? otherwiseClause = null;
		value whenClausesBuilder = SequenceBuilder<WhenModel>();
		
		for (alt in alternatives) {
			switch(alt) 
			case(is WhenModel) {
				whenClausesBuilder.append(alt);
			}
			case (is OtherwiseModel) {
				otherwiseClause = alt;
			}
		}		
		
		value whenClauses = whenClausesBuilder.sequence; 
		if (nonempty whenClauses) {
			return ChoiceModel {
				when = whenClauses;
				otherwise = otherwiseClause;
			};
		}
		throw Exception("A Choice element must have at least one When clause");
}

shared ToModel to(Endpoint | String endpoint, ExchangePattern? pattern = null) {
	return ToModel(endpoint, pattern);
}

shared Element type<Element>() {
	return nothing;
}

