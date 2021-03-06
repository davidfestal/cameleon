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

import org.apache.camel.Exchange;

import com.redhat.ceylon.compiler.java.metadata.Ceylon;
import com.redhat.ceylon.compiler.java.metadata.Method;
import com.redhat.ceylon.compiler.java.metadata.Name;
import com.redhat.ceylon.compiler.java.metadata.TypeInfo;

@Ceylon(major = 5)
@Method
public class setException {
	private setException() {}
	
	@SuppressWarnings({ })
	@TypeInfo("ceylon.language::Anything")
	public static void setException(
			@Name("exchange") 
			@TypeInfo("org.apache.camel::Exchange")
			final Exchange exchange, 
			@Name("exception") 
			@TypeInfo("ceylon.language::Exception")
			final Throwable exception) {
		exchange.setException(exception);
    }
}
