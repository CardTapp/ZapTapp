# ZapTapp Salesforce_integration
Salesforce resources for integration with Cardtapp via Zapier

v1.13
2017-05-16

See package.xml for contents
See help_docs folder for workflow diagrams

Installation link:  https://test.salesforce.com/packaging/installPackage.apexp?p0=04tJ00000006U73

Release notes:
- Standardized naming convention of all classes and assets for consistency to avoid potential naming conflicts
- Refactored CardtappAttachTapper and CardtappAttachTapperHelper to allow for handling of both Lead and Contact object types
- Added CardtappQueryBuilder class to support dynamic SOQL select statements
- Added notification preferences at the User level and support for notification flagging at Tapper creation
- Added workflow rules, email templates and email alerts for notification workflows
- Fixes validation issue related to required LastName fields in newly created Lead and Contact records.



Open source notice - MIT license:

Copyright (c) 2017 CardTapp

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


