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

import java.util { JMap = Map, JList = List, JSet = Set }
import java.lang { JString = String }
import com.serli.cameleon.model { ... }
import org.apache.camel { Endpoint }


shared ProcessorModel[] toProcessorModels({<ProcessorModel | Endpoint | String>*} steps) {
	value processorModels = steps.collect<ProcessorModel> {
		function collecting(ProcessorModel | Endpoint | String elem) {
			if (is ProcessorModel elem) {
				return elem;
			}
			else if (is Endpoint | String elem) {
				return ToModel(elem, null);
			}
			else {
				return nothing;
			}
		}
	};	
	return processorModels;
}

shared List<Element> fromJavaList<Element>(JList<Element>? javaList) {
	if (exists javaList) {
		value sequenceBuilder = SequenceBuilder<Element>();
		value iterator = javaList.iterator();
		while(iterator.hasNext()) {
			value element = iterator.next();
			sequenceBuilder.append(element);
		}
		Element[] values = sequenceBuilder.sequence;
		if (nonempty values) {
			return LazyList(values);
		}
		else {
			return LazyList(emptyOrSingleton(null));
		}
	}
	else {
		return LazyList(emptyOrSingleton(null));
	}	
}

shared Set<Element> fromJavaSet<Element>(JSet<Element>? javaSet) 
given Element satisfies Object {
	if (exists javaSet) {
		value sequenceBuilder = SequenceBuilder<Element>();
		value iterator = javaSet.iterator();
		while(iterator.hasNext()) {
			value element = iterator.next();
			sequenceBuilder.append(element);
		}
		Element[] values = sequenceBuilder.sequence;
		if (nonempty values) {
			return LazySet(values);
		}
		else {
			return LazySet(emptyOrSingleton(null));
		}
	}
	else {
		return LazySet(emptyOrSingleton(null));
	}
}

shared Map<String, Value> fromJavaMap<Value>(JMap<JString,Value>? javaMap)
given Value satisfies Object {
	if (exists javaMap) {
		value keysBuilder = SequenceBuilder<String>();
		value valuesBuilder = SequenceBuilder<Value>();
		value iterator = javaMap.entrySet().iterator();
		while(iterator.hasNext()) {
			value entry = iterator.next();
			keysBuilder.append(toCeylonString(entry.key));
			valuesBuilder.append(entry.\ivalue);
		}
		String[] keys = keysBuilder.sequence;
		Value[] values = valuesBuilder.sequence;
		if (nonempty keys, nonempty values) {
			return LazyMap(zip(keys, values));
		}
		else {
			return LazyMap(emptyOrSingleton<Entry<String, Value>>(null));
		}
	}
	else {
		return LazyMap(emptyOrSingleton<Entry<String, Value>>(null));
	}
}
