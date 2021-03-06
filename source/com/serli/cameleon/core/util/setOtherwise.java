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

package com.serli.cameleon.core.util;

import org.apache.camel.model.ChoiceDefinition;
import org.apache.camel.model.OtherwiseDefinition;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 5)
@Method
public final class setOtherwise {
	private setOtherwise() {}
	
	@SuppressWarnings({ })
	@TypeInfo("ceylon.language::Anything")
	public static void setOtherwise(
			@Name("choice") 
			@TypeInfo("org.apache.camel.model::ChoiceDefinition")
			final ChoiceDefinition choice, 
			@Name("otherwise") 
			@TypeInfo("org.apache.camel.model::OtherwiseDefinition")
			final OtherwiseDefinition otherwise) {
		choice.setOtherwise(otherwise);
    }
}