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

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;
import com.redhat.ceylon.compiler.java.metadata.TypeParameter;
import com.redhat.ceylon.compiler.java.metadata.TypeParameters;

@Ceylon(major = 5)
@Method
public final class castToPredicate {
	private castToPredicate() {}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@TypeParameters({ @TypeParameter(value="Element") })
	@TypeInfo("ceylon.language::Callable<ceylon.language::Boolean,ceylon.language::Tuple<Element,Element,ceylon.language::Empty>>")
	public static <Element> ceylon.language.Callable<? extends ceylon.language.Boolean> castToPredicate(
			@Name("predicate") 
			@TypeInfo("ceylon.language::Object")
			final Object predicate) {
			return (ceylon.language.Callable<? extends ceylon.language.Boolean>) predicate;
    }
}
