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

import org.apache.camel { Main }
import org.apache.camel.model { ModelHelper { dumpModelAsXml } }


doc "Run the module `com.serli.cameleon_test`."
shared void run() {
	object main extends Main() {
		shared actual void afterStart() {
			// Dumps the model as XML on stdout
			print(dumpModelAsXml(restletServer.builder.routeCollection));
		}
	}
				    
	// enable hangup support so you can press ctrl + c to terminate the JVM
    main.enableHangupSupport();
	
	// Generate a dot graph of the routes in the ./dot directory 
    main.dotOutputDir = "dot";
    main.aggregateDot = true;

	// add routes
	main.addRouteBuilder(restletServer.builder);
        
    // run until you terminate the JVM
    print("Starting Camel. Use ctrl + c to terminate the JVM.\n");
    print("To com.serli.cameleon_test, hit the following URLs :
           http://localhost:8080/http://localhost:8080/cameleon/com.serli.cameleon_test
    	      http://localhost:8080/http://localhost:8080/cameleon/com.serli.cameleon_test/<your name>");
    main.run();
}


