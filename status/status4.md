Recap

Worked on current in progress tasks (cryptography, database, UI/UX)

Tasks Completed

A good cryptography library has been found for the project. 4-5 hours spent validating the security of the library. [Matt]

Met with the CEDAR lab to re-define the scope of testing to be done. Two meetings held over the past three weeks. [Matt]

Re-defined scope of project in the event that another member is lost. One meeting held. [Matt and Tyler]

Successes

Found a suitable library for handling encryption/decryption/hashing.

The team at https://www.bouncycastle.org/ has translated their widely used Java crypto API into a Dart/Flutter library. IBM has covered the vulnerabilities within their work, and after reading through them it was decided that the known vulnerabilites were worth accpeting as they did not apply to our specific use cases. Additionally, the organization encourages and promotes FIPS certification when using their cryptography, and as such it is reasonable to assume that their work is also FIPS certified. This makes their cryptography a natural choice for our application. 

Multiple avenues were attempted in an effort to bring our cryptography up to industry standards including an attempt to tap into device specific API's for cryptography, but that ultimately opened the application up to man in the middle style attacks. 

Roadblocks/Challenges

Finding the right solution to our cryptography needs took far more time and effort than originally anticipated. 

Does Cody exist?

If he doesn't, the project scope will need to be modified to account for a two-man team.

Changes/Deviation

If we lose another member of the team, we will have to drop the localized database portion of the planned project. This will result in going all in on Google's tech stack, utilizing Firestore as our database. 

Goals/Plan for next 3 weeks

Finish cryptography update. 

Get basic UI/UX updated

Migrate firebase configuration files to Google Cloud

Confidence

Matt - 3

Tyler - 2

Cody - ???

Group Average - 2.5?
