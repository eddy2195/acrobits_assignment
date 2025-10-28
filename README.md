# Acrobits VoIP assignment
A simple project that showcases LibSoftphone SDK Integration.

# Getting started
<p>
1. Clone repo.<br>
2. Open Acrobits VoIP assignment.xcodeproj.<br>
3. Wait for packages installation. Alternatively go to File -> Packages -> Reset Package caches.<br>
4. Run the active scheme.<br>

# Running the tests
<p>Tests were not executed at point of creation of this file due to environment issue.</p>

# Trade-Offs / Assumptions
<p>
  1. Application is built based on assumption that only one call is taking place at any point of time and it is outgoing call. Also no state restoration implemented.<br>
  2. Local user name is being stored into keychain storage to provide security and ease of maintenance. For something complex I would rather use Realm/CoreData.
  3. Tests were not executed due to environment issue.
  4. Validation of phone number is very basic and has workaround for test number. It can be easily extended since it is separate class.
  5. For a long time I haven't worked with ObjC enums in Swift code, so in order to mimic it - I've declared same enums in Swift. Not sure if it's best approach. Will need to explore that topic further.
</p>
