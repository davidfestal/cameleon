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

import org.apache.camel.model { ... }
import org.apache.camel.builder { NativeRouteBuilder = RouteBuilder }
import org.apache.camel { CamelContext }
import com.serli.cameleon.core.model { ... } 


shared class RouteBuilder(shared {Route(RouteBuilder)+} routes, context = null) {
    shared Context? context;
    variable NativeRouteBuilder? hiddenBuilder = null;
    class BuilderInitializer(CamelContext? theContext) extends NativeRouteBuilder(theContext) {
        shared actual void configure() {
            for (routeToBuild in routes) {
                routeToBuild(outer);
            }
        }
    }
    shared NativeRouteBuilder nativeBuilder {
        if (! (hiddenBuilder exists)) {
            hiddenBuilder = BuilderInitializer(context?.nativeContext else null);
        }
        assert (exists h = hiddenBuilder);
        return h;
    }
}

