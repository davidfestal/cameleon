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

shared module com.serli.cameleon.core '1.0.1' {
	shared import 'org.apache.camel:camel-core' '2.10.1';
    shared import java.base '7';
	shared import 'com.sun.xml.bind.jaxb-impl' '2.2.5';
	shared import 'org.slf4j.slf4j-api' '1.6.6';
    shared import javax.jaxws '7';
    shared import ceylon.collection '0.6';
    shared import ceylon.interop.java '0.6';
}