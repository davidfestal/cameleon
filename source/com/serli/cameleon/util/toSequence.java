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

import ceylon.language.Singleton;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;

@Ceylon(major = 4)
@Method
public final class toSequence {
	private toSequence() {}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@TypeParameters({ @TypeParameter(value="Element") } )
	@TypeInfo("ceylon.language::Sequence<Element>")
	public static <Element> ceylon.language.Sequence<? extends Element> toSequence(
			@Name("elements") 
			@TypeInfo("Element|ceylon.language::Sequence<Element>")
			final Object oneOrSeveralElements) {
		if (oneOrSeveralElements instanceof ceylon.language.Sequence) {
			return (ceylon.language.Sequence<Element>) oneOrSeveralElements;
		}
		else {
			return new Singleton<Element>((Element) oneOrSeveralElements);
		}
    }
}
