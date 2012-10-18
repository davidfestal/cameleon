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

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;

@Ceylon(major = 3)
@Method
public final class clazz {
	private clazz() {}
	
	private final static String prefixToDrop = "ceylon.language::Callable<";
	@SuppressWarnings({ "unchecked" })
	@TypeParameters({ @TypeParameter(value="Element") })
	@TypeInfo("java.lang.Class<Element>")
	public static <Element> Class<Element> clazz(
			@Name("callable") 
			@TypeInfo("ceylon.language.Callable<Element>")
			final Object callable) throws ClassNotFoundException {
			String callableString = callable.toString();
			String className = callableString.replace(prefixToDrop, "");
			className = className.substring(0, className.length()-1).replace("::", ".");
			return (Class<Element>) Class.forName(className);
    }
}
