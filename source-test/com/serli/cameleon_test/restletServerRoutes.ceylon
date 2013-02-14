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

import com.serli.cameleon {
	...
}

import org.restlet { Response }
import org.apache.camel.component.restlet { 
	RestletConstants { responseHeader = \iRESTLET_RESPONSE} }
import org.restlet.data { 
	MediaType { textPlainMediaType = \iTEXT_PLAIN }, 
	Status { successOK = \iSUCCESS_OK } 
}

Routes restletServer = Routes {
	route {
	    from = [ 
	        "restlet:http://localhost:8080/cameleon/com.serli.cameleon_test/{name}",
			"restlet:http://localhost:8080/cameleon/com.serli.cameleon_test"			
	    ];        
        choice {
            when {
				Boolean condition (Exchange exchange)  {
					value headers = exchange.inMessage.headers;
					if (headers.defines("name")) {
						exchange.inMessage.body = headers["name"];
						return true;
					}   
					return false;
                }
            }.do {
				process {
                    void processor(Exchange ex) {
                        if (exists msg = ex.outMessage) {
                            msg.body = "Hello `` ex.inMessage.body else "" ``";
                        } 
                    }
                }
            },
            otherwise {
                process {
                    void processor(Exchange ex) {
                        value response = ex.inMessage.headerAs {
                            header = responseHeader;
                            type = type<Response>;
                        };
                        if (exists response) { 
                            response.status = successOK;
                            response.setEntity(
"Hello From 
    Address : `` response.request.clientInfo.address ``
    Agent : `` response.request.clientInfo.agent ``"
                                   , textPlainMediaType);
                            ex.outMessage?.setBodyAs(response, type<Response>);
                        }
                    }
                }
            }
        }
        ,        
        process {
            void processor (Exchange exchange) {                
                exchange.outMessage?.body = 
"Cool, it works !
 `` (exchange.inMessage.body is Response) 
	then (exchange.inMessage.mandatoryBodyAs<Response>(type<Response>).entityAsText) 
	else exchange.inMessage.body?.string
	else "Oh, no !"``
 ";        
            }
        }
	}
};
