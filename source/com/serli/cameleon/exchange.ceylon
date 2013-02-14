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

import java.lang {
	JBoolean = Boolean
}

import org.apache.camel {
	NativeExchange = Exchange, NativeMessage = Message, ExchangePattern, CamelContext, Endpoint
}
import com.serli.cameleon.util { 
	setException,
	fromJavaList, 
	fromJavaMap, 
	clazz, 
	nullObject 
}

import java.lang { ClassCastException, ClassNotFoundException }
import org.apache.camel.spi { Synchronization, UnitOfWork }

shared class Exchange(nativeExchange) {
	shared NativeExchange nativeExchange;
	
	shared actual String string {
		return nativeExchange.string;
	}
	
	shared void addOnCompletion(Synchronization synchronization) {
		nativeExchange.addOnCompletion(synchronization);
	}

	shared Boolean containsOnCompletion(Synchronization synchronization) {
		return nativeExchange.containsOnCompletion(synchronization);
	}

	shared CamelContext context = nativeExchange.context;

	shared Exchange copy() {
		return Exchange(nativeExchange.copy());
	}

	shared Exception? exception {
		return nativeExchange.exception;
	}
	assign exception {
		setException(nativeExchange, exception else nullObject());
	}

	throws(ClassCastException, "if the className doesn't name a Throwable")  
	throws(ClassNotFoundException, "if the className doesn't name a known class")
	shared T? exceptionAs<T>(T() type) {
		return nativeExchange.getException(clazz(type)); 
	}
	
	shared String exchangeId {
		return nativeExchange.exchangeId;
	}
	assign exchangeId {
		nativeExchange.exchangeId = exchangeId;
	}

	shared Boolean? externalRedelivered {
		JBoolean? externalRedeliveredNative = nativeExchange.externalRedelivered;
		return externalRedeliveredNative?.booleanValue();
	} 

	shared Boolean failed {
		return nativeExchange.failed;
	}

	shared Endpoint fromEndpoint {
		return nativeExchange.fromEndpoint;
	}
	
	shared String fromRouteId { 
		return nativeExchange.fromRouteId;
	}

	shared Boolean rollbackOnly {
		return nativeExchange.rollbackOnly;
	}

	shared Boolean transacted {
		return nativeExchange.transacted;
	}

	shared UnitOfWork? unitOfWork {
		return nativeExchange.unitOfWork;
	}
	assign unitOfWork {
		nativeExchange.unitOfWork = unitOfWork else nullObject();
	}

	shared Boolean hasOut {
		return nativeExchange.hasOut();
	} 

	shared ExchangePattern pattern  {
		return nativeExchange.pattern;
	}
	assign pattern {
		nativeExchange.pattern = pattern;
	}

	shared Boolean hasProperties {
		return nativeExchange.hasProperties();
	}
	
	shared Message inMessage {
		return Message(nativeExchange.\iin);
	}
	assign inMessage {
		nativeExchange.\iin = inMessage.nativeMessage;
	} 

	shared T? inMessageAs<T>(T() type) {
		return nativeExchange.getIn(clazz(type));
	}
	
	shared Message? outMessage {
		NativeMessage? nativeMessage = nativeExchange.\iout;
		if (exists nativeMessage) {
			return Message(nativeMessage);
		}
		else {
			return null;
		}
	}
	assign outMessage {
		nativeExchange.\iout = outMessage?.nativeMessage else nullObject();
	}
	
	shared T? outMessageAs<T>(T() type) {
		return nativeExchange.getOut(clazz(type));
	}
		
	shared Object? removeProperty(String string) {
		return nativeExchange.removeProperty(string);
	}

	shared void setProperty(String name, Object propertyValue) {
		nativeExchange.setProperty(name, propertyValue);
	}

	shared T? propertyAs<T>(String name, T() type) {
		return nativeExchange.getProperty(name, clazz(type));
	}
		

	shared Map<String,Object> properties = fromJavaMap(nativeExchange.properties);

	shared List<Synchronization> handoverCompletions = fromJavaList(nativeExchange.handoverCompletions());
}