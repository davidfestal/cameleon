import ceylon.collection {
	...
}

import org.apache.camel.support { ServiceSupport }

import org.apache.camel.main {
	MainSupport 
}

import org.apache.camel { 
    NativeServiceStatus = ServiceStatus {
        nativeStarting = \iStarting,
        nativeStarted = \iStarted, 
        nativeStopping = \iStopping, 
        nativeStopped = \iStopped, 
        nativeSuspending = \iSuspending, 
        nativeSuspended = \iSuspended
    }, ProducerTemplate, CamelContext
}
import java.util { JMap = Map, JHashMap = HashMap }
import org.apache.camel.view { ModelFileGenerator }
import java.lang { JString = String, ObjectArray }
import com.serli.cameleon.core.util { toCeylonString }
import org.apache.camel.impl { DefaultCamelContext }
import org.apache.camel.model { ModelCamelContext }
import java.util.concurrent { TimeUnit }
import ceylon.language.metamodel.declaration { Package, AttributeDeclaration, OpenParameterisedType, ClassDeclaration }
import ceylon.language.metamodel { Attribute }

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

shared abstract class ServiceStatus() of 
serviceStarting | 
serviceStarted |
serviceStopping |
serviceStopped |
serviceSuspending |
serviceSuspended {
}

shared object serviceStarting extends ServiceStatus() {}
shared object serviceStarted extends ServiceStatus() {}
shared object serviceStopping extends ServiceStatus() {}
shared object serviceStopped extends ServiceStatus() {}
shared object serviceSuspending extends ServiceStatus() {}
shared object serviceSuspended extends ServiceStatus() {}


shared ServiceStatus fromNativeStatus(NativeServiceStatus nativeStatus) {
	if (nativeStatus == nativeStarting) {
		return serviceStarting;
	}
	if (nativeStatus == nativeStarted) {
		return serviceStarted;
	}
	if (nativeStatus == nativeStopping) {
		return serviceStopping;
	}
	if (nativeStatus == nativeStopped) {
		return serviceStopped;
	}
	if (nativeStatus == nativeSuspending) {
		return serviceSuspending;
	}
	if (nativeStatus == nativeSuspended) {
		return serviceSuspended;
	}
	return serviceStopped;
}
 
shared object router extends ServiceSupport() {
    void noop() {}
    Context defaultContext = Context(DefaultCamelContext());
    MutableMap<String, Context> contexts = HashMap<String, Context> { Entry("default", defaultContext) };
    MutableList<RouteBuilder> builders = LinkedList<RouteBuilder>();
    
    shared variable Anything() doAfterStart = noop;
    shared variable Anything() doBeforeStop = noop;

    shared object nativeCamelInstance extends MainSupport() {
        shared actual JMap<JString, CamelContext> camelContextMap = JHashMap<JString, CamelContext>();
        shared actual ModelFileGenerator? createModelFileGenerator() => null;
        shared actual ProducerTemplate findOrCreateCamelTemplate() => nothing; /* TODO auto-generated stub */
        shared actual void afterStart() => doAfterStart();
        shared actual void beforeStop() => doBeforeStop();
        shared actual void doStart() {            
             // Refine doStart and doStop to start and stop contexts (start if started automatically) (cf Main)
			super.doStart();
	        for (name->context in contexts) {
	            CamelContext camelContext = context.nativeContext;
	            camelContexts.add(camelContext);
	        }

	        for (routeBuilder in builders) {
	            if (exists routeBuilderContext = routeBuilder.context) {
		            routeBuilderContext.nativeContext.addRoutes(routeBuilder.nativeBuilder);
	            }
	            else {
	                defaultContext.nativeContext.addRoutes(routeBuilder.nativeBuilder);
	            }
	        }
	        
	        for (name->context in contexts) {
	            generateDot(name, context.nativeContext, contexts.size);
	        }
	        
	        if (aggregateDot) {
				CamelContext aggregatedContext;
				
		        if (contexts.size == 1) {
		            aggregatedContext = defaultContext.nativeContext;
		        } else {
		            aggregatedContext = DefaultCamelContext();
		            for (CamelContext camelContext in contexts.map((String->Context elem) => elem.item.nativeContext)) {
		                if (is ModelCamelContext modelContext = camelContext) {
			                aggregatedContext.addRouteDefinitions(modelContext.routeDefinitions);
		                }
		            }
		        }
		        
	            generateDot("aggregate", aggregatedContext, 1);
	        }
	
	        if (routesOutputFile exists) {
	            outputRoutesToFile();
	        }
	        for (context in contexts.values) {
	            context.nativeContext.start();
	        }
        }
        
        shared actual void doStop() {
            for (context in contexts.values) {
	            context.nativeContext.stop();
	        }

        }
    }
    
    shared void parseArguments([String+] arguments) 
    	=> nativeCamelInstance.parseArguments(ObjectArray<JString>(arguments.size));

    shared actual void doStart() => nativeCamelInstance.start();
    shared actual void doStop() => nativeCamelInstance.stop();
    shared actual void doResume() => nativeCamelInstance.resume();
    shared actual void doSuspend() => nativeCamelInstance.suspend();
    shared actual void doShutdown() => nativeCamelInstance.shutdown();

    shared ServiceStatus serviceStatus => fromNativeStatus(nativeCamelInstance.status);

	shared void run() => nativeCamelInstance.run();
    shared void enableHangupSupport() => nativeCamelInstance.enableHangupSupport();    
    shared void enableTrace() => nativeCamelInstance.enableTrace();
    shared Boolean aggregateDot => nativeCamelInstance.aggregateDot;    
    assign aggregateDot {
        nativeCamelInstance.aggregateDot = aggregateDot;
    }
    shared TimeUnit timeUnit => nativeCamelInstance.timeUnit;
    assign timeUnit {
        nativeCamelInstance.timeUnit = timeUnit;
    }
    shared Integer duration => nativeCamelInstance.duration;
    assign duration {
        nativeCamelInstance.duration = duration;
    }
    shared Boolean trace => nativeCamelInstance.trace;
    shared String dotOutputDir => nativeCamelInstance.dotOutputDir;
    assign dotOutputDir {
        nativeCamelInstance.dotOutputDir = dotOutputDir;
    }

    
    shared void addContexts({<String->Context>+} contexts) {
         for(name->context in contexts) {
             // setName : ne peut pas être appelé ???
             this.contexts.put(name, context);
         }
    }
    
    shared void addBuilders({RouteBuilder+} builders) {
        this.builders.addAll(builders);
    }

    shared void addBuildersSharedFromPackages({Package*} packages) {
		value sequenceBuilder = SequenceBuilder<RouteBuilder>();
	    for (pkg in packages) {
	        for (attribute in pkg.members<AttributeDeclaration>().filter((AttributeDeclaration elem) => ! elem.annotations<Shared>().empty).map((AttributeDeclaration elem) => elem.apply())) {
	            if (is Attribute<RouteBuilder> routeBuilderAttribute = attribute) {
			        sequenceBuilder.append(routeBuilderAttribute.get());
	            }
	        }
		}
        this.builders.addAll(sequenceBuilder.sequence);
    }
}

shared class Context(nativeContext) {
	shared CamelContext nativeContext;
}
