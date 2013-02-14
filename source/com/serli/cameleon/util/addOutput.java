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

package com.serli.cameleon.util;

import org.apache.camel.model.ProcessorDefinition;
import org.apache.camel.model.RouteDefinition;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 4)
@Method
public final class addOutput {
	private addOutput() {}
	
	@SuppressWarnings({ "rawtypes" })
	@TypeInfo("Anything")
	public static void addOutput(
			@Name("container") 
			@TypeInfo("ceylon.language::Object")
			final Object container, 
			@Name("output") 
			@TypeInfo("ceylon.language::Object")
			final Object output) {
		if (! (output instanceof ProcessorDefinition)) {
			return;
		}
		
		if (! (container instanceof ProcessorDefinition)) {
			return;
		}
		
		ProcessorDefinition processor = (ProcessorDefinition) output;
		if (container instanceof RouteDefinition) {
			((RouteDefinition) container).addOutput(processor);
		}
		else if (container instanceof ProcessorDefinition) {
			((ProcessorDefinition) container).addOutput(processor);
		}
    }
}
