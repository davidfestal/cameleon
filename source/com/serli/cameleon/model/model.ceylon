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

import org.apache.camel.builder { NativeRouteBuilder = RouteBuilder }
import org.apache.camel.model { ... }
import org.apache.camel { Processor, Endpoint, ExchangePattern}
import com.serli.cameleon.util { addOutput, toProcessorModels, setOtherwise }

shared class Route(Sequence<Endpoint|String> from, 
{<ProcessorModel | String | Endpoint>+} steps, 
NativeRouteBuilder builder) {
	shared RouteDefinition definition;
	value firstEndpoint = from.first;

	if (is Endpoint firstEndpoint) {
		definition = builder.from(firstEndpoint);
	}
	else if (is String firstEndpoint) {
		definition = builder.from(firstEndpoint);
	}
	else {
		throw Exception("Should never occur !");
	}
	
	for (additionalEndpoint in from.rest ) {
		if (is Endpoint additionalEndpoint) {
			definition.from(additionalEndpoint);
		}
		if (is String additionalEndpoint) {
			definition.from(additionalEndpoint);
		}
	}
	
	for (output in toProcessorModels(steps)) {
		addOutput(definition, output.definition);			
	}
	
	shared actual String string = definition.string;
}

shared class RouteSteps(outputs) {
	shared {ProcessorModel*} outputs;
	shared actual String string = outputs.string;
}

shared abstract class ProcessorModel({ProcessorModel*} outputs) 
of ChoiceModel | ExpressionNodeModel | NoOutputModel | OutputModel {
	shared formal Object definition;
}

shared abstract class NoOutputModel() 
of ProcessModel | SendModel 
extends ProcessorModel({}) {
	
}

shared abstract class OutputModel({ProcessorModel*} outputs) 
of OtherwiseModel  
extends ProcessorModel(outputs) {
	
}

shared class ProcessModel(Processor processor) 
extends NoOutputModel() {
	shared actual ProcessDefinition definition = ProcessDefinition(processor);
	shared actual String string = definition.string; 
}

shared abstract class SendModel() 
of ToModel 
extends NoOutputModel() {
	
}

shared class ToModel(Endpoint|String endpoint, ExchangePattern? pattern) 
extends SendModel() {
	shared actual ToDefinition definition;
	if (exists pattern) {
		if(is Endpoint endpoint) {
			definition = ToDefinition(endpoint, pattern);
		}
		else if (is String endpoint) {
			definition = ToDefinition(endpoint, pattern);
		}
		else {
			throw Exception("Should never occur !");
		}
	} 
	else {
		if(is Endpoint endpoint) {
			definition = ToDefinition(endpoint);
		}
		else if (is String endpoint) {
			definition = ToDefinition(endpoint);
		}
		else {
			throw Exception("Should never occur !");
		}
	}
	shared actual String string = definition.string;
}

shared abstract class ExpressionNodeModel(ExpressionBase expression, {ProcessorModel*} outputs ) 
extends ProcessorModel(outputs) {
	
}

shared class ChoiceModel(Sequence<WhenModel> when, OtherwiseModel ? otherwise) 
extends ProcessorModel({}) {
	shared actual ChoiceDefinition definition = ChoiceDefinition();
	for (whenClause in when) {
		definition.whenClauses.add(whenClause.definition);
	}
	if (exists otherwise) {
		setOtherwise(definition, otherwise.definition);
	}
	shared actual String string = definition.string;	
}

shared class WhenCondition(ExpressionBase condition) {
	shared WhenModel do({<ProcessorModel|Endpoint|String>+} pipeline) {
		value steps = toProcessorModels(pipeline);
		if (nonempty steps) {
			return WhenModel(condition, steps);		
		}
		throw Exception("A When clause must have at least one output");
	}
}

shared interface ChoiceBranchModel
	of WhenModel | OtherwiseModel {
	
}

shared class WhenModel(ExpressionBase when, {ProcessorModel*} outputs) extends ExpressionNodeModel(when, outputs)
	satisfies ChoiceBranchModel {
	shared actual WhenDefinition definition = WhenDefinition(when.definition);
	for (output in outputs) {
		addOutput(definition, output.definition);
	}
	shared actual String string = definition.string;
}

shared class OtherwiseModel({ProcessorModel*} outputs) extends OutputModel(outputs) 
	satisfies ChoiceBranchModel {
	shared actual OtherwiseDefinition definition = OtherwiseDefinition();
	for (output in outputs) {
		addOutput(definition, output.definition);
	}
	shared actual String string = definition.string;
}