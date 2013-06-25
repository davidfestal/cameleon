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

import org.apache.camel {
	NativeMessage = Message, InvalidPayloadException
}
import com.serli.cameleon.core.util { 
	fromJavaMap,
	nullObject
}

import javax.activation { DataHandler }
import com.serli.cameleon.core { Exchange }
import ceylon.language.metamodel { ... }
import ceylon.interop.java { javaClass }

shared class Message(nativeMessage) {
	
	shared NativeMessage nativeMessage;
	
	shared actual String string {
		return nativeMessage.string;
	}
	
	shared void addAttachment(String id, DataHandler content) {
		nativeMessage.addAttachment(id, content);
	}

	shared Map<String,DataHandler> attachments = fromJavaMap(nativeMessage.attachments);
	
	shared Message copy() {
		return Message(nativeMessage.copy());
	}

	shared void copyFrom(Message message) {
		nativeMessage.copyFrom(message.nativeMessage);
	}

	shared String createExchangeId() {
		return nativeMessage.createExchangeId();
	}

	shared Exchange exchange {
		return Exchange(nativeMessage.exchange);
	}

	shared Boolean fault {
		return nativeMessage.fault;
	}
	assign fault {
		
		nativeMessage.fault = fault; 
	}

	shared DataHandler? getAttachment(String string) {
		return nativeMessage.getAttachment(string);
	}

	shared Object? body {
		return nativeMessage.body;
	}
	assign body {
			nativeMessage.body = body else nullObject();
	}
	
	shared T? bodyAs<T>() {
			return nativeMessage.getBody(javaClass<T>());
	}	
	
	shared void setBodyAs<T>(T? body) {
		nativeMessage.setBody(body else nullObject(), javaClass<T>());
	}	

	shared void setHeader(String name, Object header) {
		nativeMessage.setHeader(name, header);
	}

	shared T? headerAs<T>(String header) {
		return nativeMessage.getHeader(header, javaClass<T>());
	}
	
	throws(InvalidPayloadException, "If the body is null")
	shared Object mandatoryBody { 
		return nativeMessage.mandatoryBody;
	}

	shared T mandatoryBodyAs<T>() {
		return nativeMessage.getMandatoryBody<T>(javaClass<T>()); 
	}
	
	shared Boolean hasAttachments {
		return nativeMessage.hasAttachments();
	}

	shared Boolean hasHeaders {
		return nativeMessage.hasHeaders();
	}

	shared Map<String,Object> headers = fromJavaMap(nativeMessage.headers);

	shared String messageId {
		return nativeMessage.messageId;
	}
	assign messageId {
		nativeMessage.messageId = messageId;
	}

	shared void removeAttachment(String string) {
		nativeMessage.removeAttachment(string);
	}

	shared Object? removeHeader(String string) {
		return nativeMessage.removeHeader(string);
	}

	shared Boolean removeHeaders(String pattern, String* excludePatterns) {
		return nativeMessage.removeHeaders(string, *excludePatterns);
	}
}